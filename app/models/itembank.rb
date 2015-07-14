class Itembank < ActiveRecord::Base
  mount_uploader :source, WorkbookUploader
  after_save :parse_items!
  has_many :items
  has_many :choice_option_sets, primary_key: :choice_options_id

  def source_as_workbook
    @source_as_workbook ||= Workbook::Book.open(source.file.file)
  end

  def parse_items!
    items.destroy_all
    choice_option_sets.destroy_all
    header = nil
    source_as_workbook.first.first.each do |row|
      if header == nil
        header = row
      else
        item = Item.new(itembank: self)
        row.to_hash.each do |key, value|
          item.public_send("#{key}=", (value ? value.value : nil))
        end
        item.save
      end
    end
    header = nil
    source_as_workbook.last.first.each do |row|
      if header == nil
        header = row
      else
        item = ChoiceOptionSet.new(itembank: self)
        row.to_hash.each do |key, value|
          item.public_send("#{key}=", (value ? value.value : nil))
        end
        item.save
      end
    end
  end

  def evaluate(administered_and_responses, estimate)
    # make sure R evironment is set up
    r = R
    begin
      r.eval("1+1")
      puts "R functions"
    rescue Errno::EPIPE
      puts "no functioning:"
      r=RinRuby.new
      puts r.eval("1+1")
      puts "now it does!"
    end

    # prepare test-setup
    if (r.pull("rv <- if(exists(\"test\")[1]){1}else{0} ")) == 0.0
      alphas = items.alphas
      betas = items.betas
      r.eval("alphas <- t(matrix(c(#{alphas.join(", ")}), #{alphas[0].length}, #{alphas.length}));")
      r.eval("betas <- t(matrix(c(#{betas.join(",")}),   #{betas[0].length},  #{betas.length}));")
      r.eval("require(ShadowCAT);")
      Itembank.define_rmethods(r)
      code = "init_result = initializeTestUnlessDefined(alphas, betas);\n"
      code += "test <- init_result$test;\n"
      code += "items <- init_result$items\n"
      r.eval(code)
    end

    r.administered = administered_and_responses.keys
    r.responses = administered_and_responses.values

    code = "result <- fire(administered, responses,estimate)\n"
    code += "t_next_item <- result$next_item\n"
    code += "t_estimate <- result$estimate\n"
    code += "t_variance <- result$variance\n"
    code += "t_done <- (if(result$done) 1 else 0)\n"
    r.eval(code)
    next_item_index = r.t_next_item
    r_t_done = (r.t_done == 1) ? true : false
    return {next_item_index: next_item_index, next_item: items.all[next_item_index-1], estimate: r.t_estimate, variance: r.t_variance, done: r_t_done}
  end

  class << self
    def define_rmethods(r=R)
      r.eval <<EOF
        initializeTestUnlessDefined <- function(alphas, betas) {
            items <<- initItembank("GRM", alphas, betas, silent = TRUE)
            # initiate test
            test <- initTest(items,
                             start = list( type = 'randomByDimension', n = 3, nByDimension = 1),
                             stop = list( type = 'variance', target = .2),
                             max_n = 30,
                             estimator = 'MAP',
                             selection = 'MI',
                             objective = 'PD')

          return(list(items = items, test = test))
        }

        fire <- function(administered, responses, estimate) {
          set.seed(1)
          person <- initPerson(items, prior = matrix(c(1,.5,.5,
                                                       .5,1,.5,
                                                       .5,.5,1),3,3))
          person$administered <- administered
          person$responses <- responses
          person$available <- person$available[-person$administered]
          person$estimate <- estimate

          person <- estimate(person, test)
          next_item <- next_item(person, test)
          variance <- attr(person$estimate, 'variance')
          done <- stop_test(person, test)

          return(list(status = 0, estimate = person$estimate[1:3], variance = diag(variance), next_item = next_item, done = done))
        }
EOF
    end
  end
end

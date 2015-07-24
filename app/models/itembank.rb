class Itembank < ActiveRecord::Base
  mount_uploader :source, WorkbookUploader
  #after_save :parse_items!
  has_many :items
  has_many :choice_option_sets, primary_key: :choice_options_id
  has_many :remappings

  def source_as_workbook
    @source_as_workbook ||= Workbook::Book.open(source.file.file)
  end

  def parse_items!
    items.destroy_all
    choice_option_sets.destroy_all
    remappings.destroy_all
    header = nil
    source_as_workbook[0][0].each do |row|
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
    source_as_workbook[1][0].each do |row|
      if header == nil
        header = row
      else
        item = ChoiceOptionSet.new(itembank: self)
        item_methods = item.methods
        row.to_hash.each do |key, value|
          setter = "#{key}=".to_sym
          if item_methods.include?(setter)
            # silently ignore everything else...
            if value and value.value != nil
              item.public_send(setter, (value.value))
            end
          end
        end
        item.save
      end
    end
    header = nil
    source_as_workbook[2][0].each do |row|
      if header == nil
        header = row
      else
        item = Remapping.new(itembank: self)
        row.to_hash.each do |key, value|
          item.public_send("#{key}=", (value ? value.value : nil))
        end
        item.save
      end
    end
    header = nil
    source_as_workbook[3][0].each do |row|
      if header == nil
        header = row
      else
        item = Item.find_by({variable_name: row.to_hash[:variable_name].value})
        row.to_hash.each do |key, value|
          if value
            item.public_send("#{key}=", (value.value))
          end
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
      r.eval("alpha_sequence <- c()")
      r.eval("beta_sequence <- c()")

      alphas = items.alphas
      betas = items.betas

      alphas.each do |alpha|
        r.eval("alpha_sequence <- c(alpha_sequence,#{alpha.join(",")})")
      end
      betas.each do |beta|
        r.eval("beta_sequence <- c(beta_sequence,#{beta.join(",")})")
      end
      r.eval("alphas <- t(matrix(c(alpha_sequence), #{alphas[0].length}, #{alphas.length}));")
      r.eval("betas <- t(matrix(c(beta_sequence), #{betas[0].length},  #{betas.length}));")

      puts "Alhpas en betas defined!"

      r.eval("require(ShadowCAT);")

      Itembank.define_rmethods(r)

      puts("Methods defined!")

      code = "init_result = initializeTestUnlessDefined(alphas, betas);\n"
      code += "test <- init_result$test;\n"
      code += "items <- init_result$items\n"



      r.eval(code)

      puts "Test and items initialized!"

    end



    r.administered = administered_and_responses.keys
    r.responses = administered_and_responses.values

    code = "result <- fire(administered, responses,estimate)\n"
    code += "t_next_item <- result$next_item\n"
    code += "t_estimate_full <- result$estimate_full\n"
    code += "t_estimate <- result$estimate\n"
    code += "t_variance <- result$variance\n"
    code += "t_done <- (if(result$status) 1 else 0)\n"
    puts code
    r.eval(code)
    next_item_index = r.t_next_item
    r_t_done = (r.t_done == 1) ? true : false
    r_t_score = nil
    puts "bassics derived"
    if r_t_done
      r.eval "t_score <- c(#{r.t_estimate}.join(",")), \"#{Rails.root.join("config","lookup","copd","lookup.rda")}\""
      r_t_score = r.t_score
      puts "T-test!"
    end

    puts "returning!!"

    return {next_item_index: next_item_index, next_item: items.all[next_item_index-1], estimate: r.t_estimate, variance: r.t_variance, done: r_t_done, t_score: r_t_score}
  end

  class << self
    def define_rmethods(r=R)
      r.eval <<EOF
        initializeTestUnlessDefined <- function(alphas, betas) {

          items <- initItembank("GRM", alphas, betas, silent = TRUE)
          # initiate test
          test <- initTest(items,
                           start = list( type = 'randomByDimension', n = 4, nByDimension = 1),
                           stop = list( type = 'variance', target = .2),
                           max_n = 5,
                           estimator = 'MAP',
                           selection = 'MI',
                           objective = 'PD')

          return(list(items = items, test = test))
        }

        calculateTscore <- function(estimate,filename) {
          print("calculating T-score")

          # load file, store name
          name <- load(filename)
          # rename lookup table
          lookup <- get(name)
          # remove original version
          do.call(rm, list(name))

          # find T score corresponding to closest theta score
          print(estimate)

          t_score <- numeric(length(estimate))
          for (i in 1:length(estimate)){
            t_score[i] <- lookup[[i]][which.min(abs(estimate[i] - lookup[[i]][,1])),2]
          }
          print("Returinging T-score")
          print(t_score)
          return(c(t_score))
        }

        fire <- function(administered, responses, estimate) {
          set.seed(1)
          person <- initPerson(items, prior = matrix(c(1,.753,.727,.873,
                                                       .753,1,.761,.776,
                                                       .727,.761,1,.838,
                                                       .873,.776,.838,1),4,4))
          person$administered <- administered
          person$responses <- responses
          person$available <- person$available[-person$administered]
          person$estimate <- estimate

          person <- estimate(person, test)
          next_item <- next_item(person, test)
          variance <- attr(person$estimate, 'variance')
          done <- stop_test(person, test)

          return(list(status = done, estimate = c(person$estimate), variance = c(diag(variance)), next_item = next_item))
        }
EOF
    end
  end
end

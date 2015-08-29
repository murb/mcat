class Itembank < ActiveRecord::Base
  mount_uploader :source, WorkbookUploader
  mount_uploader :lookup, LookupUploader
  # after_save :parse_items!
  has_many :items
  has_many :choice_option_sets
  has_many :remappings

  # Parsed the Itembank source file as a workbook
  def source_as_workbook
    @source_as_workbook ||= Workbook::Book.open(source.file.file)
  end

  # Parses the items in the source file
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

  # Evaluates the question
  #
  #
  #
  # @param administered_and_responses [Hash] of administered questions and responses
  # @param estimate is the current estimate
  # @return [Hash] with the next questions and directions for the controller: it has the following keys: next_item_index, next_item, estimate, variance, done, t_score, se. The results follow the internals of the ShadowCAT.

  def evaluate(administered_and_responses, estimate)
    puts "Evaluate #{administered_and_responses}, with estimate #{estimate}"
    # make sure R evironment is set up
    r = R
    begin
      r.eval("1+1")
      r.eval("test_var <- 2")
      r.test_var
      puts "R functions"
    rescue Errno::EPIPE
      puts "not functioning:"
      r=RinRuby.new
    rescue NoMethodError
      puts "not functioning:"
      r=RinRuby.new
    end

    # prepare test-setup
    if (r.pull("rv <- if(exists(\"test\")[1]){1}else{0} ")) == 0.0
      r.eval("alpha_sequence <- c()")
      r.eval("beta_sequence <- c()")

      alphas = items.alphas
      betas = items.betas
      code = ""

      alphas.each do |alpha|
        # code = ""
        code += "alpha_sequence <- c(alpha_sequence,#{alpha.join(",")});\n"
        if code.length > 5000
          r.eval(code)
          code = ""
        end
      end
      r.eval(code)
      code = ""

      betas.each do |beta|
        code += "beta_sequence <- c(beta_sequence,#{beta.join(",")});\n"
        if code.length > 5000
          r.eval(code)
          code = ""
        end
      end
      r.eval(code)

      code = "alphas <- t(matrix(c(alpha_sequence), #{alphas[0].length}, #{alphas.length}));"

      code += "betas <- t(matrix(c(beta_sequence), #{betas[0].length},  #{betas.length}));"
      code += "require(ShadowCAT);"
      r.eval(code)
      code = ""

      puts "Alhpas en betas defined!"


      Itembank.define_rmethods(r)

      puts("Methods defined!")

      code = "init_result = initializeTestUnlessDefined(alphas, betas);\n"
      code += "test <- init_result$test;\n"
      code += "items <- init_result$items\n"



      r.eval(code)

      puts "Test and items initialized!"

    end

    # Load currently administered and its responses

    r.administered = administered_and_responses.keys
    r.responses = administered_and_responses.values

    code = "result <- fire(administered, responses,estimate)\n"
    code += "t_next_item <- result$next_item\n"
    code += "t_estimate <- result$estimate\n"
    code += "t_variance <- result$variance\n"
    code += "t_done <- (if(result$status) 1 else 0)\n"
    r.eval(code)

    next_item_index = r.t_next_item
    r_t_done = (r.t_done == 1) ? true : false
    r_t_score = [4,3,2,1]
    puts "basics derived"
    if r_t_done
      code = "t_score <- calculateTscore(t_estimate, \"#{self.lookup.path}\")"
      r.eval(code)
      r_t_score = [1,2,3,4]

      r_t_score = r.t_score
      puts "T-test!"
    end

    puts "retunr"
    standard_error = r.t_variance.collect{|a| a ? Math.sqrt(a) : nil}

    rv = {next_item_index: next_item_index, next_item: items.all[next_item_index-1], estimate: r.t_estimate, variance: r.t_variance, done: r_t_done, t_score: r_t_score, se: standard_error}
    # raise rv.to_s
    return rv
  end

  class << self
    # Initializes shadowcat with the right itembank
    def define_rmethods(r=R)
      r.eval <<EOF
        initializeTestUnlessDefined <- function(alphas, betas) {

          items <- initItembank("GRM", alphas, betas, silent = TRUE)
          # initiate test
          test <- initTest(items,
                           start = list( type = 'randomByDimension', n = 4, nByDimension = 1),
                           stop = list( type = 'variance', target = .2),
                           max_n = 30,
                           estimator = 'MAP',
                           selection = 'MI',
                           objective = 'PD')

          return(list(items = items, test = test))
        }

        calculateTscore <- function(estimate,path) {
          # load file, store name
          name <- load(paste0(path))
          # rename lookup table
          lookup <- get(name)
          # remove original version
          do.call(rm, list(name))
          # find T score corresponding to closest theta score
          T_score <- numeric(length(estimate))
          for (i in 1:length(estimate)){
            T_score[i] <- lookup[[i]][which.min(abs(estimate[i] - lookup[[i]][,1])),2]
          }
          return(T_score)
        }

        fire <- function(administered, responses, estimate) {
          # set a quasi-random seed
          set.seed(as.numeric(format(Sys.time(), "%OS3"))*1000)

          # initiate person
          person <- initPerson(items, prior = matrix(c(   1,.722,.725,.798,
                                                       .722,   1,.698,.713,
                                                       .725,.698,   1,.773,
                                                       .798,.713,.773,   1),4,4))
          person$administered <- administered
          person$responses <- responses
          person$available <- person$available[-person$administered]
          person$estimate <- estimate

          person <- estimate(person, test)
          next_item <- next_item(person, test)
          variance <- attr(person$estimate, 'variance')
          done <- stop_test(person, test)

          return(list(status = done, estimate = c(person$estimate), variance = diag(variance), next_item = next_item))
        }
EOF
    end
  end
end

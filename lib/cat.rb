class Cat
  def self.init
    R.eval <<"EOF"
        ##

        #' @title Fire and Forget wrapper for multidimensional computerized adaptive testing with the shadow test procedure.
        #' @author Karel Kroeze
        #' @param administered, vector of indices of administered items.
        #' @param responses, vector of responses to administered items. Assumed to be sorted with administered.
        #' @return list of;
        #' status; status code.
        #' estimate; vector/numeric of estimates per dimension
        #' variance; matrix/numeric variance/covariance matrix
        #' next_item; index for the next item to be presented

        #' next_item; index for the next item to be presented


        initializeTestUnlessDefined <- function(alphas, betas) {
          if(!exists("test")) {
            require(ShadowCAT)
            items <<- initItembank("GRM", alphas, betas, silent = TRUE)
            # initiate test
            test <<- initTest(items,
                             start = list( type = 'random', n = 5),
                             stop = list( type = 'length', n = 30),
                             estimator = 'MAP',
                             selection = 'MI',
                             objective = 'PD')
          }
        }

        fire <- function(administered, responses, estimate) {
          initializeTestUnlessDefined <- function(alphas, betas)
          # Make sure prerequisites are loaded.

          # set up required objects (with presets to MCAT-COPD).
          # set a seed to load a fixed bank.
          set.seed(1)
          # load a test itembank.
          #items <- createTestBank("GRM", K = 200, Q = 4, M = 7, between = TRUE)

          # initiate person
          person <- initPerson(items, prior = matrix(c(1,.5,.5,
                                                       .5,1,.5,
                                                       .5,.5,1),3,3))

          # insert admin + responses.
          person$administered <- administered
          person$responses <- responses
          person$available <- person$available[-person$administered]

          # set previous estimate
          person$estimate <- estimate

          # get estimate
          person <- estimate(person, test)

          # get next item
          next_item <<- next_item(person, test)
          estimate <<- person$estimate
          variance <<- attr(person$estimate, 'variance')
          return(list(status = 0, estimate = estimate, variance = diag(variance), next_item = next_item))
        }
EOF
  end

  #require 'cat'; Cat.fire({1=>2,41=>2}, [1,1,1], Item.alphas, Item.betas)
  def self.fire(administered_and_responses, estimate, alphas, betas)
    self.init
    R.administered = administered_and_responses.keys
    code += "responses <- c(#{administered_and_responses.values.join(", ")})\n"
    code += "estimate <- c(#{estimate.join(", ")})\n"
    code += "alphas <- t(matrix(c(#{alphas.join(", ")}), #{alphas[0].length}, #{alphas.length}))\n"
    code += "betas <- t(matrix(c(#{betas.join(",")}), #{betas[0].length}, #{betas.length}))\n"
    code += "result <- MCAT(administered, responses,estimate, alphas,betas)\n"
    code += "next_item <- result$next_item"
    code += ""
    R.eval(code)
  end
end

# testing with:
# require 'cat'; Cat.init; Cat.fire([1],[2],[1,1,1,1],Item.alphas,Item.betas)
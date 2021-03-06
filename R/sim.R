#' @export
matlm_sim_randpred <- function(seed, N = 100, M = 500, rho,
  ret = c("sim", "mat"))
{
  # correlated variables
  # - http://r.789695.n4.nabble.com/Random-Normal-Variable-Correlated-to-an-Existing-Binomial-Variable-td3472211.html
  
  ### args
  if(!missing(seed)) { 
    set.seed(seed)
  }
  
  ret <- match.arg(ret)
  
  ### sim
  y <- rnorm(N, mean = 10)
  X <- matrix(rnorm(N * M), nrow = N, ncol = M)
  
  d <- rbinom(N, 1, 0.5)
  d <- factor(d)

  if(!missing(rho)) {
    C <- matrix(rho, M, M)
    diag(C) <- 1
    
    # early stop: return the matrix
    if(ret == "mat") {
      return(C)
    }
    
    ch <- chol(C)
    
    X <- X %*% ch 
  }
  
  dat <- data_frame(y = y, d = d)
  form <- formula(y ~ 1)
  form_int <- formula(y ~ d)
  
  out <- list(form = form, form_int = form_int, dat = dat, pred = X)
  
  return(out)
}

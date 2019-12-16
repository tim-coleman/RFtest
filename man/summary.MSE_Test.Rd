\name{summary.MSE_Test}
\alias{summary.MSE_Test}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Summarizes an MSE Test object.}

\usage{
summary.MSE_Test(obj)
}
\author{
Tim Coleman
}

\examples{
N <- 1250
Nvar <- 10
N_test <- 150
name_vec <- paste("X", 1:(2*Nvar), sep = "")

# training data:
X <- data.frame(replicate(Nvar, runif(N)),
                replicate(Nvar, cut(runif(N), 3,
                                      labels = as.character(1:3)))) %>%
  mutate(Y = 5*(X3) + .5*X2^2 + ifelse(X6 > 10*X1*X8*X9, 1, 0) +  rnorm(N, sd = .05))
names(X) <- c(name_vec, "Y")

# some testing data:
X.t1 <- data.frame(replicate(Nvar, runif(N_test)),
                   replicate(Nvar, cut(runif(N_test), 3,
                                       labels = as.character(1:3)))) %>%
  mutate(Y = 5*(X3) + .5*X2^2 + ifelse(X6 > 10*X1*X8*X9, 1, 0) +  rnorm(N_test, sd = .05))
names(X.t1) <- c(name_vec, "Y")

M_no_test <- MSE_Test(X = X %>% dplyr::select(-Y), y = X$Y,
                      base.learner = "rtree", NTest = 100, NTree = 500, B = 1000, var = c( "X5"),
                      p = .85)

summary(M_no_test)
}


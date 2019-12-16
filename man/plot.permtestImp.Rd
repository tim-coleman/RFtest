\name{plot.permtestImp}
\alias{plot.permtestImp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plotting a permutation test for all features.}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.permtestImp(obj, ImpType = "SDImp", col_blind = F)
}

\examples{
N <- 1250
Nvar <- 10
N_test <- 150
name_vec <- paste("X", 1:(2*Nvar), sep = "")

# training data:
X <- data.frame(replicate(Nvar, runif(N)),
                replicate(Nvar, cut(runif(N), 3,
                                      labels = as.character(1:3)))) \%>\%
  mutate(Y = 5*(X3) + .5*X2^2 + ifelse(X6 > 10*X1*X8*X9, 1, 0) +  rnorm(N, sd = .05))
names(X) <- c(name_vec, "Y")

# some testing data:
X.t1 <- data.frame(replicate(Nvar, runif(N_test)),
                   replicate(Nvar, cut(runif(N_test), 3,
                                       labels = as.character(1:3)))) \%>\%
  mutate(Y = 5*(X3) + .5*X2^2 + ifelse(X6 > 10*X1*X8*X9, 1, 0) +  rnorm(N_test, sd = .05))
names(X.t1) <- c(name_vec, "Y")

pm1 <- permtestImp(X = X %>% dplyr::select(-Y), y = X$Y, resp = "y", single_forest = F,
                   base.learner = "rtree", mtry = 5, NTest = 30, Nbtree = 10, B = 1000,
                   p = .875, verbose = T)


plot(pm1)

pm.null <- permtestImp(X = X %>% dplyr::select(-Y), y = rnorm(2500), resp = "y", single_forest = F,
                       base.learner = "rtree", mtry = 3, NTest = 100, Nbtree = 100, B = 1000,
                       p = .95, verbose = T)

plot(pm.null)
}


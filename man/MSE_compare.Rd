\name{MSE_compare}
\alias{MSE_compare}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Comparing two pre-trained models.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
MSE_compare(m1, m2, X.test, y.test = NULL, B = 1000, return.preds = F, test_stat = if (is.null(y.test)) "KS" else "MSE")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{m1}{
First model, usually generated with \code{bag.s}.}
  \item{m2}{
Second model, usually generated with \code{bag.s}.
}
 \item{X.test}{
  Covariates of the test set with which the MSE is calculated.
}
  \item{y.test}{
  Responses in the test set with which the MSE is calculated.
}
\item{B}{ Number of permutations to use in the test. Note: this is the number of times the trees are permuted between forests to generate the permutation distribution, not the number of times each feature is permuted.
}
  \item{return.preds}{
  Logical. Should model predictions be returned?
}
  \item{test_stat}{
  Not currently useful. 
}
}

\value{ An object of the S4 class \code{MSE_Test}
\item{originalStat}{A named vector of two quantities, \code{Original MSE}, which corresponds to the MSE of the full model and \code{Permuted MSE} which corresponds to MSE of the reduced model.}
\item{PermDiffs}{A vector of the differences in permuted MSEs - these make up the permutation distribution.}
\item{Importance}{A scalar of the SD Importance Z-score.}
\item{Pvalue}{The p-value for the hypothesis tested.}
\item{test_pts}{The test data frame.}
\item{weak_learner}{The base models used in each ensemble - one for model 1 and one for model 2.}
\item{model_original}{Model 1}
\item{model_permuted}{Model 2}
\item{test_stat}{Which test statistic is used. Will always be \code{"MSE"} for this function.}
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

m_rpart <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                       base.learner = "rpart", ntree = 100, k = 100^.85, mtry = 10, form = Y~., ranger = F)
m_ctree <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                 base.learner = "ctree", ntree = 100, k = 100^.85, mtry = 10, form = Y~., ranger = F)
m_ctree_ranger <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                    base.learner = "ctree", ntree = 100, k = 100^.85, mtry = 10, form = Y~., ranger = T)
m_rtree <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                 base.learner = "rtree", ntree = 100, k = 100^.85, mtry = 10, form = Y~., ranger = F)
m_rtree_ranger <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                        base.learner = "rtree", ntree = 100, k = 100^.85, mtry = 10, ranger = T)
m_glm  <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                                 base.learner = "lm", ntree = 100, k = 100^.85, mtry = 10, ranger = F)

# Feature importance usage
X_pm <- X[sample(nrow(X), replace = F),which(names(X) != "Y")]
m_reduced <- bag.s(X = X_pm, y = X %>% select(Y),
                  base.learner = "rpart", ntree = 100, k = 100^.85, mtry = 10)
m_full <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                base.learner = "rpart", ntree = 100, k = 100^.85, mtry = 10)
full_vs_red <- MSE_compare(m_reduced, m_full, X.test = X.t1, y.test = X.t1$Y)

p1 <- data.frame(lapply(m_ctree_ranger, FUN = function(x) predict(x, data = X.t1)["predictions"]))
p2 <- data.frame(lapply(m_rpart, FUN = function(x) predict(x, newdata = X.t1)))
p_glm <- data.frame(lapply(m_glm, predict,
                           newx = model.matrix(y~., data = data.frame(X.t1, "y" = rep(0, N_test)))))

MSE_comp_rp_ct <- MSE_compare(m_rpart, m_ctree, X.test = X.t1, y.test = X.t1$Y)
MSE_comp_rp_glm <- MSE_compare(m_rpart, m_glm, X.test = X.t1, y.test = X.t1$Y)
MSE_comp_rtr_glm <- MSE_compare(m_rtree_ranger, m_glm, X.test = X.t1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

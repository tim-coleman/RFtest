\name{bag.s}
\alias{bag.s}
\title{
Subsampled Model Bagging
}
\description{
An implementation of different subsampled models, to then be used to in the MSE comparison procedure.
}
\usage{
bag.s(X, y, base.learner = "rpart", ntree, k, mtry = ncol(X),
  form = as.formula("y~."), alpha = if (base.learner == "lm") 1 else NULL,
  glm_cv = if (base.learner == "lm") "external" else "none",
  lambda = if (glm_cv == "none" & base.learner == "lm") 1 else NULL, ranger = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{ Data frame of covariates.
}
  \item{y}{ Response vector. Currently only numeric responses (regression) are supported.
}
  \item{base.learner}{ One of \code{"rpart"}, \code{"ctree"}, \code{"rtree"}, or \code{"lm"}. Base model to be used in the bagging.
}
  \item{ntree}{ Number of base learners.
}
  \item{k}{ Subsample size - each model is trained on k < n observations drawn without replacement.
}
  \item{mtry}{ \code{"mtry"} parameter associated with random forest models.
}
  \item{form}{ A \code{"formula"} object - no need to provide this by default.
}
  \item{alpha}{ Mixing parameter if \code{base.learner = "lm"} is chosen, quantifies amount between LASSO and Ridge penalties.
}
  \item{glm_cv}{ Should internal cross validation be performed on each Elastic Net model?
}
  \item{lambda}{ Regularization parameter if \code{base.learner = "lm"} is chosen.
}
  \item{ranger}{ If \code{base.learner = "rtree"} or \code{base.learner = "ctree"}, should the models be \code{ranger} objects or \code{randomForest} objects (if rtree is chosen) or \code{cforest} objects (if ctree is chosen.)
}
}
\details{ This function is not intended to be used as a standalone, rather it is called by the \code{\link{MSE_Test}} function.
}
\value{
A list of length \code{ntree}, each containing the base learner model.
}
\author{
Tim Coleman
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{MSE_Test}}
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


## Trying each base learner
b.rpart <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                 base.learner = "rpart", ntree = 10, k = N^.85, mtry = 10, form = Y~.)
b.ctree <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                 base.learner = "ctree", ntree = 10, k =N^.95, mtry = 2)
b.rf <- bag.s(X = X %>% select(-Y), y = X %>% select(Y),
              base.learner = "rtree", ntree = 10, k = N^.95, mtry = 2, Y~., ranger = F)
b.glmnet <-  bag.s(X = X %>% select(-Y), y = X %>% select(Y),
                   base.learner = "lm", ntree = 10, k = N^.95, mtry = 2)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ subsampling}% use one of  RShowDoc("KEYWORDS")
\keyword{ bagging}% __ONLY ONE__ keyword per line

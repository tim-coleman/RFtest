\name{MSE_Test}
\alias{MSE_Test}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Comparing Test MSE's for Full and Reduced Models}
%%  ~~function to do ... ~~

\description{
Implementation of a test which permutes trees between two forests, one with \code{var} left intact, and one with \code{var} replaced with a permuted version of itself, where the permutation is done row-wise.
}
\usage{
MSE_Test(X, y, X.test = FALSE, y.test = FALSE, var,
  NTest = nrow(X.test), B = 1000, NTree = 500, p = 1/2,
  base.learner = "rpart", mtry = ncol(X), importance = T,
  alpha = if (base.learner == "lm") 1,
  glm_cv = if (base.learner == "lm") "external" else "none",
  lambda = if (glm_cv == "none" & base.learner == "lm") 1 else NULL,
  ranger = F)

MSE_Test(formula, data, ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{ Data frame of covariates - the training data.
}
  \item{y}{ Response vector. Currently only numeric responses (regression) are supported.
}
  \item{X.test}{
  Covariates of the test set with which the MSE is calculated.
}
  \item{y.test}{
  Responses in the test set with which the MSE is calculated.
}
  \item{base.learner}{ One of \code{"rpart"}, \code{"ctree"}, \code{"rtree"}, or \code{"lm"}. Base model to be used in the bagging.
}
  \item{NTree}{ Number of base learners.
}
  \item{mtry}{ \code{"mtry"} parameter associated with random forest models.
  }
  \item{var}{
  Variable of interest. Should correspond to the name of a variable in both \code{X} and \code{X.test}.
}
  \item{NTest}{ If \code{X.test, y.test} are not specified, this number of test points are drawn at random from \code{X, y} to serve as a test set.
}
  \item{B}{ Number of permutations to use in the test. Note: this is the number of times the trees are permuted between forests to generate the permutation distribution, not the number of times each feature is permuted.
}
  \item{p}{ Fractional exponent of sample size, i.e. \eqn{k = n^p} observations are drawn.
}
 \item{base.learner}{ One of \code{"rpart"}, \code{"ctree"}, \code{"rtree"}, or \code{"lm"}. Base model to be used in the bagging.
}
  \item{importance}{Logical. Should the standardized score of the test statistic (its "importance") be returned?
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
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{ An object of the S4 class \code{MSE_Test}

\item{var}{ Variable whose importance was tested, a name of a column in \code{X}.}
\item{originalStat}{A named vector of two quantities, \code{Original MSE}, which corresponds to the MSE of the full model and \code{Permuted MSE} which corresponds to MSE of the reduced model.}
\item{PermDiffs}{A vector of the differences in permuted MSEs - these make up the permutation distribution.}
\item{Importance}{A scalar of the SD Importance Z-score.}
\item{Pvalue}{The p-value for the hypothesis tested.}
\item{test_pts}{The test data frame.}
\item{weak_learner}{The base models used in the ensemble.}
\item{model_original}{The full model ensemble - list of base learners, like in \code{bag.s}.}
\item{model_permuted}{The reduced model ensemble - list of base learners, like in \code{bag.s}.}
\item{test_stat}{Which test statistic is used. Will always be \code{"MSE"} for this function.}
}

\author{
Tim Coleman
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
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

# Not specifying test points:
M_no_test <- MSE_Test(X = X \%>\% dplyr::select(-Y), y = X$Y,
                      base.learner = "lm", NTest = 100, NTree = 150, B = 1000, var = c( "X3"),
                      p = .85, glm_cv = T)

summary(M_no_test)

# Specifying test points:
M_test <- MSE_Test(X = X \%>\% select(-Y), y = X$Y, X.test = X.t1 \%>\% select(-Y), y.test = X.t1$Y,
                      base.learner = "ctree", NTree = 250, B = 1000, var = c( "X2"),
                      p = .85)
summary(M_test)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.


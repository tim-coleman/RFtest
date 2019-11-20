\name{permtestImp}
\alias{permtestImp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Testing Importance of All Variables
}
\description{
This method runs the variable importance procedure (\code{MSE_Test}) on each variable in the data frame, marginally, with an available plot method.
}
\usage{
permtestImp(X, y, X.test = FALSE, y.test = FALSE,
  single_forest = T, NTest = nrow(X.test), Nbtree = 30,
  verbose = F, keep_forest = F, base.learner = "rpart",
  mtry = ncol(X), p = 0.5, ...)
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
  \item{single_forest}{Logical. If \code{TRUE}, then all variables are compared against a single original forest.}
 \item{NTest}{ If \code{X.test, y.test} are not specified, this number of test points are drawn at random from \code{X, y}.
}
  \item{Nbtree}{ How many trees should be used for each variable. Can either be a single number, or a vector of length \code{ncol(X)}, with each entry corresponding to the number of trees used for testing each column.
}
  \item{verbose}{
Logical. Should a progress tracker be output in the console?
}
  \item{keep_forest}{
  Logical. Should the original random forest be returned?
}
  \item{mtry}{
The \code{mtry} parameter used in random forest models.
}
  \item{p}{
Subsample size exponent, see  \code{MSE_Test}.
}
  \item{\dots}{
  Additional arguments to be passed to \code{MSE_Test}.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns an object of S4 class \code{permtestImp} with the following values

\item{ImportanceTable}{A \code{data.frame} tabulating each variable and its importance.}
\item{call}{The original call, as provided by \code{match.call()}}
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
set.seed(367116)
N <- 1250
Nvar <- 5
name_vec <- paste("X", 1:(2*Nvar), sep = "")

# training data:
X <- data.frame(replicate(Nvar, runif(N)),
                replicate(Nvar, cut(runif(N), 3,
                                      labels = as.character(1:3))))
names(X) <- name_vec

## Example where response is unrelated to any features
pm.null <- permtestImp(X = X, y = rnorm(N),
                         single_forest = F, base.learner = "rtree",
                        mtry = 3, NTest = 100, Nbtree = 100, B = 1000,
                       p = .75, verbose = T)

## Plotting the Importance Output
plot(pm.null)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

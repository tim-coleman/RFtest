\name{f_holdoutRF}
\alias{f_holdoutRF}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Efficient Variable Importance Using Holdout Forests
}
\description{
Runs variable importance for all variables by using a single forest. Traditional random forest works by restricting the features available to split upon in each node in the tree. Holdout forests modify this by instead restricting features available for the entire tree. This induces a natural sorting of variables into trees with and without the variables. Each collection of these trees forms a random forest, which is then run through the MSE Test procedure.
}
\usage{
f_holdoutRF(X, y, X.test = FALSE, y.test = FALSE, B = 1000,
  NTest = nrow(X.test), mintree = 30, max.trees = 5 * ncol(X) * mintree,
  verbose = F, mtry = ncol(X)/3, p = 0.5, keep_forest = F, ...)
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
Subsample size exponent, see \code{MSE_Test}.
}
  \item{\dots}{
  Additional arguments to be passed to \code{MSE_Test}.
}
  \item{mintree}{
%%     ~~Describe \code{mintree} here~~
}
  \item{max.trees}{
%%     ~~Describe \code{max.trees} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
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

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

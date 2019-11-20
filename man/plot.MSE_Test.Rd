\name{plot.MSE_Test}
\alias{plot.MSE_Test}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plotting the Output of the Permutation Test
}
\description{
A S4 plot method for the function \code{MSE_Test}
}
\usage{
plot.MSE_Test(obj, return_plot = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{ An object of the class \code{MSE_Test.}
}
  \item{return_plot}{ Logical. Should the plot object be returned (so it may be modified). Returns a \code{ggplot} object.
%%     ~~Describe \code{return_plot} here~~
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

# Not specifying test points:
M_no_test <- MSE_Test(X = X \%>\% dplyr::select(-Y), y = X$Y,
                      base.learner = "lm", NTest = 100, NTree = 150, B = 1000, var = c( "X3"),
                      p = .85, glm_cv = T)

# Outputting the plot
plot(M_no_test)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

\name{MSE_compare}
\alias{MSE_compare}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
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
%%     ~~Describe \code{m1} here~~
}
  \item{m2}{
%%     ~~Describe \code{m2} here~~
}
  \item{X.test}{
%%     ~~Describe \code{X.test} here~~
}
  \item{y.test}{
%%     ~~Describe \code{y.test} here~~
}
  \item{B}{
%%     ~~Describe \code{B} here~~
}
  \item{return.preds}{
%%     ~~Describe \code{return.preds} here~~
}
  \item{test_stat}{
%%     ~~Describe \code{test_stat} here~~
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
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (m1, m2, X.test, y.test = NULL, B = 1000, return.preds = F, 
    test_stat = if (is.null(y.test)) "KS" else "MSE") 
{
    if (length(m1) != length(m2)) {
        warning("Models should have the same number of base models")
    }
    pred_f <- function(model) {
        if (class(model) \%in\% c("bagged_rtree", "bagged_ctree", 
            "bagged_rpart")) {
            P <- data.frame(lapply(model, FUN = function(x) predict(x, 
                newdata = X.test)))
        }
        else if (class(model) \%in\% c("bagged_rtree_ranger", "bagged_ctree_ranger")) {
            P <- data.frame(lapply(model, FUN = function(x) {
                P <- predict(x, data = X.test)
                P["predictions"]
            }))
        }
        else {
            if (is.null(y.test)) {
                y.dummy <- rep(0, nrow(X.test))
            }
            else {
                y.dummy <- y.test
            }
            form.resp <- as.formula("y~.")
            P <- data.frame(lapply(model, predict, newx = model.matrix(form.resp, 
                data.frame(X.test, y = y.test))))
        }
        P
    }
    P1 <- pred_f(m1)
    P2 <- pred_f(m2)
    nt1 <- length(m1)
    nt2 <- length(m2)
    Pool <- cbind(P1, P2)
    if (class(test_stat) == "character") {
        if (test_stat == "MSE") {
            f <- function(test, p1, p2) {
                MSE1 <- mean((p1 - test)^2)
                MSE2 <- mean((p2 - test)^2)
                return(c(`Model 1 MSE` = MSE1, `Model 2 MSE` = MSE2))
            }
        }
        else if (test_stat == "KS") {
            f <- function(test, p1, p2) {
                stat <- max(abs(p1 - p2))
                return(stat)
            }
        }
        else if (test_stat == "diff") {
            f <- function(test, p1, p2) {
                stat <- mean(p1 - p2)
                return(stat)
            }
        }
    }
    else {
        f <- test_stat
    }
    Pred_1 <- apply(P1, FUN = mean, MARGIN = 1)
    Pred_2 <- apply(P2, FUN = mean, MARGIN = 1)
    if (is.null(y.test)) {
        y.test <- rep(0, nrow(X.test))
    }
    TS0 <- f(y.test, Pred_1, Pred_2)
    TS_temp <- TS0
    if (class(test_stat) == "character") {
        if (test_stat == "MSE") 
            TS0 <- TS0[1] - TS0[2]
    }
    perm_stats <- c()
    for (i in 1:B) {
        samps <- sample(1:ncol(Pool), nt1, replace = F)
        P_t <- Pool[, samps]
        PR_t <- Pool[, -samps]
        Pred_t <- apply(P_t, FUN = mean, MARGIN = 1)
        Pred_R_t <- apply(PR_t, FUN = mean, MARGIN = 1)
        if (class(test_stat) == "character") {
            if (test_stat == "MSE") {
                temp <- f(y.test, Pred_R_t, Pred_t)
                perm_stats[i] <- temp[1] - temp[2]
            }
            else {
                temp <- NULL
                perm_stats[i] <- f(y.test, Pred_R_t, Pred_t)
            }
        }
        else {
            perm_stats[i] <- f(y.test, Pred_R_t, Pred_t)
        }
    }
    if (test_stat == "diff") {
        Pvals <- c(`Full Model P` = mean(c(abs(TS0) < abs(perm_stats), 
            1)))
    }
    else {
        Pvals <- c(`Full Model P` = mean(c(TS0 < perm_stats, 
            1)))
    }
    sdimp <- (TS0 - mean(perm_stats))/sd(perm_stats)
    zimp <- qnorm(1 - pnorm(sdimp))
    importances <- c(`Standard Deviation Importance` = sdimp, 
        `Standard Normal Importance` = zimp)
    result <- list(variables = NULL, originalStat = TS_temp, 
        PermDiffs = perm_stats, Importance = importances, Pvalue = Pvals, 
        test_pts = X.test, weak_learner = c(class(m1), class(m2)), 
        model_original = m1, model_permuted = m2, test_stat = test_stat, 
        call = match.call())
    class(result) <- "MSE_Test"
    result
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

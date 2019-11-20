\name{plot.permtestImp}
\alias{plot.permtestImp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.permtestImp(obj, ImpType = "SDImp", col_blind = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{
%%     ~~Describe \code{obj} here~~
}
  \item{ImpType}{
%%     ~~Describe \code{ImpType} here~~
}
  \item{col_blind}{
%%     ~~Describe \code{col_blind} here~~
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
function (obj, ImpType = "SDImp", col_blind = F) 
{
    obj <- obj$Importance_Table
    title.perm <- "Permutation Test Importance Measures "
    if (ImpType == "SDImp") {
        df <- data.frame(Variable = colnames(obj), Importance = unlist(obj[1, 
            ], use.names = F), Pvalues = unlist(obj[3, ], use.names = F))
        df <- df \%>\% mutate(Variable = reorder(Variable, Importance)) \%>\% 
            mutate(signifcode = cut(Pvalues, breaks = c(0, 0.01, 
                0.05, 0.1, 1), labels = c(".01", ".05", ".1", 
                "Not Significant")))
        subtitle <- "Standard Deviation Importance"
    }
    else {
        df <- data.frame(Variable = colnames(obj), Importance = unlist(obj[2, 
            ], use.names = F), Pvalues = unlist(obj[3, ], use.names = F))
        df <- df \%>\% mutate(Variable = reorder(Variable, Importance)) \%>\% 
            mutate(signifcode = cut(Pvalues, breaks = c(0, 0.01, 
                0.05, 0.1, 1), labels = c(".01", ".05", ".1", 
                "Not Significant")))
        subtitle <- "MSE Importance"
    }
    if (nrow(df) > 15) {
        df <- (df \%>\% arrange(desc(Importance)))[1:15, ]
    }
    if (!col_blind) {
        imp_palette <- colorRampPalette(c("blue", "grey65", "aquamarine3"))
        n_col <- length(unique(df[["signifcode"]]))
        g <- ggplot(aes(x = Variable), data = df) + geom_point(aes(y = Importance, 
            col = signifcode), size = 3.5) + coord_flip() + theme_classic() + 
            ggtitle(title.perm) + ylab(subtitle) + scale_colour_manual(values = imp_palette(n_col), 
            name = "Significance \nLevel") + theme(plot.title = element_text(size = 21, 
            hjust = 0.5), axis.title = element_text(size = 15), 
            axis.text.y = element_text(size = 18), axis.text.x = element_text(size = 18), 
            legend.background = element_rect(colour = "black", 
                fill = "white"), legend.text = element_text(size = 12), 
            legend.title = element_text(size = 14, hjust = 0.5), 
            legend.spacing.y = unit(0.3, "cm"), plot.subtitle = element_text(hjust = 0.5), 
            panel.border = element_rect(colour = "black", fill = NA, 
                size = 1), plot.background = element_rect(fill = "white"), 
            panel.background = element_rect(fill = "white"), 
            panel.grid.major.y = element_line(colour = "gray", 
                linetype = 2))
    }
    else {
        g <- ggplot(aes(x = Variable), data = df) + geom_point(aes(y = Importance, 
            shape = signifcode), fill = "#6FD6FF", size = 3.5) + 
            coord_flip() + theme_classic() + ggtitle(title.perm) + 
            ylab(subtitle) + scale_shape_discrete(name = "Significance \nLevel") + 
            theme(plot.title = element_text(size = 21, hjust = 0.5), 
                axis.title = element_text(size = 15), axis.text.y = element_text(size = 18), 
                axis.text.x = element_text(size = 18), legend.background = element_rect(colour = "black", 
                  fill = "white"), legend.text = element_text(size = 12), 
                legend.title = element_text(size = 14, hjust = 0.5), 
                legend.spacing.y = unit(0.3, "cm"), plot.subtitle = element_text(hjust = 0.5), 
                panel.border = element_rect(colour = "black", 
                  fill = NA, size = 1), plot.background = element_rect(fill = "white"), 
                panel.background = element_rect(fill = "white"), 
                panel.grid.major.y = element_line(colour = "gray", 
                  linetype = 2))
    }
    plot(g)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

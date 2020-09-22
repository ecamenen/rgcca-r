#'Print bootstrap
#'@param x A bootstrap object (see \code{\link[RGCCA]{bootstrap}})
#'@param ... Further arguments in print
#' @return A matrix containing for each variables of each blocks, the means, 95\% intervals, bootstrap ratio, p-values and other statistics (see details)
#' @details 
#' \itemize{
#' \item 'estimate' for RGCCA weights
#' \item 'mean' for the mean of the bootstrap weights
#' \item 'sd' for the standard error of the bootstrap weights
#' \item 'lower/upper_band' for the lower and upper intervals from to the 'bar' parameter
#' \item 'p.vals' for p-values. In the case of SGCCA, the occurrences of the 
#' bootstrap weights are distributed according to the binomial distribution 
#' while for RGCCA, their absolute value weighted by their standard deviation 
#' follows a normal distribution.
#' \item 'BH' for Benjamini-Hochberg p-value adjustments
#' }
#'@export
print.bootstrap=function(x,...)
{
    print(paste(dim(x$bootstrap[[1]][[1]])[2],"bootstrap(s) were run"),...)
    ncompmax=min(x$rgcca$call$ncomp)
    for(comp in 1:ncompmax)
    {
        cat(paste("Dimension:",comp,"\n"))
        print(Reduce(rbind,lapply(1:length(x$rgcca$call$blocks),
                                  function(block)
                                  { b=get_bootstrap(b=x,
                                                      i_block=block,
                                                    comp=comp,
                                                    bars="ci",
                                                    display_order =FALSE)
                                    othercols=colnames(b)[-which(colnames(b)=="estimate")]
                                  ;return(b[,c("estimate",othercols)])}
            )))
    }
}
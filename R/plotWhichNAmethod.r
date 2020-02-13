#'Plots the impact of increasing missing data on RGCCA
#' @param listFinale A list resulting of which NA method
#' @param output ="rv": Can be also "a" for correlations between axes, "bm" for the percent of similar biomarkers, "rvComplete" if the RV is calculated only on complete dataset, or "rmse" for Root Mean Squares Error.
#' @param fileName =NULL name of the file where the plot is saved
#' @param ylim =c(0.8,1) y limits
#' @param block ="all" or a number indicating the position of the chosen block in the initial list
#' @param barType ="sd" or "stderr". Indicates which error bar to build
#' @param namePlot =NULL Name of the file
#' @param width =480 width of the saved file
#' @param height =480 height of the saved file
#' @param ylab label of y-axis
#' @examples 
#' set.seed(42);X1=matrix(rnorm(350),70,5);X2=matrix(rnorm(280),70,4);X1[1,1]=NA;X2[2,]=NA
#' colnames(X1)=paste("A",1:5);colnames(X2)=paste("B",1:4); 
#' rownames(X1)=rownames(X2)=paste0("S",1:70);A=list(X1,X2);
#' listResults=whichNAmethod(A=A,patternNA=c(0.1,0.2),
#' listMethods=c("mean","complete","nipals","knn4"))
#' plotWhichNAmethod(listFinale=listResults,ylim=c(0,1),output="a")
#' @importFrom grDevices graphics.off 
#' @importFrom graphics plot.new
#' @export


plotWhichNAmethod=function(listFinale,output="rv",fileName=NULL,ylim=NULL,block="all",barType="sd",namePlot=NULL,width=480,height=480,ylab="")
{ #output : "rv", "pct" ou "a"
  #barType="sd" or "stderr"
    
    # TODO: par(new=TRUE)
  
  if(is.null(namePlot)){namePlot=output}
  #graphics.off()
  if(!is.null(fileName)){png(paste(fileName,".png",sep=""),width=width,height=height)}
  nameData= names(listFinale)
  abscisse=as.numeric(substr(nameData,5,7));names(abscisse)=nameData
  abscisse=1:length(listFinale[[1]])
  pas=1 
  par(las=1)
  J=length(listFinale[[1]][[1]][[1]]) #nblock
 # close.screen(all.screens=TRUE)
  if(block=="all")
  { 
      par(mfrow=c(floor(sqrt(J)+1),floor(sqrt(J)+1)));toPlot=1:J
    #  split.screen(c(floor(sqrt(J)+1),floor(sqrt(J)+1)));toPlot=1:J
  }
  else
  {
      toPlot=block:block
  }
  # print(toPlot)
  namesMethod=names(listFinale[[1]])
  #colMethod=rainbow(5)[1:length(namesMethod)]
  colMethod=c("cornflowerblue","chocolate1","chartreuse3","red","blueviolet","darkturquoise","darkgoldenrod1","coral","bisque4","darkorchid1","deepskyblue1")[1:length(namesMethod)]
  nMeth=0:length(namesMethod)
  names(colMethod)=names(nMeth)=namesMethod
  for(j in toPlot)
  {
    #if(block=="all"){screen(j)}
    par(mar=c(5, 4, 4, 2) + 0.1)
    par(mgp=c(3,1,0))
 
    moyenne=rep(NA,length(namesMethod));names(moyenne)=namesMethod
    ecartType=rep(NA,length(namesMethod));names(ecartType)=namesMethod
    
    for(rg in namesMethod)
    {
      result=sapply(listFinale,function(x){return(x[[rg]][[output]][[j]])})
      moyenne[rg]=mean(result)
      if(barType =="no"){ecartType=0}
      if(barType=="sd"){ecartType[rg]=sd(result)}
      if(barType=="stderr"){ecartType[rg]=sd(result)/sqrt(length(result))}
    } 
    if(is.null(ylim))
    { 
          minim=min(moyenne-ecartType)
          maxim=max(moyenne+ecartType)
        if(!is.na(minim))
        {
          Ylim=c(minim,maxim)
        }
        else{Ylim=ylim}
    }
    else
    {
        Ylim=ylim
    }
    plot(NULL,main=paste(namePlot,": Block",j),xlim=c(0,length(namesMethod)-1),ylim=Ylim,xlab="Methods",ylab=ylab,bty="n",xaxt="n")
    axis(side = 1,col="grey",line=0)
    axis(side = 2,col="grey",line=0)
    rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = 
           "#e9ebec",border="#e9ebec")
    # grid(nx = NULL, ny = NULL, col = "white", lty = "dotted",  lwd = par("lwd"), equilogs = TRUE)

       for(rg in namesMethod)
      {
        if(!(rg=="complete"&&output=="rv"))
        {
          points(pas*nMeth[rg],moyenne[rg],pch=16,col=colMethod[rg])
          segments(pas*nMeth[rg],moyenne[rg]-ecartType[rg],pas*nMeth[rg],moyenne[rg]+ecartType[rg],col=colMethod[rg])
          
        }
     }
  }
  if(block=="all")
  {
  #  screen(J+1)
      plot.new()
      par(cex=0.8)
    legend("center",legend=namesMethod,fill=colMethod,box.lwd=0,,bty="n")
  }
  if(is.numeric(block))
  {
      par(cex=0.8)
    legend("bottomleft",legend=namesMethod,fill=colMethod,box.lwd=0,bty="n")
  }
  
  if(!is.null(fileName)){dev.off()}
  #par(new=TRUE)
  par(mfrow=c(1,1))
  par(mar=c(5,4,3,3))
  par(cex=1)
}

# Demo of RGCCA package !
#--------------
library(RGCCA)
#library(ggplot2)
#library(gridExtra)
?rgcca

# Plot functions on Russetts
#-----------------------------
data(Russett)
blocks = list(agriculture = Russett[, seq(3)], industry = Russett[, 4:5],
              politic = Russett[, 6:11] )
response = matrix(apply(Russett[, 9:11], 1, which.max),ncol=1)
rownames(response)=rownames(Russett)
response=matrix( Russett[, 11],ncol=1);rownames(response)=rownames(Russett)

resRGCCA=rgcca(blocks,ncomp=c(2,2,2),scheme=function(x) x^4, type="sgcca",sparsity = c(.6, .75, .5))
print(resRGCCA)
summary(resRGCCA)
names(resRGCCA)
plot(resRGCCA)
i_block=1
plot(resRGCCA,resp=response,i_block=i_block)
plot(resRGCCA,resp=response,i_block=i_block,type="ave")
plot(resRGCCA,resp=response,i_block=i_block,type="network")
plot(resRGCCA,resp=response,i_block=i_block,type="var")
plot(resRGCCA,resp=response,i_block=i_block,type="ind")
plot(resRGCCA,resp=response,i_block=i_block,type="cor")

# choice of parameters
#---------------------

# permutation
perm.values = matrix(c(0.6, 0.75, 0.5,0.7, 0.75, 0.5,0.8, 0.75, 0.5), 3, 3, byrow = TRUE)
res_permut=rgcca_permutation(blocks=blocks,perm.par="tau",perm.value=perm.values,nperm=10)
print(res_permut)
plot(res_permut,type="crit")
plot(res_permut)

# crossvalidation
res_cv=rgcca_cv(blocks=blocks,par="tau",par_value=perm.values,n_cv=10)
print(res_cv)
plot(res_cv)

# variable selection (post process? significant variables)
resBootstrap=bootstrap(resRGCCA,n_boot = 5)
plot(resBootstrap) 
plot(resBootstrap,type="2D") 
print(resBootstrap)


#-------------------------
# rgcca with NA functions
#-------------------------
RussettWithNA=Russett
RussettWithNA[1:2,1:3]=NA
RussettWithNA[3,4:5]=NA
RussettWithNA[3,1]=NA
blocksNA = list(agriculture = RussettWithNA[, seq(3)], industry = RussettWithNA[, 4:5],
              politic = RussettWithNA[, 6:11] )

# vizualize patternNA
res_pattern=get_patternNA(blocksNA)
plot(res_pattern)

# choosing NA method
resWhich=whichNAmethod(blocksNA,listMethods = c("complete","nipals","knn4","em","sem"))
plot(resWhich,output="a",bars="stderr")
resRgcca=rgcca(blocksNA,method="knn4")

resNaEvol=naEvolution(blocksNA,listMethods = c("complete","nipals","knn4"),prctNA=c(0.1,0.2,0.3))
plot(resNaEvol,output="a")

#MIRGCCA
resMIRGCCA=MIRGCCA(blocks=blocksNA,option="knn",k=5,tau=rep(1,3))
plot(resMIRGCCA)

#====================================================================
# Checking other functionalities  with missing data
# complete method
resRGCCANA1=rgcca(blocksNA,method="complete")
plot(resRGCCANA1,type="ave")
plot(resRGCCANA1) 
plot(resRGCCANA1,type="cor") # cor (rgcca$A,) 
plot(resRGCCANA1,type="network")

resRGCCANA2=rgcca(blocksNA,method="nipals")
plot(resRGCCANA2,type="ave")
plot(resRGCCANA2) 
plot(resRGCCANA2,type="cor") # cor (rgcca$A,) 
plot(resRGCCANA2,type="network")

resRGCCANA3=rgcca(blocksNA,method="mean")
plot_ind(resRGCCANA3)
plot_var_2D(resRGCCANA3)
plot_var_1D(resRGCCANA3)
plot_ave(resRGCCANA3)

res_permut=rgcca_permutation(blocks=blocksNA)
plot(res_permut)
print(res_permut)
#choice of the number of components
par_value=matrix(c(1,1,1,2,2,1),2,3)
resCV=rgcca_cv(blocks,type="rgcca",par="ncomp",par_value=par_value,validation="kfold",k=5)
plot(resCV)
print(resCV)

resBootstrapNA1=bootstrap(resRGCCANA1,n_boot=50)
plot(resBootstrapNA1)
resBootstrapNA2=bootstrap(resRGCCANA2)
plot(resBootstrapNA2)
resBootstrapNA3=bootstrap(resRGCCANA3)
plot(resBootstrapNA3,type="2D")


# Crossvalidation # see with etienne


resRGCCANA1=rgcca(blocksNA,method="complete",response=2)
resRGCCANA2=rgcca(blocksNA,method="nipals",response=2)
resRGCCANA3=rgcca(blocksNA,method="knn4",response=2)

resCV=rgcca_crossvalidation(resRGCCANA1,validation="kfold") #
resCV=rgcca_crossvalidation(resRGCCANA2)
resCV=rgcca_crossvalidation(resRGCCANA3)
resCV$scores # mean absolute difference between observed and predicted

plot_ind(resRGCCANA1,predicted=resCV)
plot_ind(resRGCCANA2,predicted=resCV)
plot_ind(resRGCCANA3,predicted=resCV)

#----------------------------------
# What if only 1 variable in a block ?
#----------------------------------------
blocks = list(agriculture = Russett[, seq(3)], industry = Russett[, 4:5],
              politic = matrix(Russett[, 6] ,ncol=1))
rownames(blocks[[3]])=rownames(blocks[[1]])
colnames(blocks[[3]])=colnames(Russett)[6]
resRGCCA=rgcca(blocks,ncomp=c(2,2,1),superblock=FALSE)
summary(resRGCCA)
print(resRGCCA)
names(resRGCCA)
plot(resRGCCA,i_block=1)
#plot_ind(resRGCCA,compy=1)
plot_var_2D(resRGCCA,i_block=3) # mettre un message d'erreur plus appropri?? ! !
plot_var_2D(resRGCCA,i_block=2)
plot_var_1D(resRGCCA,i_block=2) #TODO
plot_var_1D(resRGCCA,i_block=3)
plot_ave(resRGCCA)

# choice of c1
#res_permut=rgcca_permutation(blocks=blocks,type="sgcca",p_c1=TRUE)
res_permut=rgcca_permutation(blocks=blocks,ncomp=c(2,2,1),perm.par="tau",perm.value=c(0.5,0.6,0.7)) # runs
plot(res_permut)
#choice of the number of components
res_permut=rgcca_permutation(blocks=blocks,perm.par="ncomp")
plot(res_permut)

# variable selection (post process? significant variables)
resBootstrap=bootstrap(resRGCCA)
plot(resBootstrap,i_block=2) 


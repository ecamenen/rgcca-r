set.seed(1)
data("Russett")
blocks <- list(
    agriculture = Russett[, seq(3)],
    industry = Russett[, 4:5],
    politic = Russett[, 6:11])
#res_rgcca=rgcca(blocks, method="rgcca",response=1)

res=rgcca_cv(blocks,response=length(blocks),method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),n_run=1,n_cores=1)
res
plot(res)

res=rgcca_cv(blocks,response=length(blocks),method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),n_run=1,n_cores=1,scale=FALSE,scale_block=FALSE)


res2=rgcca_cv(blocks,response=length(blocks), method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),n_run=5,n_cores=1)
plot(res)
res3=rgcca_cv(blocks,response=length(blocks), method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),n_run=5, one_value_per_cv = TRUE,n_cores=1)
plot(res)

# res4=rgcca_cv(blocks,response=length(blocks), method="rgcca",par_type="ncomp",par_value=c(1,2,3),n_run=5, one_value_per_cv = FALSE,n_cores=1)
# print(res3)

# plot(res4,bars="stderr")

res5=rgcca_cv(blocks,response=length(blocks), method="rgcca",par_type="sparsity",par_value=matrix(c(0.8,0.9,1,0.9,1,1),nrow=2,byrow = T),n_run=1, one_value_per_cv = FALSE,n_cores=1)
plot(res5,bars="points")
print(res5)



data("Russett")
blocks <- list(
    agriculture = Russett[, seq(3)],
    industry = Russett[, 4:5],
    politic = Russett[, 6])
res=rgcca(blocks,method="rgcca",ncomp=1)
blocks2=lapply(blocks,as.matrix)
res=rgcca_cv(blocks,response=length(blocks), method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),ncomp=1,n_run=1,n_cores=1)
plot(res)



blocks_for_classif = list(
    agriculture = Russett[, 1:3],
    industry = Russett[, 4:5],
    politic = matrix(Russett[, 11],ncol=1)
)
blocks_for_classif[["politic"]][blocks_for_classif[["politic"]][,1]==1,]="demo"
blocks_for_classif[["politic"]][blocks_for_classif[["politic"]][,1]==0,]="ndemo"

res=rgcca_cv(blocks_for_classif,response=3, method="rgcca",par_type="tau",par_value=c(0,0.2,0.3),ncomp=1,n_run=1,n_cores=1,type_cv="classification",fit="lda")
res
plot(res)

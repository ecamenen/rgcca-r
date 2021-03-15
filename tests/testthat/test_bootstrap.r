data("Russett")
blocks <- list(
    agriculture = Russett[, seq(3)],
    industry = Russett[, 4:5],
    politic = Russett[, 6:11] )
ncomp=1
rgcca_out <- rgcca(blocks,ncomp=1)
boot <- bootstrap(rgcca_out, n_boot = 4, n_cores = 1)

#init=Sys.time();boot <- bootstrap(rgcca_out, n_boot = 1000, n_cores = 1);Sys.time()-init
#init=Sys.time();boot <- bootstrap(rgcca_out, n_boot = 1000, para=FALSE);Sys.time()-init
#init=Sys.time();boot <- bootstrap(rgcca_out, n_boot = 1000, para=TRUE);Sys.time()-init


test_that("bootstrap_default_1", {
    expect_equal(length(boot), 2)
    expect_equal(length(boot$bootstrap), 1)
    boot1 <- boot$bootstrap[[1]]
    expect_is(boot, "bootstrap")
    expect_is(boot$rgcca, "rgcca")
    expect_is(boot1, "list")
    expect_is(boot1[[1]], "matrix")
    expect_true(all(sapply(boot1, NCOL) == 4))
    expect_identical(sapply(boot1, NROW), sapply(rgcca_out$call$blocks, NCOL))
})

# ncomp=2
rgcca_out <- rgcca(blocks,ncomp=2)
boot <- bootstrap(rgcca_out, n_boot = 2, n_cores = 1)

test_that("bootstrap_default", {
    expect_equal(length(boot), 2)
    expect_equal(length(boot$bootstrap), 2)
    boot1 <- boot$bootstrap[[1]]
    expect_is(boot, "bootstrap")
    expect_is(boot$rgcca, "rgcca")
    expect_is(boot1, "list")
    expect_is(boot1[[1]], "matrix")
    expect_true(all(sapply(boot1, NCOL) == 2))
    expect_identical(sapply(boot1, NROW), sapply(rgcca_out$call$blocks, NCOL))
})

test_that("bootstrap_default", {
    select_var <- get_bootstrap(boot)
    expect_is(select_var, "df_bootstrap")
    expect_is(select_var, "data.frame")
    expect_identical(NROW(select_var), NCOL(rgcca_out$call$blocks[[length(rgcca_out$call$blocks)]]))
})

# test_that("bootstrap_with_args", {
#     rgcca_out <- rgcca(blocks, superblock = FALSE)
#     expect_is(
#         bootstrap(
#             rgcca_out,
#             n_boot = 2,
#             n_cores = 1,
#             blocks = lapply(blocks, scale),
#             superblock = FALSE),
#         "bootstrap")
# })

blocks[[1]][1:3, 1] <- NA
blocks[[1]][4,] <- NA
resRGCCA <- rgcca(blocks, ncomp = c(2,2,2),superblock=FALSE)
set.seed(seed = 18)
resBootstrap <- bootstrap( rgcca=resRGCCA, n_boot = 2, n_cores = 1)
select_var <- get_bootstrap(resBootstrap,display_order=TRUE)
plot_bootstrap_1D(df_b = select_var)
#plot(resBootstrap)
test_that("test_bootstrap_na_values", {
    expect_equal(
        select_var["demostab", "mean"],
        mean(c(resBootstrap$bootstrap[[1]][["politic"]]["demostab", ]))
    )
    expect_true(select_var["demostab", "estimate"] == resRGCCA$a[[3]]["demostab", 1])
})

# bootstrap superblock
data("Russett")
blocks <- list(
    agriculture = Russett[, seq(3)],
    industry = Russett[, 4:5],
    politic = Russett[, 6:11] )
ncomp=1
rgcca_out <- rgcca(blocks,ncomp=2,superblock=TRUE)
boot <- bootstrap(rgcca_out, n_boot = 100, n_cores = 1)
plot(boot)
print(boot)
plot(rgcca_out,type="var")

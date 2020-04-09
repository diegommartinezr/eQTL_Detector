par(mfrow = c(1,2))

d = read.table("~/Results/cis_permutations.txt", hea=F, stringsAsFactors=F)
plot(d$V18, d$V19, xlab="Direct method", ylab="Beta approximation", main="")
abline(0, 1, col="red")

d = read.table("~/Results/cis_permutations_N.txt", hea=F, stringsAsFactors=F)
plot(d$V18, d$V19, xlab="Direct method", ylab="Beta approximation", main="")
abline(0, 1, col="red")

d = read.table("permutations_full.txt.gz", hea=F, stringsAsFactors=F)
plot(d$V18, d$V19, xlab="Direct method", ylab="Beta approximation", main="")
abline(0, 1, col="red")
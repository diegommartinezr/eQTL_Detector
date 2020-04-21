setwd("/home/rstudio")
library(rlist)
library(readr)
home <- getwd()
quan <- file.path(home,"Results/quan")
setwd(quan)
list_quan <- list.files(path = quan)
list_quan <- list_quan [! list_quan %in% c("stats")]


list_quan <- lapply(list_quan, function(x){
  read_delim(file = x,"\t", escape_double = FALSE, trim_ws = TRUE)})

largo <- length(list_quan)
vector_samples <- c(1:largo)

list_all <- list.cbind(list_quan)

RPKM <- data.frame(matrix(ncol = largo,
                          nrow = length(list_quan[[1]]$start)))

samples_names <- matrix(NA)

for (a in vector_samples) {
  list_col <- colnames(list_all)
  samples_names[a] <- list_col[a*7]
  RPKM[,a] <- list_all[,a*7]
  colnames(RPKM) <- samples_names
}

RPKM <- cbind(list_quan[[1]][,1:6],RPKM)

write.table(RPKM, "RPKM.bed")

setwd("C:/Users/martindi/Desktop/eQTL_Detector")
home <- getwd()
quan <- file.path(home,"Results/quan")
setwd(quan)
list_quan <- list.files(path = quan)


list_quan <- lapply(list_quan, function(x){
  read_delim(file = x,"\t", escape_double = FALSE, trim_ws = TRUE)})


largo <- length(list_quan)
vector_samples <- c(1:largo)

for (a in vector_samples) {
  sample_name <- colnames(list_quan[[a]][,7])
  sample_quan <-data.frame(list_quan[[a]][,7])
  base_matrix <- list_quan[[1]][,1:6]
  RPKM <- data.frame(matrix(ncol = largo,
                            nrow = length(base_matrix$start)))
  RPKM[[a]] <- sample_quan[1]
}

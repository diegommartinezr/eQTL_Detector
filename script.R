Data <- read.csv("/home/rstudio/HG00381.chr22.bamstat.txt", sep = "")

summary(Data)

plot(Data$n_het_total~ Data$n_hom_total)

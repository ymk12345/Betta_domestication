#cores=detectCores()
args = commandArgs(trailingOnly=TRUE)
file=args[1]
wdir=args[2]
cores=2

#df <- read.table("~/Desktop/Fish/filtered_regions/chr1_kanchan_gt.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
df <- read.table(file, quote="\"", comment.char="", stringsAsFactors=FALSE)

library(foreach)
library(doParallel)

#setup parallel backend to use many processors
#cores=detectCores()
cl <- makeCluster(cores) #not to overload your computer
registerDoParallel(cl)

gt.df<-foreach(i=1:nrow(df),.combine=rbind) %do% {
  gt<-unlist(df[i,-c(1:3)])
  gt<-ifelse(gt=="0/0",df[i,2], ifelse(gt=="1/1", df[i,3], ifelse(gt=="0/1", ".", ifelse(gt=="1/0", ".",  "N"))))
  if(length(unique(gt)[which(unique(gt)!="N")])==1){
    c(NA,gt)}else{
  c(df[i,1],gt)}
  
}
gt.df<-as.data.frame(gt.df)
gt.df<-gt.df[which(!is.na(gt.df$V1)),]
gt.df<-gt.df[order(as.numeric(as.character(gt.df$V1))),]
message(paste0(gsub(".txt", "", file), "_inputtable.txt"))
write.table(gt.df, file = paste0(gsub(".txt", "", file), "_inputtable.txt"), quote = FALSE, sep = ",", col.names = FALSE, row.names = FALSE)


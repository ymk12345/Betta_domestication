args<-commandArgs(trailingOnly = TRUE)

ldpath<-args[1]
frqpath<-args[2]
outdir<-args[3]

ld <- read.delim(ldpath, sep = "", header = FALSE)
frq <- read.delim(frqpath, sep="")

'%nin%' <- Negate('%in%')

df<-cbind(ld[c(4,5,6)], frq[match(ld[,6], frq$SNP),c(3,4,5)])
df<-cbind(df, ld[,3])
colnames(df)<-c("#CHROMOSOME", "POSITION", "NAME", "MAJOR_ALLELE", "MINOR_ALLELE", "MAF", "ANCHOR_SNP")


df.anchors<-cbind(unique(ld[,c(1,2,3)]), frq[match(unique(ld[,3]), frq$SNP),c(3,4,5)])
colnames(df.anchors)<-c("#CHROMOSOME", "POSITION", "NAME", "MAJOR_ALLELE", "MINOR_ALLELE", "MAF")
df.anchors$ANCHOR_SNP<-""
df<-df[which(df$NAME %nin% df.anchors$NAME),]


df<-rbind(df.anchors, df)
df<-df[order(df$`#CHROMOSOME`,df$POSITION),]
df$PANEL<-""
df<-df[which(df[,2]!="BP_A" & df[,2]!="BP_B"),]

setwd(outdir)
write.table(df, file = paste0(basename(frqpath), "ld.hapmap.txt"), quote = FALSE, sep = "\t", row.names = FALSE)

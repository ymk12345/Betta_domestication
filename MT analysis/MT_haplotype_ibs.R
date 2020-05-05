
# Requires VCFpath and Fraction_missing for each individual

my_vcf<-"NC_026581.1_lib_run_check.filtered.recode.vcf"
vcf_imiss<-"NC_026581.1_lib_run_check.filtered.imiss"
inputdir<-""


setwd(inputdir)
imiss <- read.delim(vcf_imiss)

library(SNPRelate)
snpgdsVCF2GDS(my_vcf, paste0(my_vcf, ".gds"), method="biallelic.only")
(genofile <- snpgdsOpen(paste0(my_vcf, ".gds")))
ibs <- snpgdsIBS(genofile, autosome.only=FALSE,  missing.rate=0.4,
                 sample.id = imiss$INDV[which(imiss$F_MISS<0.8)])


ibs.matrix<-ibs$ibs
colnames(ibs.matrix)<-ibs$sample.id

hc <- hclust(as.dist(1 - ibs.matrix))



pdf("Hclust_IBS_check_MT.pdf", height = 10, width = 20)
plot(hc)
dev.off()

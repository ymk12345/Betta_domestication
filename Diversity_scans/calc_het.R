# Heterozygosity:
# NOTE: THIS HAS TO BE DONE USING THE INVARIANT VCF FILE

args = commandArgs(trailingOnly=TRUE)
vcfpath1=args[1]
vcfpath2=args[2]
newoutdir=args[3]


# Obtain GTs:

gt_calls<-function(vcfpath, outdir){
  x<-paste0('vcftools ', vcfpath,
            ' --out ', outdir, "/", basename(vcfpath),
            ' --extract-FORMAT-info GT')
  system(x)
}
gt_hets<-function(gtpath){
  
  samples.gt <- read.delim(gtpath, stringsAsFactors=FALSE, header = TRUE)
  
  # Individual Het:
  samples.gt.het.num<-apply(samples.gt[,-c(1:2)], 2, function(x){
    length(which(x=="0/1" | x=="1/0"))
  })
  samples.gt.tot.num<-apply(samples.gt[,-c(1:2)], 2, function(x){
    length(which(x!="./."))
  })
  
  i.het<-data.frame(Het.number=samples.gt.het.num, 
                    Tot.number =samples.gt.tot.num, 
                    Het=samples.gt.het.num/samples.gt.tot.num)
  
  
  # Pairwise Het:
  between_het<-NULL
  for(x in c(3:ncol(samples.gt))){
    for(y in c(3:ncol(samples.gt))){
      if(y!=x){
        between_het<-rbind(between_het, c(colnames(samples.gt)[x], 
                                          colnames(samples.gt)[y], 
                                          length(which(samples.gt[,x]!=samples.gt[,y] & samples.gt[,x]!="./." & samples.gt[,y]!="./."))/length(which(samples.gt[,x]!="./." & samples.gt[,y]!="./."))))
        #between_het<-c(between_het, c(length(which(orn.gt[,x]!=orn.gt[,y] & orn.gt[,x]!="./." & orn.gt[,y]!="./."))/length(which(orn.gt[,x]!="./." & orn.gt[,y]!="./."))))
        
      }
      
    }
    
  }
  between_het<-as.data.frame(between_het)
  colnames(between_het)<-c("S1", "S2", "Het")
  between_het$Het<-as.numeric(as.character(between_het$Het))
  
  hets<-list(i.het, between_het)
  return(hets)
}


dir.create(newoutdir)
setwd(newoutdir)
gt_calls(vcfpath1, newoutdir)
gt_calls(vcfpath2, newoutdir)


# Calc Hets:
gt.list<-list.filest("*.GT.FORMAT")

#test<-gt_hets(gtpath)

gt.het.pop1<-gt_hets(gt.list[1])
gt.het.pop2<-gt_hets(gt.list[2])


par(mfrow=c(1,2))
hist(gt.het.pop1[[1]]$Het,  main = "Ornamental", xlim = c(0, 0.02), breaks = 15, xlab = c("Heterozygosity"))
hist(gt.het.pop2[[1]]$Het,  breaks = 5, main = "Kanchanaburi", xlim = c(0, 0.02), xlab = c("Heterozygosity"))



par(mfrow=c(1,2))
hist(gt.het.pop1[[2]]$Het,  main = "Ornamental: Pair-wise", xlim = c(0, 0.02), breaks = 15, xlab = c("Heterozygosity"))
hist(gt.het.pop2[[2]]$Het,  breaks = 5, main = "Kanchanaburi: Pair-wise", xlim = c(0, 0.02), xlab = c("Heterozygosity"))












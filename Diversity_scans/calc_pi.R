# Per site-pi calculation:

sites_call<-function(samplelistpath, pop, outprefix, vcfpath){
  x<-paste0('vcftools ', vcfpath,
            ' --keep ', pop1,
            ' --out ', outprefix, pop,
            ' --sites-pi')
  system(x)
}

pi.gr<-function(pi){
  
  pi<-pi[,c(1,2,2,3)]
  colnames(pi)<-c("CHROM", "START", "END", "PI")
  pi<-makeGRangesFromDataFrame(pi, keep.extra.columns = TRUE)
  return(pi)
}
pi.calc.bed<-function(pi.gr1, pi.gr2, bedfilepath, type="genome"){
  if(type=="genome"){
    bed <- read.delim(bedfilepath, header=FALSE, stringsAsFactors=FALSE)
    colnames(bed)<-c("CHR", "START", "END")
    
    pi1.total<-sum(mcols(pi.gr1)[,1])/sum(width(genome.gr))
    pi2.total<-sum(mcols(pi.gr1)[,2])/sum(width(genome.gr))
    
    pis<-c(pi1.total, pi2.total, sum(width(genome.gr)))
    
  }else{
    bed <- read.delim(bedfilepath, header=FALSE, stringsAsFactors=FALSE)
    colnames(bed)<-c("CHR", "START", "END")
    bed.gr<-makeGRangesFromDataFrame(bed)
    
    
    pi1.hits<-findOverlaps(pi.gr1, bed.gr, type = "within")
    pi1.total<-sum(mcols(pi.gr1)[,1][queryHits(pi1.hits)])/sum(width(bed.gr))
    
    pi2.hits<-findOverlaps(pi.gr2, bed.gr, type = "within")
    pi2.total<-sum(mcols(pi.gr2)[,1][queryHits(pi2.hits)])/sum(width(bed.gr))
    
    pis<-c(pi1.total, pi2.total, sum(width(bed.gr)))
    
  }
  return(pis)
}


orn.pi <- read.delim(paste0(outprefix, "orn.sites.pi"), stringsAsFactors=FALSE)
orn.pi.gr<-pi.gr(orn.pi)

kan.pi <- read.delim(paste0(outprefix, "kan.sites.pi"), stringsAsFactors=FALSE)
kan.pi.gr<-pi.gr(kan.pi)


bedfilefolder<-""
bedfiles<-list.files(".bed")


genome<-pi.calc.bed(orn.pi.gr, kan.pi.gr, bedfiles[1], type="genome")
exon<-pi.calc.bed(orn.pi.gr, kan.pi.gr, bedfiles[2], type="exon")
intron<-pi.calc.bed(orn.pi.gr, kan.pi.gr, bedfiles[2], type="intron")
intergenic<-pi.calc.bed(orn.pi.gr, kan.pi.gr, bedfiles[2], type="intergenic")

nuc.table<-data.frame(Nuc.div = c("Genome", "exon", "intron", "intergenic"),
            Availble.sites=c(genome[3], exon[3], intron[3], intergenic[3]),
            pop1=c(genome[1], exon[1], intron[1], intergenic[1]),
            pop2=c(genome[2], exon[2], intron[2], intergenic[2]))

print(nuc.table)
write.csv(nuc.table, paste0(Sys.Date, ".nuc.table.csv"), row.names = FALSE)
            



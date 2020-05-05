library(ggplot2)
library(stringr)

# Set Working Directory to all outputs from the xcheckfingerprint.sh
wdir<-"/Volumes/Kelley10TB-2020B/Fingerprinting_runs_Betta/"


setwd(wdir)

files<-list.files(pattern="*.txt")

df<-NULL
for(x in files){
  fp <- read.delim(x, comment.char="#")
  fp$RIGHT_FILE<-basename(fp$RIGHT_FILE)
  fp$RRUN<-str_split_fixed(str_split_fixed(fp$RIGHT_FILE, "run", 2)[,2], "_", 2)[,1]
  fp$RRUN<-ifelse(fp$RRUN=="", 5, fp$RRUN)
  fp$RIGHT_FILE<-str_split_fixed(fp$RIGHT_FILE, "_md", 2)[,1]
  fp$RIGHT_FILE<-str_split_fixed(fp$RIGHT_FILE, "_rmd", 2)[,1]
  fp$RIGHT_FILE<-paste0(fp$RIGHT_FILE, "_", fp$RRUN)
  
  fp$LEFT_FILE<-basename(fp$LEFT_FILE)
  fp$LRUN<-str_split_fixed(str_split_fixed(fp$LEFT_FILE, "run", 2)[,2], "_", 2)[,1]
  fp$LRUN<-ifelse(fp$LRUN=="", 5, fp$LRUN)
  fp$LEFT_FILE<-str_split_fixed(fp$LEFT_FILE, "_md", 2)[,1]
  fp$LEFT_FILE<-str_split_fixed(fp$LEFT_FILE, "_rmd", 2)[,1]
  fp$LEFT_FILE<-paste0(fp$LEFT_FILE, "_", fp$LRUN)
  
  fp$LEFT_SAMPLE<-str_split_fixed(fp$LEFT_FILE, "_", 2)[,1]
  fp$RIGHT_SAMPLE<-str_split_fixed(fp$RIGHT_FILE, "_", 2)[,1]
  fp$RESULT_AB<-ifelse(fp$LEFT_SAMPLE!=fp$RIGHT_SAMPLE & fp$RESULT=="UNEXPECTED_MATCH",
                       "EXPECTED_MISMATCH", ifelse(fp$LEFT_SAMPLE!=fp$RIGHT_SAMPLE & fp$RESULT=="EXPECTED_MATCH", 
                                                   "UNEXPECTED_MATCH",
                                                   ifelse(fp$LEFT_SAMPLE!=fp$RIGHT_SAMPLE & fp$RESULT=="UNEXPECTED_MISMATCH", "EXPECTED_MISMATCH", fp$RESULT)))
  
  fp1<-fp
  fp1$LEFT_FILE<-fp$RIGHT_FILE
  fp1$RIGHT_FILE<-fp$LEFT_FILE
  df<-rbind(df, fp)
  df<-rbind(df, fp1)
}

pdf(paste0(Sys.Date(), "_fingerprint_plot.pdf"), height = 13, width = 14.7)
ggplot(df, aes(LEFT_FILE, RIGHT_FILE, fill = RESULT_AB, color = RESULT_AB))+
  geom_point(size = 3, shape = 15)+
  theme_bw()+
  theme(axis.text.x=element_text(angle=90,vjust=0.5))+
  scale_color_manual(values = c("grey", "#E5E5E5", "cornflowerblue", "red", "#C80F0F"))
dev.off()
#!/bin/bash

list=$1
outdir=$2
REF=$3
#/moto/ziab/users/yk2840/Fish_workspace/reference/Betta_splendens.fBetSpl5.2.dna.toplevel.fa

while read FILE; do

        NAME=$(basename "$FILE")
	
	if [ ! -f  ${outdir}/${NAME%%.*}.bam ]; then
	echo -e "$NAME"

        bwa mem -t 12 -M $REF ${FILE}_trim_1P.fq.gz ${FILE}_trim_2P.fq.gz | samtools sort -@10 -o ${outdir}/${NAME%%.*}.bam
	
	fi

	if [ ! -f ${outdir}/${NAME%%.*}_dupmetrics.txt ]; then
	
        java -jar /moto/ziab/users/yk2840/software/picard/build/libs/picardcloud.jar MarkDuplicates \
          I=${outdir}/${NAME%%.*}.bam \
	  REMOVE_DUPLICATES=true \
          O=${outdir}/${NAME%%.*}_rmd.bam \
          M=${outdir}/${NAME%%.*}_dupmetrics.txt

	fi

	echo -e "$NAME" >> ${outdir}/files.txt

done<$list




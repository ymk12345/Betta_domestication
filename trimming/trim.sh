#!/bin/bash

RAWFASTQDIR=$1 # requires full path for folder
OUTDIR=$2
LOG=$3

ls -1 $RAWFASTQDIR/*.gz | cut -d R -f 1 | uniq - >$OUTDIR/rawfastqlist.txt

while read FILE; do

NAME=$(basename "$FILE")

java -jar /moto/ziab/users/yk2840/software/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
	-threads 12 \
	-phred33 \
	${FILE}R1_001.fastq.gz ${FILE}R2_001.fastq.gz \
	$OUTDIR/${NAME}R1_001_trimmed.fastq.gz $OUTDIR/${NAME}R1_001_trimmed_unpaired.fastq.gz \
        $OUTDIR/${NAME}R2_001_trimmed.fastq.gz $OUTDIR/${NAME}R2_001_trimmed_unpaired.fastq.gz \
	-trimlog $LOG \
	ILLUMINACLIP:/moto/ziab/users/yk2840/Fish_workspace/indiv_runs/TruSeq3-PE_v1.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

done<$OUTDIR/rawfastqlist.txt

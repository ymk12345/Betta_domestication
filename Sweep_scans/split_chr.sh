#!/bin/bash

VCF=$1
MINMAF=$2
MAXMAF=$3
OUTDIR=$4

module load anaconda
source activate /moto/ziab/users/yk2840/software/py27

mkdir $OUTDIR
NAME=$(basename "$VCF")
FILTEREXP=$(echo -e "MAF<$MINMAF || F_MISSING>0.1 || MAF>$MAXMAF")

seq 1 2 | xargs -n1 -P1 -I {} bcftools filter -e "$FILTEREXP" --regions {} -o ${OUTDIR}/${NAME%.*}.chr{}.maf${MINMAF}.${MAXMAF}.vcf $VCF

ls -1 ${OUTDIR}/${NAME%.*}.chr*.vcf > ${OUTDIR}/${NAME%.*}_vcflist.txt

for WIN in 50 75 100 150 200 250 300 350 400 450; do

bash ./g12_hscan.sh ${OUTDIR}/${NAME%.*}_vcflist.txt $OUTDIR $WIN

done

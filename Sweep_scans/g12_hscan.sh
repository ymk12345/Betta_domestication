#!/bin/bash

LIST=$1
OUTDIR=$2
GWINDOW=$3

module load anaconda
source activate /moto/ziab/users/yk2840/software/py27
module load R

while read FILE; do

NAME=$(basename "$FILE")
NAME_TEMP=$(echo $NAME | sed 's/\.[^.]*$//')
echo $NAME_TEMP

bcftools query -f '%POS %REF %ALT[\t%GT]\n' $FILE > ${OUTDIR}/${NAME_TEMP}_gt.txt

Rscript ./convert_vcfforH12_H2H1.R  ${OUTDIR}/${NAME_TEMP}_gt.txt $OUTDIR 


NSAMP=$(bcftools query -l $FILE | wc -l)

echo "G12"

python2.7 /moto/ziab/users/yk2840/software/SelectionHapStats/scripts/H12_H2H1.py ${OUTDIR}/${NAME_TEMP}_gt_inputtable.txt $NSAMP -w $GWINDOW -o $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12.txt

python2.7 /moto/ziab/users/yk2840/software/SelectionHapStats/scripts/H12peakFinder.py $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12.txt \
	-t 0.02 \
	-o $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12_t0.02.txt

Rscript /moto/ziab/users/yk2840/software/SelectionHapStats/scripts/H12_viz.R $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12.txt $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12_t0.02.txt $OUTDIR/${NAME_TEMP}_${GWINDOW}w_g12_t0.02.pdf 10

echo "H-scan"

H-scan -i ${OUTDIR}/${NAME_TEMP}_gt_inputtable.txt -d1 > ${OUTDIR}/${NAME_TEMP}_gt_Hscan.txt

done<$LIST

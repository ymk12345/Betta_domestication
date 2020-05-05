#!/bin/bash
LIST=$1
LIST1=$2
OUTDIR=$3

while read FILE; do

	while read FILE1; do
	echo -e $FILE
	echo -e $FILE1
        NAME=$(basename "$FILE")
        NAME1=$(basename "$FILE1")


	if [[ ! -f $OUTDIR/${NAME%%.*}_${NAME1%%.*}_xcheck.txt ]]; then
	    if [[ ! -f $OUTDIR/${NAME1%%.*}_${NAME%%.*}_xcheck.txt ]]; then
	
		if [[ "$FILE" != "$FILE1" ]]; then

		java -jar /moto/ziab/users/yk2840/software/picard/build/libs/picardcloud.jar CrosscheckFingerprints \
        	  	I=$FILE \
	  		SI=$FILE1 \
	  		HAPLOTYPE_MAP=Betta_GATK_filtered_forFingerprint.recode.renamed.chr.thin10.maf0.3.0.95.frqld.hapmap.complete.txt\
	  		LOD_THRESHOLD=-5 \
	  		OUTPUT=$OUTDIR/${NAME%%.*}_${NAME1%%.*}_xcheck.txt
	
		fi
	fi
	fi
	done<$LIST1

done<$LIST

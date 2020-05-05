#!/bin/bash

# Quick Command-line script for SPDI FORMAT for VEP:

my_vcf="NC_026581.1_lib_run_check.filtered.recode.vcf"

# If uncompressed:
bgzip -c $my_vcf > ${my_vcf}.gz
tabix -p vcf ${my_vcf}.gz


# If NCBI MT:
bcftools annotate --rename-chrs ensembl_ncbi_translation.txt -Ou ${my_vcf}.gz | bcftools query -f'%CHROM:%POS:%REF:%ALT\n' vcfpath > ${my_vcf}.vep


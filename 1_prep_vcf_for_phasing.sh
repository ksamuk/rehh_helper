#!/bin/bash

#name of the vcf file

vcf_gz_file="hoh.GATK.total.vcf.gz"
vcf_recode="hoh.GATK.total.invar.vcf.recode.vcf_fixed.recode.vcf"

#directories
vcf="vcf"
vcf_lg="vcf/by_lg"

if [ ! -d "$vcf" ]; then
	mkdir $vcf
fi

if [ ! -d "$vcf_lg" ]; then
	mkdir $vcf_lg
fi

#chromosome set names (for subsetting)
chr_set="groupI groupII groupIII groupIV groupV groupVI groupVII groupVIII groupIX groupX groupXI groupXII groupXIII groupXIV groupXV groupXVI groupXVII groupXVIII groupXIX groupXX groupXXI" 

#filter vcf to remove monomorphic sites
#vcftools --recode --gzvcf $vcf/hoh.GATK.total.vcf.gz --min-alleles 2 --max-alleles 2 --out $vcf/hoh.GATK.total.vcf.invar.vcf

# split by chromosome
for lg in $chr_set
do
vcftools --recode --vcf $vcf/$vcf_recode --chr $lg --max-missing 0.5 --out $vcf_lg/$lg.$vcf_recode
done

#clean up names and log files

rename .invar.vcf.recode.vcf_fixed.recode.vcf.recode.vcf .vcf $vcf_lg/*.vcf
rm $vcf/*.log
rm $vcf_lg/*.log
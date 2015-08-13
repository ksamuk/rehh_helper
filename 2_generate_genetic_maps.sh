#!/bin/bash

# directories

vcf_lg="vcf/by_lg"
maps="genetic_maps"
raw_sites="genetic_maps/raw_sites"

rm $maps/*.genmap

rm $raw_sites/*.txt

# NB: expecting there to be a master genetic map text file in $maps folder

# get the site list for each vcf file and write it to "raw_sites"

file_list=$(ls ${vcf_lg}) 

for lg in $file_list
do
grep -v "##" $vcf_lg/$lg | awk '{print $2}' > $raw_sites/$lg.sites.txt
done

# run the R script to build the genetic maps
Rscript build_genetic_maps.R 





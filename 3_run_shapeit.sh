#!/bin/bash

# run shape it

shapeit --input-vcf vcf/by_lg/groupIV.hoh.GATK.total.vcf \
        -M genetic_maps/groupI.hoh.GATK.total.vcf.sites.txt.genmap \
        -O phased/groupIV.hoh.phased \
        --output-log phased/groupIV.hoh.phasedlog \
        --exclude-ind excluded.inds \
        --thread 6
        
shapeit -convert \
    --input-haps phased/groupIV.hoh.phased \
    --output-vcf phased/vcf/groupIV.hoh.phased.vcf
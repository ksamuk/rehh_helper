# rehh_helper

Convenience scripts for preparing VCF files for input into the R package 'rehh'. These functions perform all the necessary pre-processing to go from a VCF file to extended haplotype homozygosity statistics (EHH, iHS). 

## Requirements

- R and the package 'rehh'
- The phasing software 'Shapeit'
- A VCF file of genotypes
- A genetic map file with the following format:

chrom.name  pos1  pos2  gen1  gen2  rate
1	715797	956634	0.0000002	0.711856	2.955757629
1	956634	983330	0.711856	0.7118561	3.74588E-06
1	983330	1190613	0.7118561	1.665939	4.602803414

- (implictly this also requires your VCF to be reference-based and your genetic map to correspond to the genomic coordinates in your VCF)  


## 1. Filter a VCF and split it into chromosomes

## 2. Create genetic maps for each chromosome 

## 3. Phase genotypes with 'Shapeit'

## 4. Analyze phased genotypes with rehh


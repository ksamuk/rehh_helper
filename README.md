# rehh_helper

Convenience scripts for preparing VCF files for input into the R package 'rehh'. These functions perform all the necessary pre-processing to go from a VCF file to extended haplotype homozygosity statistics (EHH, iHS). 

## Requirements

- R and the package 'rehh'
- The phasing software 'Shapeit'
- A VCF file of genotypes
- A genetic map file with the following format:

|chrom|pos1|pos2|gen1|gen2|rate|
|---|---|---|---|---|---|
|1|715797|956634|0.0000002|0.711856|2.955757629|

Where:

- chrom = name of a chromosome
- pos1 = first physical position
- pos2 = second physical position
- gen1 = first map position (cM)
- gen2 = second map position (cM)
- rate = recombination rate (cM/MB)

Implictly, this also requires your VCF to be reference-based and your genetic map to correspond to the genomic coordinates in your VCF.  

## Processing steps

#### 1. Filter a VCF and split it into chromosomes

#### 2. Create genetic maps for each chromosome 

#### 3. Phase genotypes with 'Shapeit'

#### 4. Analyze phased genotypes with rehh


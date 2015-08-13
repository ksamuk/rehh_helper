# run rehh on the output of a shapeit file (.haps)

# libraries

rm(list=ls())
library("rehh")
library("dplyr")
library("ggplot2")

#surpise!
chrom.to.num <- function(x){
  x <- gsub("group", "", x)
  chrom.rom <- as.character(as.roman(c(1:21)))
  return(match(x, chrom.rom))
}

# input file locations

haps.files <- list.files("phased", pattern = ".haps", full.names = TRUE)
haps.file <- read.table(haps.files[1], stringsAsFactors = FALSE)

sample.files <- list.files("phased", pattern = ".sample", full.names = TRUE)
sample.file <- read.table(sample.files[1], header = TRUE, stringsAsFactors = FALSE)
sample.file <- sample.file[-1,]


# what rehh is looking for:
#id 1 1 2 1 2-

#Map file contains SNPs information in five columns SNP names, chromosome, position,
#ancestral and derived allele.

#make the map file

map.file <- data.frame(snp.name = 1:length(haps.file[,1]) , lg = chrom.to.num(haps.file[,1]), pos = haps.file[,3], anc = rep(1, length(haps.file[,1])) , der = rep(2, length(haps.file[,1])))

# make the hap input file

hap.input <- haps.file[,-(1:5)] %>% as.matrix
row.names(hap.input) <- haps.file[,3]
colnames(hap.input) <- rep(sample.file$ID_1, each = 2)
hap.input <- hap.input + 1
hap.input <- t(hap.input)

#annotate rows properly (no dup rows allows)

haplo.names <- rep(sample.file$ID_1, each = 2)
first.haplos <- seq(from = 1, to = length(haplo.names), by = 2)
second.haplos <- seq(from = 2, to = length(haplo.names), by = 2)

haplo.names[first.haplos] <- paste0(haplo.names[first.haplos],"_1")
haplo.names[second.haplos] <- paste0(haplo.names[second.haplos],"_2")

hap.input <- data.frame(hap.input) %>%
  mutate(ind = haplo.names) %>%
  select(ind, everything())

# write to file (necessary for rehh for some reason)
write.table(hap.input, file = "test.hap", quote = FALSE, col.names = FALSE, row.names = FALSE)
write.table(map.file, file = "map.file", quote = FALSE, col.names = FALSE, row.names = FALSE)

test.in <- data2haplohh(hap_file = "test.hap", map_file = "map.file")

test.ehh.scan <- scan_hh(test.in)
test.ihs <- ihh2ihs(test.ehh.scan, freqbin=0.05)

ihsplot(test.ihs$res.ihs,plot.pval=TRUE,ylim.scan=2,main="iHS (CGU cattle breed)")

ihs.df <- data.frame(test.ihs$res.ihs)

distribplot(test.ihs$res.ihs[,3])


plot(ihs.df$POSITION, ihs.df$iHS, col = (ihs.df$Pvalue < 0.01)+1)

bifurcation.diagram(test.in,mrk_foc=816,all_foc=2,nmrk_l=100,nmrk_r=100,
                    main="Bifurcation diagram (RXFP2 SNP on BTA12): Ancestral Allele")





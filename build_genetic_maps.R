# build a genetic map file from raw sites 
# for input into shapeit
# ks august 11/2015

# target: *space delim*
# pposition rrate gposition
# 72765 0.12455 0.00000
# 94172 0.12458 0.00266
# 94426 0.12461 0.00269

# libraries
library("dplyr")

# the location of the genetic map data
genetic.map.folder <- "genetic_maps"
raw.pos.files <- list.files("genetic_maps/raw_sites", full.names = TRUE)

# the genetic map data file
gen.map.file <- list.files(genetic.map.folder, pattern = "roesti", full.names = TRUE)
gen.map.file <- read.table(gen.map.file, header = TRUE, stringsAsFactors = FALSE)
names(gen.map.file)[1] <- "lg"

# the chrom to num function
chrom.to.num <- function(x){
  x <- gsub("group", "", x)
  chrom.rom <- as.character(as.roman(c(1:21)))
  return(match(x, chrom.rom))
}

# the function to build the map files
add_map_distance <- function(snp.file.name){
  
  # read in snp file and format
  snp.file <- read.table(snp.file.name, header = TRUE, stringsAsFactors = FALSE)
  names(snp.file) <- "pposition"
  snp.file$pposition <- as.numeric(snp.file$pposition)
  snp.file <- snp.file %>%
  arrange(pposition)
  snp.file$rrate <- NA
  snp.file$gposition <- NA
  
  # determine the lg and subset linkage map file appropriately
  
  lg.snps <- strsplit(snp.file.name, split = "/") %>% 
    unlist %>% 
    .[3] %>% 
    strsplit(split = "[.]") %>%
    unlist %>%
    .[1] %>%
    chrom.to.num
  
  map.file.lg <- gen.map.file %>%
    filter(lg == lg.snps)
  
  # calculate genetic distance

    for (k in 1:length(snp.file$pposition)){
      
      snp.pos <- snp.file$pposition[k]
      
      # find matching window for snp
      snp.pos.window <- map.file.lg[map.file.lg$pos1 < snp.pos & map.file.lg$pos2 >= snp.pos,]
      
      if (length(snp.pos.window$lg)>0){
        
        # how far (proportionally) snp is along window in bp
        snp.window.position <- 1 - (snp.pos.window$pos2 - snp.pos) / (snp.pos.window$pos2 - snp.pos.window$pos1)
        
        # convert to genetic distance
        snp.file$gposition[k] <- (snp.window.position * (snp.pos.window$gen2 - snp.pos.window$gen1)) + snp.pos.window$gen1
        snp.file$rrate[k] <- snp.pos.window$rate
        } else{
        snp.file$gposition[k] <- NA
        snp.file$rrate[k] <- NA
      }
      
    }
  
  snp.file <- snp.file %>%
    filter(!is.na(gposition))
  file.name <- strsplit(snp.file.name, split = "/") %>% unlist %>% .[3]
  file.name <- file.path(genetic.map.folder, paste0(file.name,".genmap"))
  write.table(snp.file, file = file.name, quote = FALSE, row.names = FALSE)
  
}

lapply(raw.pos.files, add_map_distance)

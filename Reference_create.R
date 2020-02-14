#!/usr/bin/env Rscript

library("optparse")
library("Biostrings")

option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, 
              help="input reference fasta file", metavar="character"),
  make_option(c("-a", "--adapter"), type="character", default=NULL, 
              help="input adapter fasta file", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="mature_hsa_adapter.fasta", 
              help="output file name [default= %default]", metavar="character"),
  make_option(c("-r", "--organism"), type="character", default="hsa", 
              help="Abbreviated name of the organism to be extracted [default= hsa]", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
if (length(opt$input) > 0 & length(opt$adapter) > 0){
  
  fastaFile <- readRNAStringSet(opt$input)
  adapter <- readDNAStringSet(opt$adapter)
  seq_name = names(fastaFile)
  fastaFile2<-fastaFile[grep(seq_name,pattern = paste0("^",opt$organism,"-"))]
  names(fastaFile2)<-sapply(strsplit(names(fastaFile2)," "),function(x){x[1]})
  mature<-DNAStringSet(fastaFile2)
  mature_adapter<-DNAStringSet(c(paste0(paste(mature),paste(adapter))))
  names(mature_adapter)<-names(mature)
  writeXStringSet(mature_adapter, opt$out, append=FALSE,
                  compress=FALSE, compression_level=NA, format="fasta")
  
} else {
  print("No input arguments")
  
}

#!/usr/bin/env Rscript

library("optparse")
library("Biostrings")
library(Rsamtools)

option_list = list(
  make_option(c("-b", "--bam"), type="character", default=NULL, 
              help="input bam file", metavar="character"),
  make_option(c("-a", "--adapter"), type="character", default=NULL, 
              help="input adapter fasta file", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=NULL, 
              help="output trimming bam and/or expression file", metavar="character"),
  make_option(c("-m", "--mode"), type="character", default="expression", 
              help="mode type (bam/expresion/bam_expression)", metavar="character"),
  make_option(c("-r", "--reference"), type="character", default="mature_hsa_adapter.fasta", 
              help="reference fasta file [default= mature_hsa_adapter.fasta]", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

mature <- readDNAStringSet(opt$reference)
adapter <- readDNAStringSet(opt$adapter)

bam <- scanBam(opt$bam)
mature_table<-data.frame(name = names(mature),len = nchar(mature)-nchar(adapter),stringsAsFactors = T)
mir_l<-mature_table$len[match(bam[[1]]$rname,mature_table$name)]
mir_dif<-mir_l-bam[[1]]$pos
mir_dif[is.na(mir_dif)]<-0
S_cigar<-as.numeric(unlist(lapply(strsplit(bam[[1]]$cigar,"S"),function(x){x[[1]][1]})))
S_cigar[is.na(S_cigar)]<-0
Select <-(mir_dif>15 & S_cigar<2)
if (sum(opt$mode %in% c("bam","bam_expression"))>0){
Sequence<-DNAStringSet(bam[[1]]$seq[Select],start = S_cigar[Select] + 1,end = mir_l[Select]+ S_cigar[Select] )
names(Sequence)<-bam[[1]]$qname[Select]
Quality<-PhredQuality(BStringSet(bam[[1]]$qual[Select],start = S_cigar[Select] + 1,end = mir_l[Select]+ S_cigar[Select] ))
names(Quality)<-bam[[1]]$qname[Select]
writeXStringSet(Sequence, paste0(opt$out,"_trimming.fq.gz"), append=FALSE,
                compress=TRUE, compression_level=NA, format="fastq",qualities = Quality) 
} else{
Expres<-(table(bam[[1]]$rname[Select]))[1:nrow(mature_table)]
Expres<-as.matrix(Expres)
colnames(Expres)<-unlist(strsplit(opt$bam,".bam"))
write.table(Expres,file =paste0(opt$out,".txt"),quote = F,sep = "\t")
}
if (sum(opt$mode == "bam_expression")>0){
  Expres<-(table(bam[[1]]$rname[Select]))[1:nrow(mature_table)]
  Expres<-as.matrix(Expres)
  colnames(Expres)<-unlist(strsplit(opt$bam,".bam"))
  write.table(Expres,file =paste0(opt$out,".txt"),quote = F,sep = "\t")
}



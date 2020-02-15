# AdapMiR: a new tool for trimming adapters and counts calculation in miRNA sequencing

### Example:
  * `Rscript Reference_create.R -i mature.fa.gz -r hsa -a adapter.fa -o mature_hsa_adapter.fasta`
  * `bwa index mature_hsa_adapter.fasta`
  * `bwa mem  mature_hsa_adapter.fasta input.fastq.gz | samtools view -F 4 -bS - > <bam file> `
  * `Rscript AdapMiR.R -b <bam file> -a adapter.fa -o <prefix> -m bam_expression -r mature_hsa_adapter.fasta`



Reference_create.R -h

Options:

        -i CHARACTER, --input=CHARACTER
                input reference fasta file

        -a CHARACTER, --adapter=CHARACTER
                input adapter fasta file

        -o CHARACTER, --out=CHARACTER
                output file name [default= mature_hsa_adapter.fasta]

        -r CHARACTER, --organism=CHARACTER
                Abbreviated name of the organism to be extracted [default= hsa]

        -h, --help
                Show this help message and exit

Rscript AdapMiR.R -h

Options:

        -b CHARACTER, --bam=CHARACTER
                input bam file

        -a CHARACTER, --adapter=CHARACTER
                input adapter fasta file

        -o CHARACTER, --out=CHARACTER
                output trimming bam and/or expression file

        -m CHARACTER, --mode=CHARACTER
                mode type (bam/expresion/bam_expression)

        -r CHARACTER, --reference=CHARACTER
                reference fasta file [default= mature_hsa_adapter.fasta]

        -l NUMERIC, --length=NUMERIC
                minimum read length [default= 15]

        -c NUMERIC, --clipping=NUMERIC
                max read clipping [default= 1]

        -h, --help
                Show this help message and exit

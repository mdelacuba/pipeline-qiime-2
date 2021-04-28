#! /bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----Before starting:
#Multiplexed paired-end read files (R1, R2 and I1 files) from each folder must be renamed and compressed to "forward.fastq.gz", "reverse.fastq.gz" and "barcodes.fastq.gz". It is recommendable to keep a backup of the files with their original name in another directory you want.

#Declaring and loading folders:
echo -n "Write the name(s) of your folder(s) separated by spaces (e.g.: folder1 folder2 folder3): "
read line
sed -i "s/array=/array=( $line ) #LAST FOLDERS: /g" q2-*.sh
echo "$line were successfully loaded"

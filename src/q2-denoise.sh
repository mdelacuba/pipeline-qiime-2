#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----QIIME 2 execution:
#-->>>> DENOISING <<<<--

array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 

echo "Executing the denoising step..."

#Execute denoising:
sh denoise.sh
sleep 2

#Tabulate number of sequences per ASV per sample (visualization):
for folder in "${array[@]}"
do
	qiime metadata tabulate \
	--m-input-file ./dada2_table-$folder.qza \
	--o-visualization ./dada2_table-$folder.qzv >> info-denoise.txt 2>> error-denoise.txt
done

#Tabulate the representative sequences (ASVs) (visualization):
for folder in "${array[@]}"
do
	qiime metadata tabulate \
	--m-input-file ./dada2_rep_seqs-$folder.qza \
	--o-visualization ./dada2_rep_seqs-$folder.qzv >> info-denoise.txt 2>> error-denoise.txt
done

#Tabulate denoising statistics (visualization):
for folder in "${array[@]}"
do
	qiime metadata tabulate \
	--m-input-file ./dada2_stats-$folder.qza \
	--o-visualization ./dada2_stats-$folder.qzv >> info-denoise.txt 2>> error-denoise.txt
done

#Tabulate summary of overall statistics:
for folder in "${array[@]}"
do
	qiime feature-table summarize \
	--i-table ./dada2_table-$folder.qza \
	--m-sample-metadata-file ./metadata-$folder.tsv \
	--o-visualization ./dada2_summary-$folder.qzv >> info-denoise.txt 2>> error-denoise.txt
done

echo "The denoising step has finished"


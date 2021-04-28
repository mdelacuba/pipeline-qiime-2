#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----QIIME 2 execution:
#->>> DEMULTIPLEXING <<<

array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 

echo "Executing the demultiplexing step..."

#Import multiplexed paired-end read files as an artifact:
for folder in "${array[@]}"
do
	qiime tools import \
	--type EMPPairedEndSequences \
	--input-path $folder \
	--output-path emp-paired-end-sequences-$folder.qza >> info-demux.txt 2>> error-demux.txt
done

#Demultiplexing:
for folder in "${array[@]}"
do
	qiime demux emp-paired \
	--m-barcodes-file metadata-$folder.tsv \
	--m-barcodes-column barcode-sequence \
	--p-rev-comp-mapping-barcodes \
	--i-seqs emp-paired-end-sequences-$folder.qza \
	--o-per-sample-sequences demux-full-$folder.qza \
	--o-error-correction-details demux-details-$folder.qza >> info-demux.txt 2>> error-demux.txt
done

#Summarize the info of the demultiplexed samples (visualization):
for folder in "${array[@]}"
do
	qiime demux summarize \
	--i-data demux-full-$folder.qza \
	--o-visualization demux-full-$folder.qzv >> info-demux.txt 2>> error-demux.txt
done

#Create a script for a custimizable denoising:
if [[ -e denoise.sh ]]
then
	rm denoise.sh
fi
echo "#!/bin/bash" >> denoise.sh
echo "#As the parameters for the denoising step depend on your own analysis of the quality control graphics, you must replace the words “REPLACE” in the commands within this file with the parameters you want to fix for this step. This file contain the sets of commands needed for denoising the reads of each folder independently, thereby, notice the name of the folder which the commands will be executed for is the correct one. If you don’t know how to fix the DADA2 parameters within QIIME 2, please check over this document: https://docs.qiime2.org/2020.11/plugins/available/dada2/denoise-paired/" >> denoise.sh
echo "#Also, you can delete the lines containing parameters you don’t need/want to fix for denoising." >> denoise.sh
echo -e "\n" >> denoise.sh
for folder in "${array[@]}"
do
	echo "qiime dada2 denoise-paired \\" >> denoise.sh
	echo "--i-demultiplexed-seqs ./demux-full-$folder.qza \\" >> denoise.sh
	echo "--p-trunc-len-f REPLACE \\" >> denoise.sh
	echo "--p-trunc-len-r REPLACE \\" >> denoise.sh
	echo "--p-trim-left-f REPLACE \\" >> denoise.sh
	echo "--p-trim-left-r REPLACE \\" >> denoise.sh
	echo "--p-trunc-q REPLACE \\" >> denoise.sh
	echo "--p-chimera-method consensus \\" >> denoise.sh
	echo "--p-n-threads REPLACE \\" >> denoise.sh
	echo "--o-table ./dada2_table-$folder.qza \\" >> denoise.sh
	echo "--o-representative-sequences ./dada2_rep_seqs-$folder.qza \\" >> denoise.sh
	echo "--o-denoising-stats ./dada2_stats-$folder.qza >> info-denoise.txt 2>> error-denoise.txt" >> denoise.sh
	echo -e "\n" >> denoise.sh
done

echo "The demultiplexing step has finished"

#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----QIIME 2 execution:
#->>> MERGING DATA <<<-- (optional)

array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 

echo "Executing the merging step..."

#Merge tables of sequences per ASV per sample:
echo "#!/bin/bash" >> tmp.sh
echo "qiime feature-table merge \\" >> tmp.sh
for folder in "${array[@]}"
do
	echo "--i-tables dada2_table-$folder.qza \\" >> tmp.sh
done
echo "--o-merged-table dada2_table-all.qza >> info-merge.txt 2>> error-merge.txt" >> tmp.sh
sh tmp.sh
sleep 2
rm tmp.sh

#Merge tables of representative sequences (ASV):
echo "#!/bin/bash" >> tmp.sh
echo "qiime feature-table merge-seqs \\" >> tmp.sh
for folder in "${array[@]}"
do
	echo "--i-data dada2_rep_seqs-$folder.qza \\" >> tmp.sh
done
echo "--o-merged-data dada2_rep_seqs-all.qza >> info-merge.txt 2>> error-merge.txt" >> tmp.sh
sh tmp.sh
sleep 2
rm tmp.sh

#Tabulate merged table of sequences per ASV per sample (visualization):
qiime metadata tabulate \
--m-input-file ./dada2_table-all.qza \
--o-visualization ./dada2_table-all.qzv >> info-merge.txt 2>> error-merge.txt

#Tabulate merged table of ASVs (visualization):
qiime metadata tabulate \
--m-input-file ./dada2_rep_seqs-all.qza \
--o-visualization ./dada2_rep_seqs-all.qzv >> info-merge.txt 2>> error-merge.txt

#Tabulate summary of overall statistics of the merged data (visualization):
qiime feature-table summarize \
--i-table ./dada2_table-all.qza \
--m-sample-metadata-file ./metadata-all.tsv \
--o-visualization ./dada2_summary-all.qzv >> info-merge.txt 2>> error-merge.txt

echo "The merging step has finished"


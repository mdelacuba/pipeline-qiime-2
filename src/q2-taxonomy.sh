#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----QIIME 2 execution:
#-->>>> TAXONOMY <<<<---

array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 
confidence=$1

echo "Executing the taxonomy step..."

#Construction of a taxonomy classifier (seqs and tax files from database):
#qiime feature-classifier fit-classifier-naive-bayes \
#--i-reference-reads silva-138-99-seqs-515-806.qza \
#--i-reference-taxonomy silva-138-99-tax-515-806.qza \
#--o-classifier classifier.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

#Taxonomy classification:
if [[ -e dada2_rep_seqs-all.qza ]]
then
	qiime feature-classifier classify-sklearn \
	--i-classifier classifier.qza \
	--i-reads dada2_rep_seqs-all.qza \
	--p-confidence $confidence \
	--o-classification taxonomy80-all.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Tabulate taxonomy classification (visualization):
	qiime metadata tabulate \
	--m-input-file taxonomy80-all.qza \
	--o-visualization taxonomy80-all.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Make barplots of taxonomy composition (visualization):
	qiime taxa barplot \
	--i-table ./dada2_table-all.qza \
	--i-taxonomy ./taxonomy80-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./taxa_barplot80-all.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Filter ASVs (table) unresolved to at least phylum, also mitochondria and chloroplast:
	qiime taxa filter-table \
	--i-table dada2_table-all.qza \
	--i-taxonomy taxonomy80-all.qza \
	--p-include p__ \
	--p-exclude mitochondria,chloroplast,Unassigned \
	--o-filtered-table table_taxa-all-filt.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Tabulate summary of overall statistics from filtered ASVs (Visualization):
	qiime feature-table summarize \
	--i-table table_taxa-all-filt.qza \
	--m-sample-metadata-file ./metadata-all.tsv \
	--o-visualization summary-all-filt.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Make barplots of taxonomy composition from filtered ASVs (Visualization):
	qiime taxa barplot \
	--i-table ./table_taxa-all-filt.qza \
	--i-taxonomy ./taxonomy80-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./taxa_barplot80-all-filt.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Filter ASVs (seqs) unresolved to at least phylum, also mitochondria and chloroplast:
	qiime taxa filter-seqs \
	--i-sequences dada2_rep_seqs-all.qza \
	--i-taxonomy taxonomy80-all.qza \
	--p-include p__ \
	--p-exclude mitochondria,chloroplast,Unassigned \
	--o-filtered-sequences rep_seqs-all-filt.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Tabulate ASVs after filtering (Visualization):
	qiime metadata tabulate \
	--m-input-file rep_seqs-all-filt.qza \
	--o-visualization rep_seqs-all-filt.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Merge table of taxa and all seqs (Visualization):
	qiime metadata tabulate \
	--m-input-file taxonomy80-all.qza \
	--m-input-file dada2_rep_seqs-all.qza \
	--o-visualization merged-taxa-table-all.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

	#Merge table of taxa and filtered seqs (Visualization):
	qiime metadata tabulate \
	--m-input-file taxonomy80-all.qza \
	--m-input-file rep_seqs-all-filt.qza \
	--o-visualization merged-taxa-table-all-filt.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt
else
	for folder in "${array[@]}"
	do	
		#Taxonomy classification:		
		qiime feature-classifier classify-sklearn \
		--i-classifier classifier.qza \
		--i-reads dada2_rep_seqs-$folder.qza \
		--p-confidence $confidence \
		--o-classification taxonomy80-$folder.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Tabulate taxonomy classification (visualization):
		qiime metadata tabulate \
		--m-input-file taxonomy80-$folder.qza \
		--o-visualization taxonomy80-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Make barplots of taxonomy composition (visualization):
		qiime taxa barplot \
		--i-table ./dada2_table-$folder.qza \
		--i-taxonomy ./taxonomy80-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./taxa_barplot80-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Filter ASVs (table) unresolved to at least phylum, also mitochondria and chloroplast:
		qiime taxa filter-table \
		--i-table dada2_table-$folder.qza \
		--i-taxonomy taxonomy80-$folder.qza \
		--p-include p__ \
		--p-exclude mitochondria,chloroplast,Unassigned \
		--o-filtered-table table_taxa-filt-$folder.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Tabulate summary of overall statistics from filtered ASVs (Visualization):
		qiime feature-table summarize \
		--i-table table_taxa-filt-$folder.qza \
		--m-sample-metadata-file ./metadata-$folder.tsv \
		--o-visualization summary-filt-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Make barplots of taxonomy composition from filtered ASVs (Visualization):
		qiime taxa barplot \
		--i-table ./table_taxa-filt-$folder.qza \
		--i-taxonomy ./taxonomy80-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./taxa_barplot80-filt-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt
		
		#Filter ASVs (seqs) unresolved to at least phylum, also mitochondria and chloroplast:
		qiime taxa filter-seqs \
		--i-sequences dada2_rep_seqs-$folder.qza \
		--i-taxonomy taxonomy80-$folder.qza \
		--p-include p__ \
		--p-exclude mitochondria,chloroplast,Unassigned \
		--o-filtered-sequences rep_seqs-filt-$folder.qza >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Tabulate ASVs after filtering (Visualization):
		qiime metadata tabulate \
		--m-input-file rep_seqs-filt-$folder.qza \
		--o-visualization rep_seqs-filt-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Merge table of taxa and all seqs (Visualization):
		qiime metadata tabulate \
		--m-input-file taxonomy80-$folder.qza \
		--m-input-file dada2_rep_seqs-$folder.qza \
		--o-visualization merged-taxa-table-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt

		#Merge table of taxa and filtered seqs (Visualization):
		qiime metadata tabulate \
		--m-input-file taxonomy80-$folder.qza \
		--m-input-file rep_seqs-filt-$folder.qza \
		--o-visualization merged-taxa-table-filt-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt
	done
fi

echo "The taxonomy step has finished"


#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


#-----QIIME 2 execution:
#-> EXCLUDING SAMPLES <- (optional)

array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 
exclusion=("$@")

echo "Executing the excluding step..."

sed -i "9,$ s/exclusion=/exclusion=( ${exclusion[*]} ) #LAST exclusions: /" q2-diversity.sh

#Exclude samples:
if [[ -e dada2_table-all.qza ]]
then
	qiime feature-table filter-samples \
	--i-table ./dada2_table-all.qza \
	--p-min-frequency 1000 \
	--m-metadata-file metadata-exc.tsv \
	--p-exclude-ids True \
	--o-filtered-table ./table_taxa-exc-all.qza >> info-exclude.txt 2>> error-exclude.txt

	#Tabulate summary of overall statistics without the excluded samples (Visualization):
	qiime feature-table summarize \
	--i-table table_taxa-exc-all.qza \
	--m-sample-metadata-file ./metadata-all.tsv \
	--o-visualization summary-exc-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Make barplots of taxonomy composition without the excluded samples (Visualization):
	qiime taxa barplot \
	--i-table ./table_taxa-exc-all.qza \
	--i-taxonomy ./taxonomy80-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./table_taxa-exc-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Filter ASVs (tables) without the excluded samples:
	qiime taxa filter-table \
	--i-table table_taxa-exc-all.qza \
	--i-taxonomy taxonomy80-all.qza \
	--p-include p__ \
	--p-exclude mitochondria,chloroplast,Unassigned \
	--o-filtered-table table_taxa-exc-filt-all.qza >> info-exclude.txt 2>> error-exclude.txt

	#Tabulate summary of overall statistics after filtering without the excluded samples (Visualization):
	qiime feature-table summarize \
	--i-table table_taxa-exc-filt-all.qza \
	--m-sample-metadata-file ./metadata-all.tsv \
	--o-visualization summary-exc-filt-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Make barplots of taxonomy composition after filtering without the excluded samples (Visualization):
	qiime taxa barplot \
	--i-table ./table_taxa-exc-filt-all.qza \
	--i-taxonomy ./taxonomy80-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./taxa_barplot80-exc-filt-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Exclude samples from sequences:
	qiime feature-table filter-seqs \
	--i-data dada2_rep_seqs-all.qza \
	--m-metadata-file metadata-exc.tsv \
	--p-exclude-ids True \
	--o-filtered-data rep_seqs-exc-all.qza >> info-exclude.txt 2>> error-exclude.txt
		
	#Tabulate ASVs after exclusion (Visualization):
	qiime metadata tabulate \
	--m-input-file rep_seqs-exc-all.qza \
	--o-visualization rep_seqs-exc-all.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt
		
	#Filter ASVS (seqs) after filtering without the excluded samples:
	qiime taxa filter-seqs \
	--i-sequences rep_seqs-exc-all.qza \
	--i-taxonomy taxonomy80-all.qza \
	--p-include p__ \
	--p-exclude mitochondria,chloroplast,Unassigned \
	--o-filtered-sequences rep_seqs-exc-filt-all.qza >> info-exclude.txt 2>> error-exclude.txt

	#Tabulate ASVs after filtering without the excluded samples (Visualization):
	qiime metadata tabulate \
	--m-input-file rep_seqs-exc-filt-all.qza \
	--o-visualization rep_seqs-exc-filt-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Merge table of taxa and seqs without the excluded samples (Visualization):
	qiime metadata tabulate \
	--m-input-file taxonomy80-all.qza \
	--m-input-file rep_seqs-exc-all.qza \
	--o-visualization merged-taxa-table-exc-all.qzv >> info-exclude.txt 2>> error-exclude.txt

	#Merge table of taxa and filtered seqs without the excluded samples (Visualization):
	qiime metadata tabulate \
	--m-input-file taxonomy80-all.qza \
	--m-input-file rep_seqs-exc-filt-all.qza \
	--o-visualization merged-taxa-table-exc-filt-all.qzv >> info-exclude.txt 2>> error-exclude.txt
else
	echo -n "Do you have folders where samples were not excluded? (y/n): "
	read line
	if [[ $line == "y" ]]
	then
		echo "Write the name of such folders (separated by spaces, e.g. folder2 folder4): "
		read line
		sed -i "165,$ s/rest=/rest=( $line ) #LAST folders: /" q2-diversity.sh
		echo "Executing the excluding step..."
	else
		echo "Ok"
		echo "Executing the excluding step..."
		sed -i "165,$ s/rest=/rest=() #LAST folders: /" q2-diversity.sh
	fi	
	for folder in "${exclusion[@]}"
	do
		#Exclude samples from table:
		qiime feature-table filter-samples \
		--i-table ./dada2_table-$folder.qza \
		--p-min-frequency 1000 \
		--m-metadata-file metadata-exc.tsv \
		--p-exclude-ids True \
		--o-filtered-table ./table_taxa-exc-$folder.qza >> info-exclude.txt 2>> error-exclude.txt

		#Tabulate summary of overall statistics without the excluded samples (Visualization):
		qiime feature-table summarize \
		--i-table table_taxa-exc-$folder.qza \
		--m-sample-metadata-file ./metadata-$folder.tsv \
		--o-visualization summary-exc-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Make barplots of taxonomy composition without the excluded samples (Visualization):
		qiime taxa barplot \
		--i-table ./table_taxa-exc-$folder.qza \
		--i-taxonomy ./taxonomy80-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./table_taxa-exc.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Filter ASVs (tables) without the excluded samples:
		qiime taxa filter-table \
		--i-table table_taxa-exc-$folder.qza \
		--i-taxonomy taxonomy80-$folder.qza \
		--p-include p__ \
		--p-exclude mitochondria,chloroplast,Unassigned \
		--o-filtered-table table_taxa-exc-filt-$folder.qza >> info-exclude.txt 2>> error-exclude.txt

		#Tabulate summary of overall statistics after filtering without the excluded samples (Visualization):
		qiime feature-table summarize \
		--i-table table_taxa-exc-filt-$folder.qza \
		--m-sample-metadata-file ./metadata-$folder.tsv \
		--o-visualization summary-exc-filt-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Make barplots of taxonomy composition after filtering without the excluded samples (Visualization):
		qiime taxa barplot \
		--i-table ./table_taxa-exc-filt-$folder.qza \
		--i-taxonomy ./taxonomy80-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./taxa_barplot80-exc-filt-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Exclude samples from sequences:
		qiime feature-table filter-seqs \
		--i-data dada2_rep_seqs-$folder.qza \
		--m-metadata-file metadata-exc.tsv \
		--p-exclude-ids True \
		--o-filtered-data rep_seqs-exc-$folder.qza >> info-exclude.txt 2>> error-exclude.txt
		
		#Tabulate ASVs after filtering (Visualization):
		qiime metadata tabulate \
		--m-input-file rep_seqs-exc-$folder.qza \
		--o-visualization rep_seqs-exc-$folder.qzv >> info-taxonomy.txt 2>> error-taxonomy.txt
		
		#Filter ASVS (seqs) after filtering without the excluded samples:
		qiime taxa filter-seqs \
		--i-sequences rep_seqs-exc-$folder.qza \
		--i-taxonomy taxonomy80-$folder.qza \
		--p-include p__ \
		--p-exclude mitochondria,chloroplast,Unassigned \
		--o-filtered-sequences rep_seqs-exc-filt-$folder.qza >> info-exclude.txt 2>> error-exclude.txt

		#Tabulate ASVs after filtering without the excluded samples (Visualization):
		qiime metadata tabulate \
		--m-input-file rep_seqs-exc-filt-$folder.qza \
		--o-visualization rep_seqs-exc-filt-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Merge table of taxa and seqs without the excluded samples (Visualization):
		qiime metadata tabulate \
		--m-input-file taxonomy80-$folder.qza \
		--m-input-file rep_seqs-exc-$folder.qza \
		--o-visualization merged-taxa-table-exc-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt

		#Merge table of taxa and filtered seqs without the excluded samples (Visualization):
		qiime metadata tabulate \
		--m-input-file taxonomy80-$folder.qza \
		--m-input-file rep_seqs-exc-filt-$folder.qza \
		--o-visualization merged-taxa-table-exc-filt-$folder.qzv >> info-exclude.txt 2>> error-exclude.txt
	done
fi

echo "The excluding step has finished"


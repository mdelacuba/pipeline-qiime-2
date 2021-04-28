#!/bin/bash

##### TAXONOMY COMPOSITION AND DIVERSITY OF BACTERIA AND ARCHAEA WITH QIIME 2 #####

#By: Maria F. Manrique De La Cuba (mmanriquedlc@gmail.com)


array=( carpeta1 carpeta2 ) #LAST FOLDERS: ( carpeta1 carpeta2 ) #LAST FOLDERS: ( folder1 folder2 ) #LAST FOLDERS: 
exclusion=( carpeta1 carpeta2 ) #LAST exclusions: ( carpeta1 ) #LAST exclusions: ( carpeta1 ) #LAST exclusions: ( carpeta1 ) #LAST exclusions: ( carpeta2 ) #LAST exclusions: (  ) #LAST exclusions: (  ) #LAST exclusions: (  ) #LAST exclusions: (  ) #LAST exclusions: (  ) #LAST exclusions: ( folder1 ) #LAST exclusions: (  )
thread=$1
sdepth=$2

echo "Executing the diversity step..."

#Diversity analyses:
if [[ -e rep_seqs-exc-filt-all.qza ]]
then
	#Tabulate number of ASVs per sample:
	qiime diversity alpha \
	--i-table table_taxa-exc-filt-all.qza \
	--p-metric observed_features \
	--o-alpha-diversity ASVs-exc-filt-all.qza >> info-diversity.txt 2>> error-diversity.txt

	#Tabulate number of ASVs per sample (Visualization):
	qiime metadata tabulate \
	--m-input-file ASVs-exc-filt-all.qza \
	--o-visualization ASVs-exc-filt-all.qzv >> info-diversity.txt 2>> error-diversity.txt
	
	#Make a fast phylogeny inference (include mafft alignment, masking alignment and fasttree tree construction):
	qiime phylogeny align-to-tree-mafft-fasttree \
	--i-sequences rep_seqs-exc-filt-all.qza \
	--o-alignment aligned-exc-all.qza \
	--o-masked-alignment masked-aligned-exc-all.qza \
	--o-tree unrooted-tree-exc-all.qza \
	--o-rooted-tree rooted-tree-exc-all.qza \
	--p-n-threads $thread >> info-diversity.txt 2>> error-diversity.txt

	#Plot alpha rarefaction curves (max depth is obtained from "summary-exc-filt.qzv"):
	qiime diversity alpha-rarefaction \
	--i-table ./table_taxa-exc-filt-all.qza \
	--i-phylogeny rooted-tree-exc-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--p-metrics observed_features --p-metrics simpson --p-metrics pielou_e --p-metrics shannon --p-metrics simpson_e --p-metrics dominance \
	--o-visualization ./rarefaction_curves-exc-filt-all.qzv \
	--p-max-depth $sdepth >> info-diversity.txt 2>> error-diversity.txt

	#Generate diversity metrics from only sponges (auto qzv only some):
	qiime diversity core-metrics \
	--i-table table_taxa-exc-filt-all.qza \
	--m-metadata-file metadata-all.tsv \
	--p-sampling-depth $sdepth \
	--output-dir diversity-metrics-exc-all >> info-diversity.txt 2>> error-diversity.txt

	#Generate richness plot (Shannon index) only sponges (Visualization):
	qiime diversity alpha-group-significance \
	--i-alpha-diversity ./diversity-metrics-exc-all/shannon_vector.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./diversity-metrics-exc-all/shannon.qzv >> info-diversity.txt 2>> error-diversity.txt

	#Generate evenness plot (Pielou index) only sponges (Visualization):
	qiime diversity alpha-group-significance \
	--i-alpha-diversity ./diversity-metrics-exc-all/evenness_vector.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./diversity-metrics-exc-all/evenness.qzv >> info-diversity.txt 2>> error-diversity.txt
elif [[ -e rep_seqs-all-filt.qza ]]
then
	#Tabulate number of ASVs per sample:
	qiime diversity alpha \
	--i-table table_taxa-all-filt.qza \
	--p-metric observed_features \
	--o-alpha-diversity ASVs-all-filt.qza >> info-diversity.txt 2>> error-diversity.txt

	#Tabulate number of ASVs per sample (Visualization):
	qiime metadata tabulate \
	--m-input-file ASVs-all-filt.qza \
	--o-visualization ASVs-all-filt.qzv >> info-diversity.txt 2>> error-diversity.txt

	#Make a fast phylogeny inference (include mafft alignment, masking alignment and fasttree tree construction):
	qiime phylogeny align-to-tree-mafft-fasttree \
	--i-sequences rep_seqs-all-filt.qza \
	--o-alignment aligned-all.qza \
	--o-masked-alignment masked-aligned-all.qza \
	--o-tree unrooted-tree-all.qza \
	--o-rooted-tree rooted-tree-all.qza \
	--p-n-threads $thread >> info-diversity.txt 2>> error-diversity.txt

	#Plot alpha rarefaction curves (max depth is obtained from "summary-exc-filt.qzv"):
	qiime diversity alpha-rarefaction \
	--i-table ./table_taxa-all-filt.qza \
	--i-phylogeny rooted-tree-all.qza \
	--m-metadata-file ./metadata-all.tsv \
	--p-metrics observed_features --p-metrics simpson --p-metrics pielou_e --p-metrics shannon --p-metrics simpson_e --p-metrics dominance \
	--o-visualization ./rarefaction_curves-all-filt.qzv \
	--p-max-depth $sdepth >> info-diversity.txt 2>> error-diversity.txt

	#Generate diversity metrics from only sponges (auto qzv only some):
	qiime diversity core-metrics \
	--i-table table_taxa-all-filt.qza \
	--m-metadata-file metadata-all.tsv \
	--p-sampling-depth $sdepth \
	--output-dir diversity-metrics-all >> info-diversity.txt 2>> error-diversity.txt

	#Generate richness plot (Shannon index) only sponges (Visualization):
	qiime diversity alpha-group-significance \
	--i-alpha-diversity ./diversity-metrics-all/shannon_vector.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./diversity-metrics-all/shannon.qzv >> info-diversity.txt 2>> error-diversity.txt

	#Generate evenness plot (Pielou index) only sponges (Visualization):
	qiime diversity alpha-group-significance \
	--i-alpha-diversity ./diversity-metrics-all/evenness_vector.qza \
	--m-metadata-file ./metadata-all.tsv \
	--o-visualization ./diversity-metrics-all/evenness.qzv >> info-diversity.txt 2>> error-diversity.txt

elif [[ -e rep_seqs-exc-filt-${exclusion[@]}.qza ]]
then
	for folder in "${exclusion[@]}"	
	do
		#Tabulate number of ASVs per sample:
		qiime diversity alpha \
		--i-table table_taxa-exc-filt-$folder.qza \
		--p-metric observed_features \
		--o-alpha-diversity ASVs-exc-filt-$folder.qza >> info-diversity.txt 2>> error-diversity.txt

		#Tabulate number of ASVs per sample (Visualization):
		qiime metadata tabulate \
		--m-input-file ASVs-exc-filt-$folder.qza \
		--o-visualization ASVs-exc-filt-$folder.qzv >> info-diversity.txt 2>> error-diversity.txt

		#Make a fast phylogeny inference (include mafft alignment, masking alignment and fasttree tree construction):
		qiime phylogeny align-to-tree-mafft-fasttree \
		--i-sequences rep_seqs-exc-filt-$folder.qza \
		--o-alignment aligned-$folder.qza \
		--o-masked-alignment masked-aligned-$folder.qza \
		--o-tree unrooted-tree-$folder.qza \
		--o-rooted-tree rooted-tree-$folder.qza \
		--p-n-threads $thread >> info-diversity.txt 2>> error-diversity.txt

		#Plot alpha rarefaction curves (max depth is obtained from "summary-exc-filt.qzv"):
		qiime diversity alpha-rarefaction \
		--i-table ./table_taxa-exc-filt-$folder.qza \
		--i-phylogeny rooted-tree-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--p-metrics observed_features --p-metrics simpson --p-metrics pielou_e --p-metrics shannon --p-metrics simpson_e --p-metrics dominance \
		--o-visualization ./rarefaction_curves-exc-filt-$folder.qzv \
		--p-max-depth $sdepth >> info-diversity.txt 2>> error-diversity.txt

		#Generate diversity metrics from only sponges (auto qzv only some):
		qiime diversity core-metrics \
		--i-table table_taxa-exc-filt-$folder.qza \
		--m-metadata-file metadata-$folder.tsv \
		--p-sampling-depth $sdepth \
		--output-dir diversity-metrics-exc-$folder >> info-diversity.txt 2>> error-diversity.txt

		#Generate richness plot (Shannon index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-exc-$folder/shannon_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-exc-$folder/shannon.qzv >> info-diversity.txt 2>> error-diversity.txt

		#Generate evenness plot (Pielou index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-exc-$folder/evenness_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-exc-$folder/evenness.qzv >> info-diversity.txt 2>> error-diversity.txt
	done
	rest=() #LAST folders: () #LAST folders: () #LAST folders: () #LAST folders: ( folder2 ) #LAST folders: ( folder2 ) #LAST folders: ( folder2 ) #LAST folders: ()
	for folder in "${rest[@]}"
	do
		#Tabulate number of ASVs per sample:
		qiime diversity alpha \
		--i-table table_taxa-filt-$folder.qza \
		--p-metric observed_features \
		--o-alpha-diversity ASVs-filt-$folder.qza >> info-diversity.txt 2>> error-diversity.txt

		#Tabulate number of ASVs per sample (Visualization):
		qiime metadata tabulate \
		--m-input-file ASVs-filt-$folder.qza \
		--o-visualization ASVs-filt-$folder.qzv	>> info-diversity.txt 2>> error-diversity.txt

		#Make a fast phylogeny inference (include mafft alignment, masking alignment and fasttree tree construction):
		qiime phylogeny align-to-tree-mafft-fasttree \
		--i-sequences rep_seqs-filt-$folder.qza \
		--o-alignment aligned-$folder.qza \
		--o-masked-alignment masked-aligned-$folder.qza \
		--o-tree unrooted-tree-$folder.qza \
		--o-rooted-tree rooted-tree-$folder.qza \
		--p-n-threads $thread >> info-diversity.txt 2>> error-diversity.txt

		#Plot alpha rarefaction curves (max depth is obtained from "summary-exc-filt.qzv"):
		qiime diversity alpha-rarefaction \
		--i-table ./table_taxa-filt-$folder.qza \
		--i-phylogeny rooted-tree-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--p-metrics observed_features --p-metrics simpson --p-metrics pielou_e --p-metrics shannon --p-metrics simpson_e --p-metrics dominance \
		--o-visualization ./rarefaction_curves-filt-$folder.qzv \
		--p-max-depth $sdepth  >> info-diversity.txt 2>> error-diversity.txt

		#Generate diversity metrics from only sponges (auto qzv only some):
		qiime diversity core-metrics \
		--i-table table_taxa-filt-$folder.qza \
		--m-metadata-file metadata-$folder.tsv \
		--p-sampling-depth $sdepth \
		--output-dir diversity-metrics-$folder >> info-diversity.txt 2>> error-diversity.txt

		#Generate richness plot (Shannon index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-$folder/shannon_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-$folder/shannon.qzv >> info-diversity.txt 2>> error-diversity.txt

		#Generate evenness plot (Pielou index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-$folder/evenness_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-$folder/evenness.qzv >> info-diversity.txt 2>> error-diversity.txt
	done
else
	for folder in "${array[@]}"	
	do
		#Tabulate number of ASVs per sample:
		qiime diversity alpha \
		--i-table table_taxa-filt-$folder.qza \
		--p-metric observed_features \
		--o-alpha-diversity ASVs-filt-$folder.qza >> info-diversity.txt 2>> error-diversity.txt

		#Tabulate number of ASVs per sample (Visualization):
		qiime metadata tabulate \
		--m-input-file ASVs-filt-$folder.qza \
		--o-visualization ASVs-filt-$folder.qzv	>> info-diversity.txt 2>> error-diversity.txt

		#Make a fast phylogeny inference (include mafft alignment, masking alignment and fasttree tree construction):
		qiime phylogeny align-to-tree-mafft-fasttree \
		--i-sequences rep_seqs-filt-$folder.qza \
		--o-alignment aligned-$folder.qza \
		--o-masked-alignment masked-aligned-$folder.qza \
		--o-tree unrooted-tree-$folder.qza \
		--o-rooted-tree rooted-tree-$folder.qza \
		--p-n-threads $thread >> info-diversity.txt 2>> error-diversity.txt

		#Plot alpha rarefaction curves (max depth is obtained from "summary-exc-filt.qzv"):
		qiime diversity alpha-rarefaction \
		--i-table ./table_taxa-filt-$folder.qza \
		--i-phylogeny rooted-tree-$folder.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--p-metrics observed_features --p-metrics simpson --p-metrics pielou_e --p-metrics shannon --p-metrics simpson_e --p-metrics dominance \
		--o-visualization ./rarefaction_curves-filt-$folder.qzv \
		--p-max-depth $sdepth >> info-diversity.txt 2>> error-diversity.txt

		#Generate diversity metrics from only sponges (auto qzv only some):
		qiime diversity core-metrics \
		--i-table table_taxa-filt-$folder.qza \
		--m-metadata-file metadata-$folder.tsv \
		--p-sampling-depth $sdepth \
		--output-dir diversity-metrics-$folder >> info-diversity.txt 2>> error-diversity.txt

		#Generate richness plot (Shannon index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-$folder/shannon_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-$folder/shannon.qzv >> info-diversity.txt 2>> error-diversity.txt

		#Generate evenness plot (Pielou index) only sponges (Visualization):
		qiime diversity alpha-group-significance \
		--i-alpha-diversity ./diversity-metrics-$folder/evenness_vector.qza \
		--m-metadata-file ./metadata-$folder.tsv \
		--o-visualization ./diversity-metrics-$folder/evenness.qzv >> info-diversity.txt 2>> error-diversity.txt
	done
fi

echo "The diversity step has finished"


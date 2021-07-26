# pipeline-qiime-2: Taxonomic and diversity analyses of bacteria and archaea using QIIME 2

QIIME 2 execution-based pipeline to automate usual steps for taxonomic and diversity analyses of 16S rRNA paired-end reads from a single or multiple sequencing runs at once and maintaining parameter customization as required.

This pipeline is based on QIIME 2 version 2020.11 and written in Bash Shell scripts (for Unix or MacOS).

#### Instructions:

This pipeline consists of seven scripts that must be downloaded from the "src" folder.

A taxonomy classifier of Silva v138 515f-806r("classifier.qza" file) must be downloaded from here:
https://drive.google.com/file/d/15hY95a1Kyk-iSbZYHjJPG0eWkDaJBjQH/view?usp=sharing

For pipeline execution, please read and follow the instructions described in "manual.pdf".



-> Input data: Multiplexed V4 16S rRNA paired-end reads (R1, R2, I1 files) and sample metadata table(s).

-> Output data: Default QIIME 2 artifact (.qza) and visualization (.qzv ) files for each step.

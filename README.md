**Tiara_mitogenomics**

This is a [snakemake](https://snakemake.readthedocs.io/en/stable/) workflow called *tiara_mitogenomics* for detection,
and preliminary annotation mitochondrial genomes of Metazoans (Animals) such as Nematodes
in an assembled metagenomic data.

Note!

Before analysis you need to set up conda environment with snakemake installed. 

*Usage*

`` git clone https://github.com/mkarlik93/tiara_mitogenomics``

`` cd tiara_mitogenomics``

`` conda activate snakemake``

Input file, database and minimum length must be specified in config file as full paths - a template of config file you can find in config subfolder and looks like this:

```yaml

run_name: test_run # Name of your run
assembly_path: "metagenomic_assembly.fasta" # A full path to metagenomic assembly
outputdir: 'test_run/' # An output directory

Pipeline_settings :

  mito_pipline : True


General_parameters:

  min_length: 3000 # A minimum length of contigs analyzed by tiara
  temporary_directory: "~/." # Path to temporary directory
  database: "Nematoda_CDS_protein.fa" # A full path to the database

```


When you modified config file (which must be located in config subfolder) you can start your analysis. 

`` snakemake --use-conda --cores n`` , where `n` is the number of cores you want to be used. Remember you must be in tiara_mitogenomics folder.

MT_database can be downloaded from [figshare](https://figshare.com/ndownloader/articles/20552970/versions/1) contains representative proteomes specific for 12 group of Metazoa:

- Annelida-segmented-worms
- Arthropoda
- Bryozoa
- Chaetognatha
- Chordata
- Cnidaria
- Echinodermata
- Mollusca
- Nematoda
- Nemertea-ribbon-worms
- Platyhelminthes-flatworms
- Porifera-sponges

Please unzip datapack and specify path in config file

Also you can find concatenated proteomes from all groups in Animal_CDS_protein.fa

This database was created by developers of [mitoZ](https://github.com/linzhi2013/MitoZ) please, credit their work as well.

*Results*


The main result is a tabular file with a suffix "_tabulated_result.tsv" that contains a names of contigs with counts of mitochondrial genes. 

Name | Length | GC_content | ND2 | ND5 | COX3 | ATP8 | ND6 | ND4L | ND4 | ND3 | ND1 | COX1 | ATP6 | CYTB | COX2 |
|--- | ------ | ---------- | --  | --- | ---- | ---- | --- | ---- | --- | --- | --- | ---- | ---- | ---- | ---- |
Dummy_contig1 | 3072 | 23.14 | 0 |  0  |  1   |  0   | 0   |  0  |  1 |  0  | 0 | 7 | 0  |  1 | 0 |

Also you will find two subdirectories named "tiara_results" and "invidual_contigs_res". First contains native results of tiara analysis, the second one contains DNA and AA sequences originated from mitochondrial contigs with raw mmseqs2 reciprocal analysis.  

*Citation*

Using this package please cite [tiara](https://github.com/ibe-uw/tiara)

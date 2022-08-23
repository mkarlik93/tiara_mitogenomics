**Tiara_mitogenomics**

This is a [snakemake](https://snakemake.readthedocs.io/en/stable/) workflow called tiara_mitogenomics for detection,
and preliminary annotation mitochondrial genomes of Metazoans (Animals) such as Nematodes
in an assembled metagenomic data.

Note!

Before analysis you need to set up conda environment with snakemake installed. 

*Usage*

`` git clone https://github.com/mkarlik93/tiara_mitogenomics``

`` cd tiara_mitogenomics``

`` conda activate snakemake``

Input file and databases must be specified in config file which you can find in config subfolder.

When you modified config file you can  start your analysis. 

`` snakemake --use-conda --cores 12``

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

Please uzip datapack and specify path in config file

Also you can find concatenated proteomes from all groups in Animal_CDS_protein.fa

This database was created by developers of [mitoZ](https://github.com/linzhi2013/MitoZ) please, credit their work as well.



*Citation*

Using this package please cite [tiara](https://github.com/ibe-uw/tiara)

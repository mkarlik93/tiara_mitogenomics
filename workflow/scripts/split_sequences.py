from Bio import SeqIO
from Bio.Seq import Seq
import os
################### Load data from config file #################################

min_length = snakemake.config["General_parameters"]["min_length"]

########### Define a nessecary functions #######################################

INPUT_SEQS = snakemake.config["assembly_path"]
INPUT_AA = snakemake.input[1]
IDS = snakemake.input[0]

contigs_ids = {}

loaded_sequences = list(SeqIO.parse(INPUT_SEQS,"fasta"))


with open(IDS,'r') as infile:

    for line in infile:

        contig_id = line.strip()

        if contig_id not in contigs_ids:

            contigs_ids[contig_id] = []
            contigs_ids[contig_id].append(line.strip())

        else:
            contigs_ids[contig_id].append(line.strip())



##### Spliting contigs into single files -> mitoZ annotate #####################
for seq in loaded_sequences:

    if seq.id in contigs_ids.keys():
        seq_id = seq.id.replace(".","_")

        seq.id = "contigs_1"

        seq.description = ""

        SeqIO.write([seq],f"{seq_id}_contig.fa", "fasta")


loaded_aa_seqs = list(SeqIO.parse(INPUT_AA,"fasta"))


# Spliting ORFs into seperate files -> reciprocal mmseqs
for key in contigs_ids:

    aa_seqs_per_contig = []
    for seq in loaded_aa_seqs:

        seq_name = "_".join(seq.id.split("_")[:-1])

        if seq_name in contigs_ids[key]:
            aa_seqs_per_contig.append(seq)

        SeqIO.write(aa_seqs_per_contig,f"{key}_aa_seqs.fa","fasta")

os.system(f"touch {snakemake.output[0]}")

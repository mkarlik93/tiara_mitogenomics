
############################
import glob
from Bio import SeqIO
from Bio.SeqUtils import GC
import os

############################


# Prepare set of genes from references #

database = snakemake.params["database"][0]
out_flag = snakemake.output["out_flag"]

# Should be formated like gi_NC_014870_COX1_Contracaecum_rudolphii_525_aa #

database = os.path.expanduser(database)

database_genes_names = set([seq.id.split("_")[3] for seq in SeqIO.parse(database,"fasta")])
gathered_results = {}

# Here I need huge descripton to make it preetier
for res in glob.glob("reciprocal*"):
    contig_name = res.replace("reciprocal_","")

    with open(res,"r") as infile:

        for line in infile:
            reciprocal_result = line.split("\t")[1]

            if contig_name not in gathered_results:
                gathered_results[contig_name] = {}

            for i in database_genes_names:
                if i in line:
                        if i not in gathered_results[contig_name]:
                            gathered_results[contig_name][i] = 1

                        else:
                            gathered_results[contig_name][i] = gathered_results[contig_name][i] + 1

                else:
                         if i not in gathered_results[contig_name]:
                             gathered_results[contig_name][i] = 0

                         else:
                             pass

with open(snakemake.output[0],"w") as outfile:
    to_write_lines = []
    formated_lines = []
    for contig in gathered_results:
        #Name Length GC content #Gene1 .. Gene N
        gene_names = "\t".join(gathered_results[contig].keys())
        header = f"Name\tLength\tGC_content\t{gene_names}"

        genomic_fragment_name = contig.replace("_aa_seqs.fa","").replace(".","_")

        genomic_sequence = list(SeqIO.parse(f"{genomic_fragment_name}_contig.fa","fasta"))[0]

        GC_content = round(GC(genomic_sequence.seq),2)
        Length = len(genomic_sequence.seq)

        gene_results = []

        for gene in gathered_results[contig]:

            gene_results.append(str(gathered_results[contig][gene]))

        conc = "\t".join(gene_results)

        line = f"{contig}\t{Length}\t{GC_content}\t{conc}"

        formated_lines.append(line)

    to_write_lines.append(header)

    for line in formated_lines:
        to_write_lines.append(line)

    for line in to_write_lines:

        outfile.write(line+"\n")

os.system(f"touch {out_flag}")

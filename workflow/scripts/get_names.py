



###########################################################


with open(snakemake.output[0],"w") as outfile:

    with open(snakemake.input[0],"r") as infile:

        for line in infile:

            outfile.write("_".join(line.strip().split("_")[:-1])+"\n")

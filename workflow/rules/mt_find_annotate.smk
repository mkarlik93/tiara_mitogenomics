import glob

#To do add probabilites to config file

rule run_tiara:
    """

    The 1th step

    Takes an assembly (prefferably spades with meta flag) and run tiara.

    """
    output:
        "tiara.done"
    params:
        input_path = expand("{input_path}",input_path = get_input()),
        output_name = expand("tiara_out_{run_name}.txt", run_name = get_run_name()),
        min_length = expand("{minlength}", minlength = get_min_length())
    threads:
        10
    conda:
        "tiara-test-env_2"
    shell:
        "tiara -i {params.input_path} -m {params.min_length} -p 0.5 0.5 --probabilities -o {params.output_name} --tf all -t {threads} -v \
         && touch {output}"

rule run_prodigial:
    """

    The 2th step

    Takes mitoG fraction and try to obtain rough ORFs from it.

    Simple calling without consideration of any alternative genetic codes etc.

    """
    input:
        "tiara.done"
    output:
        "{run_name}_mitofraction.faa"
    params:
        in_path = expand("mitochondrion_{assembly_name}",assembly_name = get_assembly_name())
    threads:
        10
    conda:
        "../envs/prodigial.yaml"
    shell:
        "prodigal -i {params.in_path} -p meta -a {output}"

rule mmseq_search:
    """

    The 3th step

    In this step - searching for mitochondrial proteins - specified in the config.

    """
    input:
        "{run_name}_mitofraction.faa"
    output:
        "alignment_{run_name}_tmp.fa"
    threads:
        10
    params:
        tmp_dir = expand("{dir}",dir = get_temporary_directory()),
        database = expand("{dir}",dir = get_database())
    conda:
        "../envs/mmseq.yaml"
    shell:
        "mmseqs easy-search {input} {params.database} {output} {params.tmp_dir}"

rule obtain_list_of_hits:
    """

    The 4th step

    Quick obtain a list of contigs with matches to the database.

    """
    input:
        "alignment_{run_name}_tmp.fa"
    output:
        "list_of_proteins_{run_name}.txt"
    shell:
        "cat {input} | cut -f 1 | sort -u > {output}"


rule get_contig_names:
    """

    The 5th step

    Gathering names of contigs.

    """
    input:
        "list_of_proteins_{run_name}.txt"
    output:
        "list_of_contigs_{run_name}.txt"
    script:
        "../scripts/get_names.py"

rule get_contig_names_uniq:
    """

    The 6th step

    Makes contig names uniqe for further processing.

    """
    input:
        expand("list_of_contigs_{run_name}.txt", run_name = get_run_name())
    output:
        expand("list_of_contigs_{run_name}_r.txt", run_name = get_run_name())
    shell:
        "cat {input} | sort -u > {output}"

rule get_contigs:
    """

    The 7th step

    Here is gonna be a running python script for parsing mmseq result and
    selecting contigs / creating single fasta files.

    """
    input:
        expand("list_of_contigs_{run_name}_r.txt", run_name = get_run_name())
    output:
        expand("mitochondrial_contigs_{run_name}.fa", run_name = get_run_name())
    params:
        input_contigs = expand("{input_path}",input_path = get_input())
    conda:
        "../envs/seqtk.yaml"
    shell:
        "seqtk subseq {params.input_contigs} {input} > {output}"


rule split_file:
    """

    The 8th step

    Creates multiple fasta file two for each mitocontig
    (nucleotide and aminoacid levels).

    """
    input:
        expand("list_of_contigs_{run_name}_r.txt", run_name = get_run_name()),
        expand("{run_name}_mitofraction.faa",run_name = get_run_name())
    output:
        "split_seq.done"
    conda:
        "../envs/python_scripts.yaml"
    script:
        "../scripts/split_sequences.py"

rule run_reciprocal_mmseqs:
    """

    The 9th step

    Here aminoacid sequences
    Just end on this step and let user decide (to think about it).

    """
    input:
        "split_seq.done",
        script=expand("{path}/workflow/scripts/reciprocal.sh", path = PACKAGEDIR)
    output:
        out_flag = "reciprocal.done"
    params:
        #tmp_dir = expand("{dir}",dir = get_temporary_directory()),
        database = expand("{path}", path = get_database())
    threads:
        10
    conda:
        "../envs/mmseq.yaml"
    shell:
        "{input.script} {params.database} {output.out_flag}"

rule tabulate_results:
    """

    The 10th step

    Tabulate obtained results - final output file.

    """
    input:
        "reciprocal.done",
    output:
        expand("{run_name}_tabulated_result.tsv", run_name = get_run_name()),
        out_flag = "gathering.done"
    params:
        database = expand("{path}", path = get_database())
    script:
        "../scripts/aggregate_result.py"

rule cleaning:
    """

    The 11th step

    Cleaning files within output folder.

    """
    input:
        "gathering.done"
    output:
        "cleaning.done"
    shell:
        "rm -r *tmp* && mkdir invidual_contigs_results && mv *_aa_seqs.fa invidual_contigs_results && mv *_contig.fa invidual_contigs_results && mkdir tiara_results && mv *.fasta tiara_results && rm *.txt && touch {output}"

#!/bin/bash


database=$1
outfile=$2


for file in *_aa_seqs.fa;do

  mmseqs easy-rbh $file $database "reciprocal_"$file tmp
  touch $outfile
done

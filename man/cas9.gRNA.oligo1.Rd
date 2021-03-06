% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cas9.gRNA.oligo1.R
\name{cas9.gRNA.oligo1}
\alias{cas9.gRNA.oligo1}
\title{A cas9.gRNA.oligo1 Function}
\usage{
cas9.gRNA.oligo1(inseq, target = NULL)
}
\arguments{
\item{inseq}{'Path/To/Your/Input_sequence_fasta_file'; For example: inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta".}

\item{target}{The host taxonomic group (from species to kingdom) that you think the obtained sgRNA plan to target; If there is space between two word, the sapce should be replace using "_". For example, target="Homo sapiens" need to change to be target="Homo_sapiens".
The target is aiming to obtain target range of your probe (how good it is in helping cleaving the sequence of reference database either within same group or higher taxonomy level).}
}
\description{
This function allows you to design gRNA-target-site oligos for the guding RNA to direct Cas9 nuclease to specifically cut hosts 18S rRNA genes but not of protists and fungi.
}
\details{
If you aim to cut host 18S rRNA genes of V4 region that are generated using 18S primers "TAReuk454FWD1 and TAReukREV3" (Stoeck et al., 2010), please use this cas9.gRNA.oligo1() function as it based on reference database of this region

If you aim to target another region of 18S rRNA gene and amplified by different primer sets, or different different genes, please use cas9.gRNA.oligo2() function by providing your own reference database
}
\examples{
##### If you want to predict the gRNA's target range among a host taxonomic group
cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta", target="Taxonomic_group_of_a_host")

##### If you do NOT want to predict the gRNA's target range among a host taxonomic group
cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta")


###############################################
##### To design sgRNA for your human 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Homo_sapiens" sequences in SILVA.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/human.fasta", target="Homo_sapiens")

##### To design sgRNA for your human 18S (V4 region of 18S rRNA gene), but if you do not want to predict the sgRNA's host-target range among other taxonomic groups.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/human.fasta")

##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Crassostrea_gigas" sequences in SILVA.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Crassostrea_gigas")

##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Ostreidae" sequences in SILVA.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Ostreidae")

##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Mollusca" sequences in SILVA.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Mollusca")

##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene), but if you do not want to predict the sgRNA's host-target range among other taxonomic groups.
cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta")








}
\keyword{cas9.gRNA.oligo1}



# CasOligo
***

CasOligo is a R package to identify the 20nt gRNA-target-site oligonucleotide sequence within the 18S rRNA gene for designing the taxon-specific gRNA, which is used for CRISPR-Cas Selective Amplicon Sequencing (CCSAS, Zhong et al., 2020) to assess the eukaryotic microbiome of hosts (e.g. metazoans, plant). Taxon-specific gRNA allows directing the Cas nuclease to cut specifically the 18S rRNA gene of desired hosts, but not of protists and fungi. This results in a sequencing-library highly enriched in 18S amplicons from microeukayotes, allowing for high-resolution surveys of the taxonomic composition and structure of the eukaryotic microbes associated with the host. CCSAS provides a new and powerful way to obtain high-resolution taxonomic data for the eukaryotic microbiomes of plants, animals and other metazoa. 

To facilitate the application of CCSAS, we identified gRNA-target-sites for almost all metazoan and metaphyta taxa that are currently available at SILVA (Quast et al., 2003), creating a gRNA-taxon-site database for researchers who want to apply to their own organisms for various purposes. Beyond that, the CasOligo package provides an oligonucleotide design function, Cas9.gRNA.oligo2 function, that can be used to design custom gRNA-target-sites for any gene for which the sequence is known and there is a reference database, including genes encoding other regions of 18S rRNA (e.g. 16S, 23S or ITS), or metabolic genes (e.g. COX1). Thus, CCSAS makes it possible to study the genetic diversity of any gene in complex systems, including those that are rare, by removing any sequence that would otherwise dominate the data. The sequence-specific removal of any amplicon has a wide range of applications, including pathogen diagnosis, and studies of symbiosis and microbiome therapy.

&nbsp;
&nbsp;


![](https://github.com/kevinzhongxu/CasOligo/tree/master/inst/extdata/oligo_distribution_among_taxa.png)
**Fig.1** Distribution of the number of sgRNA-target-sites across metazoans and plant taxa for designing taxon-specific and CRISPR-Cas9 compatible gRNA.


&nbsp;
&nbsp;


# Features
***
  * The package allows identifying gRNA-target-site oligonucleotide sequences to design the taxon-specific gRNA, which directs Cas nuclease to cut 18S rRNA gene sequences of the host but not of protists and fungi, as a key role in CRISPR-Cas Selective Amplicon Sequencing (CCSAS) to profile host-associated eukaryotic microbiome.
  
  * The package also allows designing taxon-specific gRNA-target-sites and thereby gRNAs for any gene, includes other regions of the 18S rRNA gene (e.g. 16S, 23S, ITS), other marker genes (COX1), any metabolic genes, etc. 
  
  * In addition to the oligonucleotide design functions, CasOligo also includes a database of gRNA-target-sites for designing CRISPR-Cas9 compatible and taxon-specific gRNAs for almost all available metazoans and plant in SILVA (Quast et al., 2003). These gRNA-target-site oligonucleotide sequences were built for the V4 region of the 18S rRNA gene that could be amplified by the universal 18S primer set, TAReuk454FWD1 and TAReukREV3 (Stoeck et al., 2010). 
  
  * We could retrieve gRNA-target-site oligonucleotide sequences by simply entering the scientific name of the host species (this name is according to nomenclature of SILVA SSU database) or the taxonomic group (from species to kingdom) using search.db.byname function.  
  
  * This package has the oligonucleotide design function for gRNA that is compatible for both CRISPR-Cas9 and CRISPR-Cas12a system. Cas12a uses another set of PAM sequence, which leads to an expansion of the gRNA-target-site oligonucleotides and taxon-specific gRNAs in addition to the CRISPR-Cas9 system.
  
&nbsp;
&nbsp;

# How does the oligonucleotide-designing algorithm works?
***

  * For a given 18S rRNA gene sequence in fasta format, the algorithm searches, at both forward and reverse DNA strand, the 20nt gRNA-target-site oligonucleotides that contain at PAM sequence for the recognition of CRISPR-Cas9 or CRISPR-Cas12a.
  
  * The algorithm predicts for each oligonucleotide the target range of microeukaryotes (protists and fungi). 
  
  * The algorithm also predicts oligonucleotide's target range among those closely related species or those high taxonomic groups of the host species. 
  
  * The prediction of the target range of gRNA-target-site oligonucleotide for host species and microeukaryotes, allows evaluating how good the gRNA could be in cleaving the 18S sequences of closely related host speices or host groups, and how good it is in the absence of cutting those of microeukaryotes.
  
  
&nbsp;
&nbsp;

# Installation
***

To install the latest version from GitHub, simply run the following from an R console:

```r
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("kevinzhongxu/CasOligo")
```

&nbsp;
&nbsp;
&nbsp;

# Dependancy
***
This package depends on the pre-installation of following R package: 

  * Biostrings
  * ape
  * reshape2
  
&nbsp;
&nbsp;


# Citation
***
&nbsp;

If you use CasOligo in a publication, please cite our article in [here](https://www.biorxiv.org/content/10.1101/2020.06.02.130807v1):

  Zhong KX, Cho A, Deeg CM, Chan AM & Suttle CA. (2020) The use of CRISPR-Cas Selective Amplicon Sequencing (CCSAS) to reveal the eukaryotic microbiome of metazoans. xxxx xx(xx): xxxx. https://www.biorxiv.org/content/10.1101/2020.06.02.130807v1

&nbsp;
&nbsp;

# Get start
***
&nbsp;

## Example 1: Design the 20nt gRNA-target-site oligonucleotide 
This is an example to design the 20nt gRNA-target-site oligonucleotide for gRNA of CRISPR-cas9 system to cut the 18S rRNA gene of host, but not of protists and fungi

```r
#If you aim to cut the 18S rRNA gene of the host at V4 region that is flanked by primer set, TAReuk454FWD1 and TAReukREV3 (Stoeck et al., 2010), please use this cas9.gRNA.oligo1 function as it based on the reference database of that region.
cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta", target="Taxonomic_group_of_a_host")


#If you do NOT want to predict the gRNA's target range among a host taxonomic group.
cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta")


#If your input fasta file is with more than one sequence and you want to check the target range of host among these sequences and among these and all related sequences from SILVA.
cas9.gRNA.oligo1m(inseq="Path/To/Your/Input_sequence_fasta_file.fasta", target="Taxonomic_group_of_a_host")
cas9.gRNA.oligo1m(inseq="Path/To/Your/Input_sequence_fasta_file.fasta")


#If you aim to target another region of the 18S rRNA gene that is amplified by different primers, or any other genes, please use cas9.gRNA.oligo2() function and you need to generate your own reference database. 
cas9.gRNA.oligo2(inseq="/home/kevin/Desktop/data/human.fasta", refseq="Path/To/Your/Reference_database_file.fasta", target="Homo_sapiens")
cas9.gRNA.oligo2(inseq="/home/kevin/Desktop/data/human.fasta", refseq="Path/To/Your/Reference_database_file.fasta")

```
&nbsp;



## Example 2: Design the 20nt gRNA-target-site oligonucleotide for 18S sequence of pacific oyster
This is an example to design the 20nt gRNA-target-site oligonucleotide for gRNA of CRISPR-cas9 system to cut the 18S rRNA gene of pacific oyster *Crassostrea gigas*, but not of protists and fungi.

```r

#First, we obtain the link for the 18S sequence of pacific oyster in fasta format (V4 region of the 18S rRNA gene flanked by the primers, TAReuk454FWD1 and TAReukREV3)
input_fasta_file <- system.file("extdata", "pacific_oyster_18S_V4.fasta", package = "CasOligo")

#To design gRNA for the oyster 18S sequence and predict the sgRNA's target-range among other "Crassostrea_gigas" sequences in SILVA.
cas9.gRNA.oligo1(inseq=input_fasta_file, target="Crassostrea_gigas")

#To design gRNA for the oyster 18S sequence and predict the sgRNA's target-range among other "Ostreidae" sequences in SILVA.
cas9.gRNA.oligo1(inseq=input_fasta_file, target="Ostreidae")

#To design gRNA for the oyster 18S sequence and predict the sgRNA's target-range among other "Mollusca" sequences in SILVA.
cas9.gRNA.oligo1(inseq=input_fasta_file, target="Mollusca")

#To design gRNA for the oyster 18S sequence, but if you do not want to predict the sgRNA's target-range among other taxonomic groups.
cas9.gRNA.oligo1(inseq=input_fasta_file)


```
&nbsp;



## Example 3: Retrieve the 20nt gRNA-target-site oligonucleotide sequence from database
We already made a database of gRNA-target-sites (Zhong et al., 2020) for almost all metazoans and plant species that are available in SILVA (Quast et al., 2003). 

If you have an idea on which host taxon to cut and its name, then you can use search.db.byname function to retrieve the oligo. 

```r
#To sucessuffly search a database, the name of taxon should be same as Silva database
search.db.byname(query="Host_species or Host_taxonomic group", cas="Name_of_Cas")

search.db.byname(query="Homo sapiens", cas="Cas9")
search.db.byname(query="Salmon", cas="Cas9")
search.db.byname(query="Mollusca", cas="Cas9")
search.db.byname(query="Crassostrea gigas", cas="Cas9")

search.db.byname(query="Homo sapiens", cas="Cas12a")
search.db.byname(query="Salmon", cas="Cas12a")
search.db.byname(query="Mollusca", cas="Cas12a")
search.db.byname(query="Crassostrea gigas", cas="Cas12a")
  
```

If you want to know the cut detail of of this gRNA-target-site, then you can use search.db.byid function as follows. 

```r
search.db.byid(query="ID_of_the_gRNA-target-site", cas="Name_of_Cas")

search.db.byid(query="probe_022593", cas="Cas9")
  
```

&nbsp;


# References
***

Quast, C. et al. The SILVA ribosomal RNA gene database project: improved data processing and web-based tools. Nucleic Acids Res. 41, D590–D596 (2013).

Stoeck, T. et al. Multiple marker parallel tag environmental DNA sequencing reveals a highly complex eukaryotic community in marine anoxic water. Mol. Ecol. 19, 21–31 (2010).

Zhong KX, Cho A, Deeg CM, Chan AM & Suttle CA. The use of CRISPR-Cas Selective Amplicon Sequencing (CCSAS) to reveal the eukaryotic microbiome of metazoans. xxx xx(xx): xxxx (2020). https://www.biorxiv.org/content/10.1101/2020.06.02.130807v1

&nbsp;

# License
***
&nbsp;

This work is subject to the [MIT License](https://github.com/kevinzhongxu/CasOligo/LICENSE.txt).

&nbsp;
&nbsp;

&nbsp;

<hr />
<p style="text-align: center;">A work by <a href="https://kevinxuzhong.netlify.com/">Kevin Xu ZHONG</a></p>
<p style="text-align: center;"><span style="color: #808080;"><em>xzhong@eoas.ubc.ca</em></span></p>









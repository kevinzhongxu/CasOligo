## cas9.gRNA.oligo1.R
## An automated R script for searching of CRISPR-Cas9 compatible gRNA-target-site oligos based on a input fasta sequence. It would generate a table that lists all possible gRNA-target-site oligos, includes their sequences, target range to micro-eukaryotes and host taxonomic group, and etc.
## Kevin Xu ZHONG, kevinzhong2006@gmail.com; xzhong@eoas.ubc.ca
## depends on R libraries biostrings, reshape2 and ape being installed
## depends on a custom V4 region of 18S rRNA genes flanked by 18S primers "TAReuk454FWD1 and TAReukREV3" (Stoeck et al., 2010) that is prepared from the SILVA 18S SSU V119 99rep database.
## The input fasta needs to be the same V4 region flanked by 18S primers "TAReuk454FWD1 and TAReukREV3" (Stoeck et al., 2010).


#' A cas9.gRNA.oligo1 Function
#'
#' This function allows you to design gRNA-target-site oligos for the guding RNA to direct Cas9 nuclease to specifically cut hosts 18S rRNA genes but not of protists and fungi.
#'
#' If you aim to cut host 18S rRNA genes of V4 region that are generated using 18S primers "TAReuk454FWD1 and TAReukREV3" (Stoeck et al., 2010), please use this cas9.gRNA.oligo1() function as it based on reference database of this region
#'
#' If you aim to target another region of 18S rRNA gene and amplified by different primer sets, or different different genes, please use cas9.gRNA.oligo2() function by providing your own reference database
#'
#' @param inseq 'Path/To/Your/Input_sequence_fasta_file'; For example: inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta".
#'
#' @param target The host taxonomic group (from species to kingdom) that you think the obtained sgRNA plan to target; If there is space between two word, the sapce should be replace using "_". For example, target="Homo sapiens" need to change to be target="Homo_sapiens".
#' The target is aiming to obtain target range of your probe (how good it is in helping cleaving the sequence of reference database either within same group or higher taxonomy level).
#'
#' @keywords cas9.gRNA.oligo1
#' @export
#'
#' @examples
#' ##### If you want to predict the gRNA's target range among a host taxonomic group
#' cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta", target="Taxonomic_group_of_a_host")
#'
#' ##### If you do NOT want to predict the gRNA's target range among a host taxonomic group
#' cas9.gRNA.oligo1(inseq="Path/To/Your/Input_sequence_fasta_file.fasta")
#'
#'
#'###############################################
#' ##### To design sgRNA for your human 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Homo_sapiens" sequences in SILVA.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/human.fasta", target="Homo_sapiens")
#'
#' ##### To design sgRNA for your human 18S (V4 region of 18S rRNA gene), but if you do not want to predict the sgRNA's host-target range among other taxonomic groups.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/human.fasta")
#'
#' ##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Crassostrea_gigas" sequences in SILVA.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Crassostrea_gigas")
#'
#' ##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Ostreidae" sequences in SILVA.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Ostreidae")
#'
#' ##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene) and predict the sgRNA's host-target range among other "Mollusca" sequences in SILVA.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta", target="Mollusca")
#'
#' ##### To design sgRNA for your oyster 18S (V4 region of 18S rRNA gene), but if you do not want to predict the sgRNA's host-target range among other taxonomic groups.
#' cas9.gRNA.oligo1(inseq="/home/kevin/Desktop/data/pacific_oyster_18S_V4.fasta")
#'
#'
#'
#'
#'
#'
#'
#'



cas9.gRNA.oligo1 <- function(inseq, target=NULL) {
  library(ape)
  library(Biostrings)
  library(reshape2)

  inseq <- as.character(inseq)#PATH to the input 18S sequences of V4 region of target host, the output file named after the sequence file


  if(is.null(target)) {
    print("target is empty")
    print("The R is running, please be patient!")

    #myseqs0 <- readDNAStringSet(refseq, "fasta")
    data(silva_v119_18S_99rep_V4)
    #myseqs0 <- readDNAStringSet(system.file("extdata", "silva_v119_18S_99rep_V4.fasta", package = "CasOligo"), "fasta")
    myseqs0 <- silva_v119_18S_99rep_V4

    myseqs0
    length(myseqs0)

    myseqs1 <- myseqs0[!grepl("Metazoa", names(myseqs0))]
    myseqs1 <- myseqs1[!grepl("Embryophyta", names(myseqs1))]

    myseqs1.rc <- reverseComplement(myseqs1)

    myseqs <- c(myseqs1, myseqs1.rc)
    myseqs

    #############input seq ###########################
    sanger <- readDNAStringSet(inseq, "fasta")
    sanger

    sanger.rc <- reverseComplement(sanger)

    ##################search the sgRNA #####################
    myseqs0.D4 <- sanger
    qur1 <- sanger[1]
    oyt1 <- myseqs0.D4[!names(myseqs0.D4)==names(qur1)]
    myseqs0.rc.D4 <- sanger.rc
    qur2 <- sanger.rc[1]
    oyt2 <- myseqs0.rc.D4[!names(myseqs0.rc.D4)==names(qur2)]

    tab <- data.frame(matrix(NA, nrow = width(qur1)[1]-20, ncol = 6))
    colnames(tab) <- c("strand","start", "end", "seq", "pam.seq", "pam")
    tab$strand <- "forward"
    for (j in 1:(width(qur1)[1]-23)) {
      res <- subseq(qur1, start = j, end = 19+j)
      bps <- subseq(qur1, start = 20+j, end = 20+j)
      ps <- subseq(qur1, start = 21+j, end = 22+j)
      if (grepl("GG", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("gg", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("Gg", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("gG", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
    }
    tab <- na.omit(tab)
    tab$id <- tab$start-1

    rctab <- data.frame(matrix(NA, nrow = width(qur1)[1]-20, ncol = 6))
    colnames(rctab) <- c("strand","start", "end", "seq", "pam.seq", "pam")
    rctab$strand <- "reverse"
    for (j in 1:(width(qur2)[1]-23)) {
      res <- subseq(qur2, start = j, end = 19+j)
      bps <- subseq(qur2, start = 20+j, end = 20+j)
      ps <- subseq(qur2, start = 21+j, end = 22+j)
      if (grepl("GG", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("gg", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("Gg", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("gG", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
    }
    rctab <- na.omit(rctab)
    rctab$id <- length(qur2[[1]])-23+1-rctab$start

    #tab$target.nb <- "NA"
    #for (j in 1:nrow(tab)) {
    #  int <- 0
    #  for (i in 1:length(oyt1)){
    #    if (grepl(tab$seq[j], oyt1[[i]]) == TRUE){int <- int+1}
    #  }
    #  tab$target.nb[j] <- int
    #}

    #rctab$target.nb <- "NA"
    #for (j in 1:nrow(rctab)) {
    #  int <- 0
    #  for (i in 1:length(oyt2)){
    #   if (grepl(rctab$seq[j], oyt2[[i]]) == TRUE){int <- int+1}
    #  }
    #  rctab$target.nb[j] <- int
    #}


    for (j in 1:nrow(tab)) {
      int <- 0
      res <- tab$seq[j]
      for (i in 1:length(myseqs)){
        if (grepl(as.character(res), myseqs[[i]]) == TRUE){
          int <- int+1}
      }
      pec <- int/length(myseqs)
      tab$hits[j] <- int
      tab$percentage[j] <- pec
    }

    #tab$target.nb <- as.numeric(tab$target.nb)
    #tab$hits <- as.numeric(tab$hits)
    #tab1 <- subset(tab, tab$target.nb > length(oyt1)-1)
    #tab2 <- subset(tab1, tab1$hits=="0")
    #tab2 <- tab2[order(tab2$percentage), ]

    for (j in 1:nrow(rctab)) {
      int <- 0
      res <- rctab$seq[j]
      for (i in 1:length(myseqs)){
        if (grepl(as.character(res), myseqs[[i]]) == TRUE){
          int <- int+1}
      }
      pec <- int/length(myseqs)
      rctab$hits[j] <- int
      rctab$percentage[j] <- pec
    }
    #rctab$target.nb <- as.numeric(rctab$target.nb)
    #rctab$hits <- as.numeric(rctab$hits)
    #rctab1 <- subset(rctab, rctab$target.nb > length(oyt1)-1)
    #rctab2 <- subset(rctab1, rctab1$hits=="0")
    #rctab2 <- rctab2[order(rctab2$percentage), ]

    meg <- rbind(tab, rctab)
    #meg1 <- rbind(tab1, rctab1)
    #meg2 <- rbind(tab2, rctab2)

    meg$direction <- ifelse(meg$strand=="forward", "Plus", "Minus")
    meg$idt <- paste(meg$direction, meg$id, sep="_")
    meg$class <- target
    #meg$total.host <- length(myseqs0)
    #meg$target.range <- meg$target.nb / meg$total.host
    meg$ref.seq <- as.character(names(qur1))

    ###############
    meg$sgRNA.ID <- meg$idt
    colnames(meg)[colnames(meg)=="seq"] <- "gRNA-target-site-oligo"
    colnames(meg)[colnames(meg)=="idt"] <- "oligo.ID"
    #colnames(meg)[colnames(meg)=="target.nb"] <- "hits.to.host"
    colnames(meg)[colnames(meg)=="hits"] <- "hits.to.microeukaryotes"
    #colnames(meg)[colnames(meg)=="total.host"] <- "total.number.host"
    #colnames(meg)[colnames(meg)=="target.range"] <- "host.target.range"
    colnames(meg)[colnames(meg)=="percentage"] <- "microeukaryotes.target.range"
    colnames(meg)[colnames(meg)=="class"] <- "host.group"

    write.csv(meg, "output_gRNA-target-site-oligo.csv", row.names = F, col.names = TRUE, quote=F)
    write.table(meg, "output_gRNA-target-site-oligo.txt", row.names = F, col.names = TRUE, quote=F, sep="\t")

  }

  else {
    print("target is not empty")
    target <- as.character(target)#targeted species
    print(paste0("target is: ", target))
    print("The R is running, please be patient!")

    #myseqs0 <- readDNAStringSet(refseq, "fasta")
    data(silva_v119_18S_99rep_V4)
    #myseqs0 <- readDNAStringSet(system.file("extdata", "silva_v119_18S_99rep_V4.fasta", package = "CasOligo"), "fasta")
    myseqs0 <- silva_v119_18S_99rep_V4

    myseqs0
    length(myseqs0)

    myseqs1 <- myseqs0[!grepl("Metazoa", names(myseqs0))]
    myseqs1 <- myseqs1[!grepl("Embryophyta", names(myseqs1))]

    myseqs1.rc <- reverseComplement(myseqs1)

    myseqs <- c(myseqs1, myseqs1.rc)
    myseqs

    #######################################
    target <- gsub("_", " ", target)

    myseqs0 <- myseqs0[grepl(target, names(myseqs0))]
    myseqs0
    length(myseqs0)
    names(myseqs0)

    sanger <- readDNAStringSet(inseq, "fasta")
    sanger

    sanger.rc <- reverseComplement(sanger)

    myseqs0 <- c(DNAStringSet(sanger), DNAStringSet(myseqs0))

    myseqs0.rc <- reverseComplement(myseqs0)

    myseqs10 <- c(myseqs0, myseqs0.rc)
    myseqs10

    ##################search the sgRNA #####################
    myseqs0.D4 <- myseqs0
    qur1 <- sanger[1]
    oyt1 <- myseqs0.D4[!names(myseqs0.D4)==names(qur1)]
    myseqs0.rc.D4 <- myseqs0.rc
    qur2 <- sanger.rc[1]
    oyt2 <- myseqs0.rc.D4[!names(myseqs0.rc.D4)==names(qur2)]

    tab <- data.frame(matrix(NA, nrow = width(qur1)[1]-20, ncol = 6))
    colnames(tab) <- c("strand","start", "end", "seq", "pam.seq", "pam")
    tab$strand <- "forward"
    for (j in 1:(width(qur1)[1]-23)) {
      res <- subseq(qur1, start = j, end = 19+j)
      bps <- subseq(qur1, start = 20+j, end = 20+j)
      ps <- subseq(qur1, start = 21+j, end = 22+j)
      if (grepl("GG", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("gg", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("Gg", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
      if (grepl("gG", ps[[1]]) == TRUE)
      {tab$pam[j] <- "yes"
      tab$seq[j] <- as.character(res)
      tab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      tab$start[j] <- j
      tab$end[j] <- j+19
      }
    }
    tab <- na.omit(tab)
    tab$id <- tab$start-1

    rctab <- data.frame(matrix(NA, nrow = width(qur1)[1]-20, ncol = 6))
    colnames(rctab) <- c("strand","start", "end", "seq", "pam.seq", "pam")
    rctab$strand <- "reverse"
    for (j in 1:(width(qur2)[1]-23)) {
      res <- subseq(qur2, start = j, end = 19+j)
      bps <- subseq(qur2, start = 20+j, end = 20+j)
      ps <- subseq(qur2, start = 21+j, end = 22+j)
      if (grepl("GG", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("gg", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("Gg", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
      if (grepl("gG", ps[[1]]) == TRUE)
      {rctab$pam[j] <- "yes"
      rctab$seq[j] <- as.character(res)
      rctab$pam.seq[j] <- paste(as.character(bps), as.character(ps), sep="")
      rctab$start[j] <- j
      rctab$end[j] <- j+19
      }
    }
    rctab <- na.omit(rctab)
    rctab$id <- length(qur2[[1]])-23+1-rctab$start

    tab$target.nb <- "NA"
    for (j in 1:nrow(tab)) {
      int <- 0
      for (i in 1:length(oyt1)){
        if (grepl(tab$seq[j], oyt1[[i]]) == TRUE){int <- int+1}
      }
      tab$target.nb[j] <- int
    }

    rctab$target.nb <- "NA"
    for (j in 1:nrow(rctab)) {
      int <- 0
      for (i in 1:length(oyt2)){
        if (grepl(rctab$seq[j], oyt2[[i]]) == TRUE){int <- int+1}
      }
      rctab$target.nb[j] <- int
    }


    for (j in 1:nrow(tab)) {
      int <- 0
      res <- tab$seq[j]
      for (i in 1:length(myseqs)){
        if (grepl(as.character(res), myseqs[[i]]) == TRUE){
          int <- int+1}
      }
      pec <- int/length(myseqs)
      tab$hits[j] <- int
      tab$percentage[j] <- pec
    }
    tab$target.nb <- as.numeric(tab$target.nb)
    tab$hits <- as.numeric(tab$hits)
    tab1 <- subset(tab, tab$target.nb > length(oyt1)-1)
    tab2 <- subset(tab1, tab1$hits=="0")
    tab2 <- tab2[order(tab2$percentage), ]

    for (j in 1:nrow(rctab)) {
      int <- 0
      res <- rctab$seq[j]
      for (i in 1:length(myseqs)){
        if (grepl(as.character(res), myseqs[[i]]) == TRUE){
          int <- int+1}
      }
      pec <- int/length(myseqs)
      rctab$hits[j] <- int
      rctab$percentage[j] <- pec
    }
    rctab$target.nb <- as.numeric(rctab$target.nb)
    rctab$hits <- as.numeric(rctab$hits)
    rctab1 <- subset(rctab, rctab$target.nb > length(oyt1)-1)
    rctab2 <- subset(rctab1, rctab1$hits=="0")
    rctab2 <- rctab2[order(rctab2$percentage), ]

    meg <- rbind(tab, rctab)
    meg1 <- rbind(tab1, rctab1)
    meg2 <- rbind(tab2, rctab2)

    meg$direction <- ifelse(meg$strand=="forward", "Plus", "Minus")
    meg$idt <- paste(meg$direction, meg$id, sep="_")
    meg$class <- target
    meg$total.host <- length(myseqs0)
    meg$target.range <- meg$target.nb / meg$total.host
    meg$ref.seq <- as.character(names(qur1))

    ###############
    meg$sgRNA.ID <- meg$idt
    colnames(meg)[colnames(meg)=="seq"] <- "gRNA-target-site-oligo"
    colnames(meg)[colnames(meg)=="idt"] <- "oligo.ID"
    colnames(meg)[colnames(meg)=="target.nb"] <- "hits.to.host"
    colnames(meg)[colnames(meg)=="hits"] <- "hits.to.microeukaryotes"
    colnames(meg)[colnames(meg)=="total.host"] <- "total.number.host"
    colnames(meg)[colnames(meg)=="target.range"] <- "host.target.range"
    colnames(meg)[colnames(meg)=="percentage"] <- "microeukaryotes.target.range"
    colnames(meg)[colnames(meg)=="class"] <- "host.group"

    write.csv(meg, "output_gRNA-target-site-oligo.csv", row.names = F, col.names = TRUE, quote=F)
    write.table(meg, "output_gRNA-target-site-oligo.txt", row.names = F, col.names = TRUE, quote=F, sep="\t")

  }
}

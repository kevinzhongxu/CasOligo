#' A search.db.byname Function
#'
#' This function allows you to search the DNA oligo for guding RNA for CRISPR-cas9 and/or CRISPR-Cas12a system with aim to specifically cut 18S rRNA genes sequences of hosts but not protists and fungus. The database is build based on all available taxa in SILVA 18S SSU database version 119 (July 2014)
#'
#' @param query character, the name of host species or taxonomic group (from species to kingdom) that you expect the gRNA to target.
#'
#' @keywords search.db.byname
#' @export
#'
#' @examples
#' search.db.byname(query="Homo sapiens")
#' search.db.byname(query="Salmon")
#' search.db.byname(query="Mollusca")
#' search.db.byname(query="Crassostrea")
#' Please be noted that the name of host species or taxonomic group needs to be a legistimal names appeared in SILVA SSU 18S database.


search.db.byname <- function (query, cas=NULL) {

  library(Biostrings)
  library(reshape2)
  library(ape)

  query <- as.character(query)

  if(is.null(cas)) {
    print("ERROR: please specify the Cas enzyme")
  }

  if(!cas %in% c("cas9", "Cas9", "cas12a", "Cas12a")) {
    print("ERROR: Sorry, we currently haven't the sgRNA-target-site-oligo database for your Cas enzyme")
  }

  if(cas %in% c("cas9", "Cas9")) {

    cas <- as.character(cas)
    data(prb1)
    data(prb2)
    data(prb.score)

    prb1[1:10, ]
    prb2[1:10, ]
    prb.score[1:10, ]

    #prb1 <- read.table(as.character(system.file("extdata", "prb1.txt", package = "CasOligo")), h=T, sep="\t", quote=NULL, comment='', fill=T)
    #prb2 <- read.table(as.character(system.file("extdata", "prb2.txt", package = "CasOligo")), h=T, sep="\t", quote=NULL, comment='', fill=T)
    #data2m.1 <- read.table(as.character(system.file("extdata", "prb.score.txt", package = "CasOligo")), h=T, sep="\t", quote=NULL, comment='', fill=T)

    data2m.1 <- prb.score

    data2m.1a <- data2m.1[, c("probe", "Score")]
    data2m.1am <- aggregate(data2m.1a[,c("Score")],by=list(data2m.1a$probe), mean)
    colnames(data2m.1am) <- c("probe", "Score")

    out1 <- subset(prb2, grepl(query, prb2$Taxon))
    colnames(out1)
    out1.uni <- as.data.frame(unique(out1$seq))
    colnames(out1.uni) <- "probe"

    library(reshape2)
    out1a <- out1[,c("idg", "Taxon")]
    out1a$idg <- as.character(out1a$idg)
    out1a$Taxon <- as.character(out1a$Taxon)
    out1a$count <- 1
    str(out1a)
    out1ad <- dcast(out1a, idg ~ Taxon, value.var='count')
    out1adm <- melt(out1ad, id='idg')
    out1adm$value[is.na(out1adm$value)] <- 0
    out1admd <- dcast(out1adm, idg ~ variable, value.var='value')

    nc <- ncol(out1admd)
    for (i in 1:nrow(out1admd)) {
      out1admd$target.nb[i] <- sum(out1admd[i, 2:nc])
    }
    out1admd$target.range <- 100*out1admd$target.nb / (nc-1)

    out2 <- out1admd[, c("idg", "target.nb", "target.range")]
    out3 <- merge(out1, out2, by.x="idg", by.y="idg")

    out <- merge(out2, prb1, by.x="idg", by.y="idg")
    scr <- merge(out1.uni, data2m.1am, by.x="probe", by.y="probe")
    scr.na <- out1.uni[!out1.uni$probe %in% scr$probe, drop=F, ]
    scr.na$Score <- "NA"
    scr1 <- rbind(scr, scr.na)
    out <- merge(out, scr1, by.x="probe", by.y="probe")
    out <- out[order(out$percent), ]

    out0 <- merge(out, out1ad, by.x="idg", by.y="idg")
    out0 <- out0[order(out0$percent), ]

    ###############
    out0a <- out[, c("idg", "probe", "target.nb", "target.range", "nbr.taxa.design", "hits", "percentage", "Score")]
    out0a$idg <- gsub("probe", "oligo", out0a$idg)
    out0a$sgRNA.ID <- out0a$idg
    out0a$sgRNA.ID <- gsub("oligo", "sgRNA", out0a$sgRNA.ID)
    out0a$target.range <- as.numeric(out0a$target.range)/100

    colnames(out0a)[colnames(out0a)=="probe"] <- "gRNA-target-site-oligo"
    colnames(out0a)[colnames(out0a)=="idg"] <- "oligo.ID"
    colnames(out0a)[colnames(out0a)=="target.nb"] <- "hits.to.host"
    colnames(out0a)[colnames(out0a)=="target.range"] <- "host.target.range"
    colnames(out0a)[colnames(out0a)=="nbr.taxa.design"] <- "nbr.host.taxa.design"
    colnames(out0a)[colnames(out0a)=="hits"] <- "hits.to.microeukaryotes"
    colnames(out0a)[colnames(out0a)=="percentage"] <- "microeukaryotes.target.range"

    write.csv(out0a, paste("out_", cas, "_", query, ".csv", sep=""), row.names = F, col.names = TRUE, quote=F)
    write.table(out0a, paste("out_", cas, "_", query, ".txt", sep=""), row.names = F, col.names = TRUE, quote=F, sep="\t")
  }

  if(cas %in% c("cas12a", "Cas12a")) {
    cas <- as.character(cas)
    print("This is for Cas12a")
  }

}














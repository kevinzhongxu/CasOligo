#' A search.db.byid Function
#'
#' This function allows you to search the target-site oligonucletide sequence of gRNA in the gRNA-targe-site database based on the input ID of the gRNA-target-site.
#'
#' @param query character, the name of gRNA-target-site, such as "probe_022593".
#'
#' @keywords search.db.byid
#' @export
#'
#' @examples
#' search.db.byid(query="probe_022593", cas="Cas9")
#'

search.db.byid <- function (query, cas=NULL) {

  library(Biostrings)
  library(reshape2)
  library(ape)

  query <- as.character(query)

  if(is.null(cas)) {
    print("ERROR: please specify the Cas enzyme")
  }

  if(!cas %in% c("cas9", "Cas9", "cas12a", "Cas12a")) {
    print("ERROR: Sorry, we currently haven't the sgRNA-target-site database for your Cas enzyme")
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

    tmd <- prb1[prb1$idg==query, ]
    out1 <- prb2[prb2$seq %in% tmd$probe, ]
    colnames(out1)
    out0 <- out1[, c("seq", "strand", "start", "end", "pam.seq", "Taxon", 
                     "nbr.taxa.design", "idg", "hits", "percentage")]
    
    out0 <- out1[, c("idg", "seq", "strand", "start", "end", "pam.seq", "hits", "percentage", "Taxon", 
                     "nbr.taxa.design")]

    colnames(out0)[colnames(out0)=="seq"] <- "gRNA-target-sequence-oligo"
    colnames(out0)[colnames(out0)=="idg"] <- "oligo.ID"
    colnames(out0)[colnames(out0)=="Taxon"] <- "host.to.target"
    colnames(out0)[colnames(out0)=="nbr.taxa.design"] <- "nbr.host.taxa.targeted"
    colnames(out0)[colnames(out0)=="hits"] <- "hits.to.microeukaryotes"
    colnames(out0)[colnames(out0)=="percentage"] <- "microeukaryotes.target.range"

    write.csv(out0, paste("out_", cas, "_", query, ".csv", sep=""), row.names = F, col.names = TRUE, quote=F)
    write.table(out0, paste("out_", cas, "_", query, ".txt", sep=""), row.names = F, col.names = TRUE, quote=F, sep="\t")
  }

  if(cas %in% c("cas12a", "Cas12a")) {
    cas <- as.character(cas)
    print("This is for Cas12a")
  }

}














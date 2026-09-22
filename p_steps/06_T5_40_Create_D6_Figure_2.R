#### D6_Figure_1_incident_prevalent_users ----


# authors: Sabrina Giometto


# v 0.1

# 21 Jul 2026


print('CREATE D6_Figure_2')


# assign directories

if (TEST){ 
  testname <- "test_D6_Figure_2"
  thisdirinput <- paste0(file.path(dirtest, testname), "/")
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- direxp
  thisdiroutput <- direxp
}


# load
D5 <- read.csv(paste0(thisdirinput, "D5_Figure_2_distrib_drug_within_first_line.csv"))
D5 <- as.data.table(D5)
assign("D5_Figure_2", D5)


p <- ggplot(D5_Figure_2, aes(x = factor(ASL), y = perc, fill = drug)) +
      geom_col()+
      facet_wrap(~ year_first, nrow = 1)+
      labs(x = NULL, y = "Percentuale di pazienti naive (%)", fill = "Farmaco") +
      scale_fill_manual(
        name = "Farmaco",
        values = c("abira" = "#08306B", "apalu" = "#1C5DA1", 
                   "enzalu" = "#4292C6", "darolu" = "#7FB8DE"),
        labels = c("abira" = "Abiraterone", "apalu" = "Apalutamide", 
                   "enzalu" = "Enzalutamide", "darolu" = "Darolutamide")
      )

# save
png(paste0(thisdiroutput, "/D6_Figure_2.png"), width = 9, height = 5, units = "in", res = 300)

p

dev.off()


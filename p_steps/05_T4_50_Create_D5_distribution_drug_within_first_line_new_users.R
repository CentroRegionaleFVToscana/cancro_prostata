
# authors: Sabrina Giometto


# v 0.1 22 Sep 2026 - Creation of D5 started

print('CREATE D5_Figure_2')

# assign directories

if (TEST){ 
  testname <- "test_D5_Figure_2"
  thisdirinput <- paste0(file.path(dirtest, testname), "/")
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- direxp
}

# load
for (i in drug_names) {
  
  data <- readRDS(file = paste0(thisdirinput, "/D3_coorte_con_caratterizzazione_", i, ".rds"))
  
  data <- as.data.table(data)
  
  assign(paste0("D3_coorte_con_caratterizzazione_", i), data)
  
}

# append cohorts
D3_coorte_all <- rbind(D3_coorte_con_caratterizzazione_abira[user_type=="first" ,],
                       D3_coorte_con_caratterizzazione_apalu[user_type=="first" ,],
                       D3_coorte_con_caratterizzazione_darolu[user_type=="first" ,],
                       D3_coorte_con_caratterizzazione_enzalu[user_type=="first" ,])


tab <- D3_coorte_all[, .N, .(year_first, ASL, drug)]

tab[, perc:=round(N/sum(N),3)*100, .(year_first, ASL)]

assign("D5_Figure_2", tab)


# save
saveRDS(D5_Figure_2, file = paste0(thisdiroutput, "/D5_Figure_2_distrib_drug_within_first_line.rds"))
write.csv(D5_Figure_2, file = paste0(thisdiroutput, "/D5_Figure_2_distrib_drug_within_first_line.csv"))



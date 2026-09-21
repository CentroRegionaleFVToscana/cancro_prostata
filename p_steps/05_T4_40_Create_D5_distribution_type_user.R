
# authors: Sabrina Giometto


# v 0.1 20 Sep 2026 - Creation of D5 started

print('CREATE D5_Figure')

# assign directories

if (TEST){ 
  testname <- "test_D5_Figure_1"
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


for (i in drug_names) {
  
  sel <- get(paste0("D3_coorte_con_caratterizzazione_", i))[, .(user_type, ASL, year_first)]
  
  tab <- sel[, .N, .(year_first, ASL, user_type)]
  tab[, perc:=N/sum(N)*100, .(year_first, ASL)]
  
  assign(paste0("D5_Figure_1_", i), tab)
  
}


# save

for (i in drug_names) {

  saveRDS(get(paste0("D5_Figure_1_", i)), file = paste0(thisdiroutput, "/D5_Figure_1_", i, ".rds") )
  write.csv(get(paste0("D5_Figure_1_", i)), file = paste0(thisdiroutput, "/D5_Figure_1_", i, ".csv"))

}


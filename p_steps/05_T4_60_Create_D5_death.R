# author: Sabrina Giometto

# v 1.0 15 Sep 2026 Creation of D5 started

#########################################

if (TEST){
  testname <- "test_D5_Table_3"
  thisdirinput <- file.path(dirtest,testname)
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



for (j in drug_names) {
  
  # remove prevalent users
  data <- get(paste0("D3_coorte_con_caratterizzazione_", j))[user_type!="prev" ,]
  
  #create period
  data[, period:=fcase(year_first %in% c(2016:2021), "2016-2021",
                             year_first %in% c(2022:2025), "2022-2025",
                             default = NA)]
  
  
  # create D5 with binary covariates
  covariates_binary <- c("death")
  
  D5_cov <- NULL
  
  for (i in covariates_binary) {
    
    tmp <- data[, .(
      N = .N,
      tmp_N = sum(get(i)==1),
      tmp_p = round(sum(get(i)==1)/.N,3)*100),
      .(period, user_type)]
    
    setnames(tmp,"tmp_N",paste0(i, "_N"))
    setnames(tmp,"tmp_p",paste0(i, "_p"))
    
    if (is.null(D5_cov)) {
      
      D5_cov <- tmp
      
    } else {
      
      D5_cov <- merge(D5_cov, tmp, by = c("period", "user_type", "N"))
    }
    
  }
  
  assign(paste0("D5_cov_",j), D5_cov)
  
}

# save
for (j in drug_names) {
  
  saveRDS(get(paste0("D5_cov_", j)), file = paste0(thisdiroutput, "/D5_Table_3_", j, ".rds"))
  write.csv(get(paste0("D5_cov_", j)), file = paste0(thisdiroutput, "/D5_Table_3_", j, ".csv"))
  
}

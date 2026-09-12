# author: Sabrina Giometto

# v 1.0 09 Sep 2026 Creation of D5 started

#########################################

if (TEST){
  testname <- "test_D5_Table_1"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirinput
  thisdiroutput <- dirtemp
}



# # load
# data <- readRDS(file = paste0(thisdirinput, "/D3_coorte_con_caratterizzazione.rds"))
# data <- as.data.table(data)
# 
#   
# 
# # save
# saveRDS(get(paste0("D5_", j)), file = paste0(thisdiroutput, "/D5_", j, ".rds"))
# write.csv(get(paste0("D5_", j)), file = paste0(thisdiroutput, "/D5_", j, ".csv"))



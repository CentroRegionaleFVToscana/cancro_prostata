
# authors: Sabrina Giometto


# v 0.1 09 Sep 2026 - Creation of D5 started


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

# # load
# for (k in drug_names_s) {
#   
#   df <- readRDS(paste0(thisdirinput, "D4_prevalence_incidence_", k, ".rds"))
#   
#   assign(paste0("D4_prevalence_incidence_", k), df)
#   
# }
# 
# 
# # save
# 
# for (i in drug_names_s) {
#   
#   saveRDS(get(paste0("D5_prevalence_incidence_", i)), file = paste0(thisdiroutput, "/D5_Figure_1_prevalence_incidence_", i, ".rds") )
#   write.csv(get(paste0("D5_prevalence_incidence_", i)), file = paste0(thisdiroutput, "/D5_Figure_1_prevalence_incidence_", i, ".csv"))
#   
# }


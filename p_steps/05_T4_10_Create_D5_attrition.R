# author: Sabrina Giometto

# v 0.1 04 Set 2026

# v 0.2 15 Sep 2026 : modified according to having one cohort per study drug

#########################################

if (TEST){
  testname <- "test_D5_Table_S1"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- direxp
}


# load data
# D3_selezione_coorte <- read.csv(file = paste0(thisdirinput, "/D3_selezione_coorte_dummy.csv"), sep = ";")
# D3_selezione_coorte <- readRDS(file = paste0(thisdirinput, "/D3_selezione_coorte.rds"))
# D3_selezione_coorte <- as.data.table(D3_selezione_coorte)

for (i in drug_names) {
  
  data <- readRDS(file = paste0(thisdirinput, "/D3_selezione_coorte_", i, ".rds"))
  
  data <- as.data.table(data)
  
  assign(paste0("D3_selezione_coorte_", i), data)
  
}


# create D5 with binary selection variables

for (j in drug_names) {

  tmp_char <- NULL

  D5 <- NULL
  
  for (i in var_selection) {
    
    if (!i %in% c("is_in_study", "user_type")) {
      
      tmp <- get(paste0("D3_selezione_coorte_", j))[, .(
        N = .N,
        tmp_N = sum(get(i)==0, na.rm = T),
        tmp_p = round(sum(get(i)==0, na.rm = T)/.N,3)*100)]
      
      setnames(tmp,"tmp_N",paste0(i, "_N"))
      setnames(tmp,"tmp_p",paste0(i, "_p"))
      
    } else if (i == "is_in_study") {
      
      tmp <- get(paste0("D3_selezione_coorte_", j))[, .(
        N = .N,
        tmp_N = sum(get(i)==1, na.rm = T),
        tmp_p = round(sum(get(i)==1, na.rm = T)/.N,3)*100)]
      
      setnames(tmp,"tmp_N",paste0(i, "_N"))
      setnames(tmp,"tmp_p",paste0(i, "_p"))
      
    } else if (i == "user_type") {
  
      tmp <- get(paste0("D3_selezione_coorte_", j))[, .(
        N = .N,
        user_type_first_N = sum(is_in_study == 1 & get(i)=="first", na.rm = T),
        user_type_first_p = round(sum(is_in_study == 1 & get(i)=="first", na.rm = T)/sum(is_in_study == 1),3)*100,
        user_type_nofirst_N = sum(is_in_study == 1 & get(i)=="nofirst", na.rm = T),
        user_type_nofirst_p = round(sum(is_in_study == 1 & get(i)=="nofirst", na.rm = T)/sum(is_in_study == 1),3)*100,
        user_type_prev_N = sum(is_in_study == 1 & get(i)=="prev", na.rm = T),
        user_type_prev_p = round(sum(is_in_study == 1 & get(i)=="prev", na.rm = T)/sum(is_in_study == 1),3)*100)]
      
      # setnames(tmp_j,"tmp_N",paste0(j, "_", i, "_N"))
      # setnames(tmp_j,"tmp_p",paste0(j, "_", i, "_p"))
      
      # tmp_char_i <- cbind(tmp_char_i, tmp_j[, -"N"])
      # 
      # tmp <- cbind(tmp_j[, .(N)], tmp_char_i)
      
    } 
    
    if (is.null(D5)) {
      
      D5 <- tmp
      
    } else {
      
      D5 <- merge(D5, tmp)
    }
    
    assign(paste0("D5_attrition_",j), D5)
    
  }
  
} 
  
  
  
# D5_attrition <- D5

# save
for (j in drug_names) {

  saveRDS(get(paste0("D5_attrition_", j)), file = paste0(thisdiroutput, "/D5_Table_S1_attrition_", j, ".rds"))
  write.csv(get(paste0("D5_attrition_", j)), file = paste0(thisdiroutput, "/D5_Table_S1_attrition_", j, ".csv"))
  
}

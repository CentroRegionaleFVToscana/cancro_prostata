# author: Sabrina Giometto

# v 0.1 04 Set 2026

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
D3_selezione_coorte <- readRDS(file = paste0(thisdirinput, "/D3_selezione_coorte.rds"))
D3_selezione_coorte <- as.data.table(D3_selezione_coorte)


# create D5 with binary selection variables

  tmp_char <- NULL

  D5 <- NULL
  
  for (i in var_selection) {
    
    if (!i %in% c("is_in_study", "is_first", "is_nofirst", "is_prevalent", "drug_first")) {
      
      tmp <- D3_selezione_coorte[, .(
        N = .N,
        tmp_N = sum(get(i)==0, na.rm = T),
        tmp_p = round(sum(get(i)==0, na.rm = T)/.N,3)*100)]
      
      setnames(tmp,"tmp_N",paste0(i, "_N"))
      setnames(tmp,"tmp_p",paste0(i, "_p"))
      
    } else if (i == "is_in_study") {
      
      tmp <- D3_selezione_coorte[, .(
        N = .N,
        tmp_N = sum(get(i)==1, na.rm = T),
        tmp_p = round(sum(get(i)==1, na.rm = T)/.N,3)*100)]
      
      setnames(tmp,"tmp_N",paste0(i, "_N"))
      setnames(tmp,"tmp_p",paste0(i, "_p"))
      
    } else if (i %in% c("is_first", "is_nofirst", "is_prevalent")) {
      
      tmp_char_i <- NULL
      
      for (j in drug_names) {
      
      tmp_j <- D3_selezione_coorte[, .(
        N = .N,
        tmp_N = sum(is_in_study == 1 & get(i)==1 & drug_first==j, na.rm = T),
        tmp_p = round(sum(is_in_study == 1 & get(i)==1 & drug_first==j, na.rm = T)/.N,3)*100)]
      
      setnames(tmp_j,"tmp_N",paste0(j, "_", i, "_N"))
      setnames(tmp_j,"tmp_p",paste0(j, "_", i, "_p"))
      
      tmp_char_i <- cbind(tmp_char_i, tmp_j[, -"N"])
      
      }
      
      tmp <- cbind(tmp_j[, .(N)], tmp_char_i)
      
    } else if (i == "drug_first") {
      
      tmp_char_i <- NULL
      
      for (j in drug_names) {
      
        tmp_j <- D3_selezione_coorte[, .(
        N = .N,
        tmp_N = sum(get(i)==j, na.rm = T),
        tmp_p = round(sum(get(i)==j, na.rm = T)/.N,3)*100)]
      
        setnames(tmp_j,"tmp_N",paste0(j, "_", i, "_N"))
        setnames(tmp_j,"tmp_p",paste0(j, "_", i, "_p"))
        
        tmp_char_i <- cbind(tmp_char_i, tmp_j[, -"N"])
      
      }
      
      tmp <- cbind(tmp_j[, .(N)], tmp_char_i)
      
    }
    
    if (is.null(D5)) {
      
      D5 <- tmp
      
    } else {
      
      D5 <- merge(D5, tmp)
    }
    
  }
  
  
D5_attrition <- D5

# save
saveRDS(D5_attrition, file = paste0(thisdiroutput, "/D5_Table_S1_attrition.rds"))
write.csv(D5_attrition, file = paste0(thisdiroutput, "/D5_Table_S1_attrition.csv"))
  


# authors: Sabrina Giometto

# v 0.1

# 04 Set 2026


print('CREATE D6_Table_S1_attrition')

# assign directories

if (TEST){ 
  testname <- "test_D6_Table_S1"
  thisdirinput <- paste0(file.path(dirtest, testname), "/")
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- direxp
}


# load
D5_Table_S1_attrition <- read.csv(paste0(thisdirinput, "D5_Table_S1_attrition.csv"))
D5_Table_S1_attrition <- as.data.table(D5_Table_S1_attrition)


# helpers

add_empty_row <- function(j){
  
  j <- j + 1
  tab_nice[, cell := ""]
  setnames(tab_nice, "cell", paste0("cell_",j))
  return(j)
}

descriptive_N_perc <- function(j, covar) {
  
  j <- j + 1
  varN <- paste0(covar,"N")
  varP <- paste0(covar,"p")
  tab_nice[, cell := paste0(
    formatC(get(varN), format = "f", digits = 0, big.mark = ".", 
            decimal.mark = ","), " (",
    formatC(get(varP), format = "f", digits = 1, big.mark = ".", 
            decimal.mark = ","),"%)"
  )]
  setnames(tab_nice, "cell", paste0("cell_",j))
  return(j)
}

descriptive_median_q1q3 <- function(j, covar) {
  
  j <- j + 1
  varM <- paste0(covar,"_median")
  varQ1 <- paste0(covar,"_q1")
  varQ3 <- paste0(covar,"_q3")
  tab_nice[, cell := paste0(get(varM), " (", get(varQ1), " - ", 
                            get(varQ3), ")")]
  setnames(tab_nice, "cell", paste0("cell_", j))
  return(j)
}


#########################################
# POPULATE ROWS

  tab_nice <- copy(D5_Table_S1_attrition)
  
  # row 0
  row_header_1 <- c()
  j            <- -1
  
  # row 1
  row_header_1 <- c(row_header_1, "Soggetti con almeno un farmaco nella storia e un observation period che overlappa lo study period")
  j <- j + 1
  tab_nice[, cell := as.character(N)]
  setnames(tab_nice, "cell", paste0("cell_", j))
  
  # row 2
  row_header_1 <- c(row_header_1, "Soggetti registrati in anagrafe sanitaria regionale per almeno un giorno tra il 01/01/2016 e il 31/12/2025
                                   con data di nascita e sesso compilati e validi")
  j <- descriptive_N_perc(j, "sel_data_incomplete_")
  
  # # row 3
  # row_header_1 <- c(row_header_1, "Soggetti con un periodo di osservazione")
  # j <- descriptive_N_perc(j, "sel_no_obs_periods_")
  # 
  # # row 4
  # row_header_1 <- c(row_header_1, "Soggetti con un periodo di osservazione coincidente con il periodo di studio")
  # j <- descriptive_N_perc(j, "sel_obs_period_not_overlapped_study_period_")
  
  # row 5
  row_header_1 <- c(row_header_1, "Soggetti di età ≥18 anni alla prima data di dispensazione di uno dei farmaci di interesse durante il periodo di studio (data indice)")
  j <- descriptive_N_perc(j, "sel_no_adults_")
  
  # row 6
  row_header_1 <- c(row_header_1, "Soggetti con almeno 24 mesi di osservazione disponibili prima della data indice")
  j <- descriptive_N_perc(j, "sel_no_lookback_")
  
  # row 7
  row_header_1 <- c(row_header_1, "Soggetti con ASL registrata alla data indice")
  j <- descriptive_N_perc(j, "sel_no_ASL_")
  
  # row 8
  row_header_1 <- c(row_header_1, "Soggetti con almeno una dispensazione di uno dei farmaci di interesse nel periodo di studio")
  j <- descriptive_N_perc(j, "sel_no_drug_during_obs_period_")
  
  # row 9
  row_header_1 <- c(row_header_1, "Totale soggetti inclusi nello studio")
  j <- descriptive_N_perc(j, "is_in_study_")
  
  # row 10
  row_header_1 <- c(row_header_1,
                    "Composizione della coorte in studio")
  
  j <- add_empty_row(j)
  
  # row 11
  row_header_1 <- c(row_header_1, "Abiraterone")
  j <- descriptive_N_perc(j, "abira_drug_first_")
  
  # row 12
  row_header_1 <- c(row_header_1, "1)	Nuovi utilizzatori in prima linea")
  j <- descriptive_N_perc(j, "abira_is_first_") 
  
  # row 13
  row_header_1 <- c(row_header_1, "2)	Nuovi utilizzatori non in prima linea")
  j <- descriptive_N_perc(j, "abira_is_nofirst_")
  
  # row 14
  row_header_1 <- c(row_header_1, "3)	Utilizzatori già in trattamento")
  j <- descriptive_N_perc(j, "abira_is_prevalent_")
  
  # row 11
  row_header_1 <- c(row_header_1, "Apalutamide")
  j <- descriptive_N_perc(j, "apalu_drug_first_")
  
  # row 12
  row_header_1 <- c(row_header_1, "1)	Nuovi utilizzatori in prima linea")
  j <- descriptive_N_perc(j, "apalu_is_first_") 
  
  # row 13
  row_header_1 <- c(row_header_1, "2)	Nuovi utilizzatori non in prima linea")
  j <- descriptive_N_perc(j, "apalu_is_nofirst_")
  
  # row 14
  row_header_1 <- c(row_header_1, "3)	Utilizzatori già in trattamento")
  j <- descriptive_N_perc(j, "apalu_is_prevalent_") 
  
  # row 11
  row_header_1 <- c(row_header_1, "Enzalutamide")
  j <- descriptive_N_perc(j, "enzalu_drug_first_")
  
  # row 12
  row_header_1 <- c(row_header_1, "1)	Nuovi utilizzatori in prima linea")
  j <- descriptive_N_perc(j, "enzalu_is_first_") 
  
  # row 13
  row_header_1 <- c(row_header_1, "2)	Nuovi utilizzatori non in prima linea")
  j <- descriptive_N_perc(j, "enzalu_is_nofirst_")
  
  # row 14
  row_header_1 <- c(row_header_1, "3)	Utilizzatori già in trattamento")
  j <- descriptive_N_perc(j, "enzalu_is_prevalent_")
  
  # row 11
  row_header_1 <- c(row_header_1, "Darolutamide")
  j <- descriptive_N_perc(j, "enzalu_drug_first_")
  
  # row 12
  row_header_1 <- c(row_header_1, "1)	Nuovi utilizzatori in prima linea")
  j <- descriptive_N_perc(j, "darolu_is_first_") 
  
  # row 13
  row_header_1 <- c(row_header_1, "2)	Nuovi utilizzatori non in prima linea")
  j <- descriptive_N_perc(j, "darolu_is_nofirst_")
  
  # row 14
  row_header_1 <- c(row_header_1, "3)	Utilizzatori già in trattamento")
  j <- descriptive_N_perc(j, "darolu_is_prevalent_") 
  
  
  
  #########################################
  # KEEP CELLS
  
  cell_cols <- grep("^cell_", names(tab_nice), value = TRUE)
  tokeep <- c("N", cell_cols)
  tab_nice <- tab_nice[, ..tokeep]
  
  
  #########################################
  # RESHAPE CELLS
  
  # First reshape tab_nice from wide into long format
  
  tab_nice <- melt(
    tab_nice,
    id.vars = "N",
    measure.vars = patterns(
      cell = "^cell_[0-9]+$"
    ),
    variable.name = "rownum"
  )
  
  tab_nice[, rownum := as.integer(rownum)]
  
  # setorder(tab_nice, rownum, period, ASL)
  
  
  # then reshape from long to wide keeping rownum as the UoO
  
  tab_nice <- dcast(
    tab_nice,
    rownum ~ N,
    value.var = "value"
  )
  
  
  # Order rows correctly
  setorder(tab_nice, rownum)
  
  
  #########################################
  # ADD ROW HEADER
  # 
  
  tab_nice[, row_header := row_header_1]
  tab_nice[, rownum := NULL]
  
  #########################################
  # FINAL COLUMNS
  
  data_cols <- setdiff(names(tab_nice), "row_header")
  setcolorder(tab_nice, c("row_header", data_cols))
  
  #########################################
  # NAMES
  
  # newnames <- c(
  #   pre = "Pre- Nota 100 AIFA (1ge2016-25gen2022)",
  #   nota = "Nota 100 AIFA (26gen2022-31lug2025)",
  #   modifica = "Modifica Nota 100 AIFA(1ago2025-31dic2025)"
  # )
  # 
  # 
  # tab_nice[1] <- lapply(tab_nice[1], function(x) {
  #   
  #   idx <- x %in% names(newnames)
  #   x[idx] <- unname(newnames[x[idx]])
  #   x
  #   
  # })
  
  
  
  #########################################
  # SAVE
  
  outputfile <- tab_nice
  nameoutput <- "D6_Table_S1_attrition"
  assign(nameoutput, outputfile)
  
  # rds
  saveRDS(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,".rds")))
  # csv
  fwrite(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,".csv")))
  # xls
  write_xlsx(outputfile, file.path(thisdiroutput, paste0(nameoutput,".xlsx")))
  # html
  html_table <- kable(outputfile, format = "html", escape = FALSE) %>% kable_styling(full_width = F, bootstrap_options = c("striped", "hover"))
  writeLines(html_table, file.path(thisdiroutput, paste0(nameoutput,".html")))
  # rtf
  doc <- read_docx() %>% body_add_table(outputfile, style = "table_template", header = F) %>% body_end_section_continuous()
  print(doc, target = file.path(thisdiroutput, paste0(nameoutput,".docx")))
  
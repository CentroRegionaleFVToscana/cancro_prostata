
#### D6_Table_1 ----


# authors: Sabrina Giometto

# v 0.1 28 Jul 2026 Creation of D6 started
# v 0.2 10 Set 2026 Creation of D6 completed


print('CREATE D6_Table_1')


# assign directories

if (TEST){ 
  testname <- "test_D6_Table_1"
  thisdirinput <- paste0(file.path(dirtest, testname), "/")
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- direxp
  thisdiroutput <- direxp
}


# load

for (j in drug_names) {

  D5 <- read.csv(paste0(thisdirinput, "D5_Table_1_", j, ".csv"))

  D5 <- as.data.table(D5)

  assign(paste0("D5_Table_1_",j), D5)

}




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

for (k in drug_names) {


  tab_nice <- copy(get(paste0("D5_Table_1_", k)))

  # row 0
  row_header_1 <- c()
  j            <- -1

  # row 1
  row_header_1 <- c(row_header_1, "Periodo")
  j <- j + 1
  tab_nice[, cell := period_first]
  setnames(tab_nice, "cell", paste0("cell_", j))

  # row 2
  row_header_1 <- c(row_header_1, "ASL")
  j <- j + 1
  tab_nice[, cell := ASL]
  setnames(tab_nice, "cell", paste0("cell_", j))

  # row 3
  row_header_1 <- c(row_header_1, "Categoria di utilizzatore")
  j <- j + 1
  tab_nice[, cell := user_type]
  setnames(tab_nice, "cell", paste0("cell_", j))

  # row 4
  row_header_1 <- c(row_header_1, "Totale nuovi utilizzatori")
  j <- j + 1
  tab_nice[, cell := as.character(N)]
  setnames(tab_nice, "cell", paste0("cell_", j))

  # row 5-6
  row_header_1 <- c(row_header_1, "Età alla data indice,", "  mediana (Q1 - Q3)")
  j <- add_empty_row(j)
  j <- descriptive_median_q1q3(j, "age")

  # row 7
  row_header_1 <- c(row_header_1, "Genere F registrato alla data indice, n (%)")
  j <- descriptive_N_perc(j, "genere_F_")

  # row 8
  row_header_1 <- c(row_header_1, "Patologie concomitanti")
  j <- add_empty_row(j)

  # row 9
  row_header_1 <- c(row_header_1, "Ipertensione")
  j <- descriptive_N_perc(j, "iperten_")

  # row 10
  row_header_1 <- c(row_header_1, "Cardiopatia ischemica")
  j <- descriptive_N_perc(j, "cardioisc_")

  # row 11
  row_header_1 <- c(row_header_1, "Infarto miocardico")
  j <- descriptive_N_perc(j, "infart_")

  # row 12
  row_header_1 <- c(row_header_1, "Aritmie")
  j <- descriptive_N_perc(j, "arit_")

  # row 13
  row_header_1 <- c(row_header_1, "Angina")
  j <- descriptive_N_perc(j, "angi_")

  # row 14
  row_header_1 <- c(row_header_1, "Ictus ischemico o emorragico")
  j <- descriptive_N_perc(j, "ictus_")

  # row 15
  row_header_1 <- c(row_header_1, "Attacco ischemico transitorio (TIA)")
  j <- descriptive_N_perc(j, "tia_")
  
  # row 16
  row_header_1 <- c(row_header_1, "Scompenso cardiaco")
  j <- descriptive_N_perc(j, "scompcard_")
  
  # row 17
  row_header_1 <- c(row_header_1, "Dislipidemia")
  j <- descriptive_N_perc(j, "dislip_")
  
  # row 18
  row_header_1 <- c(row_header_1, "Diabete mellito")
  j <- descriptive_N_perc(j, "diab_")
  
  # row 19
  row_header_1 <- c(row_header_1, "Insufficienza renale cronica")
  j <- descriptive_N_perc(j, "renal_") 
  
  # row 20
  row_header_1 <- c(row_header_1, "Trattamenti concomitanti, media (DS)")
  j <- descriptive_median_q1q3(j, "conc_treat")
  
  # row 21
  row_header_1 <- c(row_header_1, "Farmaci concomitanti")
  j <- add_empty_row(j)
  
  # row 22
  row_header_1 <- c(row_header_1, "Corticosteroidi")
  j <- descriptive_N_perc(j, "cortic_")
  
  # row 20
  row_header_1 <- c(row_header_1, "Antianginosi")
  j <- descriptive_N_perc(j, "antiang_") 
  
  # row 23
  row_header_1 <- c(row_header_1, "Antitrombotici")
  j <- descriptive_N_perc(j, "antitromb_") 
  
  # row 24
  row_header_1 <- c(row_header_1, "Ipolipemizzanti")
  j <- descriptive_N_perc(j, "ipolip_")
  
  # row 25
  row_header_1 <- c(row_header_1, "Antidiabetici")
  j <- descriptive_N_perc(j, "antidiab_")
  
  # row 26
  row_header_1 <- c(row_header_1, "Bifosfonati")
  j <- descriptive_N_perc(j, "bifosf_")
  
  # row 27
  row_header_1 <- c(row_header_1, "Interruzione trattamento")
  j <- add_empty_row(j)
  
  # row 28
  row_header_1 <- c(row_header_1, "Switch")
  j <- add_empty_row(j)
  
  # row 29
  row_header_1 <- c(row_header_1, "Vs apalutamide")
  j <- descriptive_N_perc(j, "switch_apalu_")
  
  # row 30
  row_header_1 <- c(row_header_1, "Vs enzalutamide")
  j <- descriptive_N_perc(j, "switch_enzalu_")
  
  # row 31
  row_header_1 <- c(row_header_1, "Vs darolutamide")
  j <- descriptive_N_perc(j, "switch_darolu_")
  
  # row 32
  row_header_1 <- c(row_header_1, "Vs altri farmaci oncologici (L01)")
  j <- descriptive_N_perc(j, "switch_other_oncol_")


  #########################################
  # KEEP CELLS

  cell_cols <- grep("^cell_", names(tab_nice), value = TRUE)
  tokeep <- c("period_first", "ASL", "user_type", cell_cols)
  tab_nice <- tab_nice[, ..tokeep]


  #########################################
  # RESHAPE CELLS

  # First reshape tab_nice from wide into long format

  tab_nice <- melt(
    tab_nice,
    id.vars = c("period_first", "ASL", "user_type"),
    measure.vars = patterns(
      cell = "^cell_[0-9]+$"
    ),
    variable.name = "rownum"
  )

  tab_nice[, rownum := as.integer(rownum)]

  setorder(tab_nice, rownum, period_first, ASL, user_type)


  # then reshape from long to wide keeping rownum as the UoO

  tab_nice <- dcast(
    tab_nice,
    rownum ~ period_first + ASL +user_type,
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
  p1_cols   <- grep("^2016_", data_cols, value = TRUE)
  p2_cols   <- grep("^2020_", data_cols, value = TRUE)
  p3_cols <- setdiff(data_cols, c(p1_cols, p2_cols))
  setcolorder(tab_nice, c("row_header", p1_cols, p2_cols, p3_cols))

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
  #  })



  #########################################
  # SAVE

  outputfile <- tab_nice
  nameoutput <- "D6_Table_1"
  assign(nameoutput, outputfile)

  # rds
  saveRDS(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,"_", k,".rds")))
  # csv
  fwrite(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,"_", k,".csv")))
  # xls
  write_xlsx(outputfile, file.path(thisdiroutput, paste0(nameoutput,"_", k,".xlsx")))
  # html
  html_table <- kable(outputfile, format = "html", escape = FALSE) %>% kable_styling(full_width = F, bootstrap_options = c("striped", "hover"))
  writeLines(html_table, file.path(thisdiroutput, paste0(nameoutput,"_", k,".html")))
  # rtf
  doc <- read_docx() %>% body_add_table(outputfile, style = "table_template", header = F) %>% body_end_section_continuous()
  print(doc, target = file.path(thisdiroutput, paste0(nameoutput,"_", k,".docx")))

}

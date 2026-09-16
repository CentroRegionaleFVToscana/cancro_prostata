# author: Rosa Gini

# v 1.0 16 Sep 2026

#########################################

if (TEST){
  testname <- "test_D3_coorte_con_caratterizzazione"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
  thisdrug_names <- c("abira")
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
  thisdrug_names <- drug_names
}

parameters_this_step <- as.data.table(unique(readxl::read_excel(file.path(dirarchive,"codebooks",paste0("D3_coorte_con_caratterizzazione.xlsx")),1)))

component_variables <- unlist(unique(parameters_this_step[parameter == "component",.(value)]))



for (i in c(drug_names, "med_altri_onco")) { 
  
  print(i)
  
  # load data
  
  medicines <- as.data.table(get(load(file.path(thisdirinput, paste0(i,".RData")))[[1]]))
  setnames(medicines, "ID", "person_id")
  
  medicines <- medicines[,.(person_id, DATE)]
  assign(i, medicines)
}

i <- "abira"


for (i in thisdrug_names) {
  
  print(i)
  
  # load data
  
  processing <- readRDS(file.path(thisdirinput, paste0("D3_coorte_", i, ".rds")))

  # age
  
  processing[, age := age_fast(birth_date, date_first)]
  
  # # ageband
  # 
  # processing[, ageband := fcase(
  #   age >= 18 & age <= 44, "18-44",
  #   age >= 45 & age <= 64, "45-64",
  #   age >= 65 & age <= 74, "65-74",
  #   age >= 75, "75+"
  # )
  #            ]
  # 
  # # genere
  # 
  # processing[, genere := gender]
  
  # year_first
  
  processing[, year_first := year(date_first)]
  
  # drug
  
  processing[, drug := i]
  # simple variables and variables that are comonents to more complex variables
    
  component <- "angi"
  for (component in component_variables) {
    processing[, (component) := 0]
    ingredients <- unlist(unique(parameters_this_step[parameter == component,.(value)]))
    for (ingredient in ingredients) {
      temp <- as.data.table(get(load(file.path(thisdirinput, paste0(ingredient,".RData")))[[1]]))
      num <- unlist(unique(parameters_this_step[parameter ==  component & value == ingredient,.(howmany)]))
      winstart <- unlist(unique(parameters_this_step[parameter ==  component & value == ingredient,.(start)]))
      winend <- unlist(unique(parameters_this_step[parameter ==  component & value == ingredient,.(end)]))
      position <- unlist(unique(parameters_this_step[parameter ==  component & value == ingredient,.(position)]))
      setnames(temp, "ID", "person_id")
      temp[, person_id := as.character(person_id)]
      temp <- temp[DATE >= study_start_date - 730,]
      temp <- merge(processing[,.(person_id, date_first)],temp, by = "person_id", all = F)
      temp <- temp[DATE >= date_first + winstart & DATE <= date_first + winend,]
      if (!is.na(position) & position == "first") {
        temp <- temp[ord == 0 | Table_cdm == "ps",]
      }
      temp <- unique(temp[,.(person_id, DATE)])
      temp[, n := rowid(person_id)]
      temp <- temp[n == num,]
      temp[, temp := 1]
      tokeep <- c("person_id", "temp")
      temp <- temp[,..tokeep]
      processing <- merge(processing, temp, by = "person_id", all.x = T)
      processing[is.na(temp), temp := 0]
      processing[, (component) := pmax(get(component), temp)]
      processing[, temp := NULL]
    }
    
  }

  # RENDIS_Alg1
  
  processing[, RENDIS_Alg1 := fifelse(RENDIS_Alg1_1 + RENDIS_Alg1_2 + RENDIS_Alg1_3 == 3 , 1 , 0)]

  # renal
  
  processing[, renal := fifelse(RENDIS_Alg1 + RENDIS_Alg2 >= 1 , 1 , 0)]
  
    # conc_treat
  
  processing[,conc_treat := fifelse(cortic + antiang + antitromb + ipolip + antidiab + bifosf > 0, 1 , 0)]
  
  # CV_fup
  
  processing[,CV_fup := fifelse(infart_fup + cardioisc_fup + ictus_fup + scompcard_fup + angi_fup + arit_fup > 0 , 1 , 0)]
  
  #######################################################
  # variabili farmacoutilizzazione
  
  # discont_12
  # switch_apalu_12
  # switch_enzalu_12
  # switch_darolu_12
  # switch_other_oncol_12
  # discont_24
  # switch_apalu_24
  # switch_enzalu_24
  # switch_darolu_24
  # switch_other_oncol_24
  
  episodes <- readRDS(file.path(thisdirinput, paste0("D3_episodi_farmaci_in_studio_", i, ".rds")))
  processing <- merge(processing, episodes[, .(person_id, episode_end)], by = "person_id")
    
  for (interval in c(12, 24)) {
    processing[, discont := fifelse( !is.na(episode_end)  & episode_end < date_first + interval * 30, 1, 0)]
    for (med in setdiff(c(drug_names, "med_altri_onco"), i)) {
      temp <- merge(get(med), processing[,.(person_id, date_first, episode_end)], by = "person_id", all = F)
      temp <- temp[DATE >= date_first & DATE <= episode_end,]
      processing[, switch := fifelse( discont == 1 & episode_end < date_first + interval * 30, 1, 0)]
      if (med == "med_altri_onco") {
        setnames(processing, "switch", paste0("switch_other_oncol_", interval))
      }else{
        setnames(processing, "switch", paste0("switch_", med, "_", interval))
      }
    }
    
    
    setnames(processing, "discont", paste0("discont_", interval))
    
  }
  
  # restarter

  
  #######################################################
  # variabili farmacoutilizzazione
  
    # death
  # lostfup
  # 
  
  

  # clean and save
  
  # tokeep <- c("person_id", "date_first", "period", "ASL", "age", "ageband", "genere", "met", "antidiabother", "IHD", "AMI", "bypass", "angioplastic", "STROKE", "TIA", "carot", "ateros", "organdamage", "age50plus", "dyslipidemia", "obesity", "hypertension", "smoking", "Cvriskfactors", "RENDIS_Alg1_1", "RENDIS_Alg1_2", "RENDIS_Alg1_3", "RENDIS_Alg1", "RENDIS_Alg2", "CV", "cerebro", "aop", "Cvrisk", "HF", "renal")
  # 
  # processing <- processing[, ..tokeep]

  nameoutputfile <- paste0("D3_coorte_con_caratterizzazione_", i, ".rds")

  saveRDS(processing, file = file.path(thisdiroutput, nameoutputfile))
  

}

# author: Sabrina Giometto

# v 1.0 05 Giu 2026 Creation of D5 started

# v 1.1 24 Giu 2026 Creation of D5 completed

# v 1.2 10 Set 2026 Directories fixed

# v 1.3 15 Set 2026 Changes according to the latest version of the protocol 
#                   (discont e switch 12 e 24 + restarter)

#########################################

if (TEST){
  testname <- "test_D5_Table_1"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- direxp
}


# load data

# if (TEST & type_data_test=="simulation") {
# 
#   data <- readRDS(file = file.path(thisdirinput, "/D3_coorte_con_caratterizzazione.rds"))
# 
# } else if (TEST & type_data_test=="dummy") {
# 
#   data <- read_csv2(file.path(thisdirinput, "D3_coorte_con_caratterizzazione_dummy_data.csv"))
# 
# }

for (i in drug_names) {
  
  data <- readRDS(file = paste0(thisdirinput, "/D3_coorte_con_caratterizzazione_", i, ".rds"))
  
  data <- as.data.table(data)
  
  assign(paste0("D3_coorte_con_caratterizzazione_", i), data)
  
}

# 
# data <- readRDS(file = paste0(thisdirinput, "/D3_coorte_con_caratterizzazione.rds"))
# data <- as.data.table(data)




for (j in drug_names) {
  
  # remove prevalent users
  data <- get(paste0("D3_coorte_con_caratterizzazione_", j))[user_type!="prev" ,]
  
  # create period_first
  data[, period_first:=fcase(year_first %in% c(2016:2019), "2016-2019",
                             year_first %in% c(2020:2022), "2020-2022",
                             year_first %in% c(2023:2025), "2023-2025",
                             default = NA)]

  # Create D5 with sociodemographic characteristics
  D5_nocov <- data[, .(
                N          = .N,
                age_median = median(age),
                age_q1 = quantile(age, probs = 0.25),
                age_q3 = quantile(age, probs = 0.75),
                genere_F_N = sum(gender=="F"),
                genere_F_p = round(sum(gender=="F")/.N,3)*100,
                conc_treat_median = median(conc_treat),
                conc_treat_q1 = quantile(conc_treat, probs = 0.25),
                conc_treat_q3 = quantile(conc_treat, probs = 0.75)),
                .(period_first, ASL, user_type)]

  # create D5 with binary covariates
  covariates_binary <- c("iperten", "cardioisc", "infart", "arit", "angi",
                         "ictus", "tia", "scompcard", "dislip", "diab", "renal",
                         "cortic", "antiang", "antitromb", "ipolip", "antidiab",
                         "bifosf", "switch_apalu_12", "switch_enzalu_12", "switch_darolu_12", 
                         "switch_other_oncol_12", "discont_12", "discont_24",
                         "switch_apalu_24", "switch_enzalu_24", "switch_darolu_24", 
                         "switch_other_oncol_24", "restarter")

  D5_cov <- NULL

  for (i in covariates_binary) {

    tmp <- data[, .(
                N = .N,
                tmp_N = sum(get(i)==1),
                tmp_p = round(sum(get(i)==1)/.N,3)*100),
                .(period_first, ASL, user_type)]

    setnames(tmp,"tmp_N",paste0(i, "_N"))
    setnames(tmp,"tmp_p",paste0(i, "_p"))

    if (is.null(D5_cov)) {

      D5_cov <- tmp

    } else {

      D5_cov <- merge(D5_cov, tmp, by = c("period_first", "ASL", "user_type", "N"))
    }

  }

  # create the final D5 by merging the previous two
  D5 <- merge(D5_nocov, D5_cov, by = c("period_first", "ASL", "user_type","N"), all = F)

  assign(paste0("D5_",j), D5)

}

for (j in drug_names) {

  saveRDS(get(paste0("D5_", j)), file = paste0(thisdiroutput, "/D5_Table_1_", j, ".rds"))
  write.csv(get(paste0("D5_", j)), file = paste0(thisdiroutput, "/D5_Table_1_", j, ".csv"))

  # # save
  # if (TEST & type_data_test=="simulation") {
  #
  #   saveRDS(D5, file = paste0(thisdiroutput, "/D5_from_simulation_", j, ".rds"))
  #   write.csv(D5, file = paste0(thisdiroutput, "/D5_from_simulation_", j, ".csv"))
  #
  # } else if (TEST & type_data_test=="dummy") {
  #
  #   saveRDS(D5, file = paste0(thisdiroutput, "/D5_from_dummy_data_", j,".rds"))
  #   write.csv(D5, file = paste0(thisdiroutput, "/D5_from_dummy_data_", j,".csv"))
  #
  # }

}

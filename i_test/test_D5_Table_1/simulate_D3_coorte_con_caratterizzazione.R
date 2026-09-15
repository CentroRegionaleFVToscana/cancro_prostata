rm(list=ls(all.names=TRUE))

#set the directory where the script is saved as the working directory

if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# load packages

if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("truncnorm")) install.packages("truncnorm")
library(truncnorm)



for (k in drug_names) {

  # name of the dataset to be generated
  namedataset <- "D3_coorte_con_caratterizzazione"
  
  # set number of persons
  Npersons <- 5000
  # create base 
  data <- data.table::data.table(person_id = 1:Npersons)
  # person_id 
  data[, person_id := paste0("000000",as.character(seq_len(.N)))]
  data[, person_id := paste0("P",substr(person_id, nchar(person_id) - 6, 
                                        nchar(person_id)))]
  
  # date first
  start_date <- as.Date("2016-01-01")
  end_date   <- as.Date("2025-12-31")
  
  data[, date_first := sample(seq(start_date, end_date, by = "day"),
                              .N, replace = TRUE)]
  
  # year first
  data[, year_first:=sample(c(2016:2025), Npersons, replace = TRUE)]
  
  # # period first
  # data[, period_first:=ifelse((year(date_first) >= 2016 & year(date_first) <= 2019),
  #                             "2016-2019",
  #                       ifelse((year(date_first) >= 2020 & year(date_first) <= 2022),
  #                              "2020-2022",
  #                       ifelse((year(date_first) >= 2023 & year(date_first) <= 2025),
  #                              "2023-2025", NA)))]
  # drug
  data[, drug:=k]
  
  # user type
  data[, user_type:=sample(c("first", "nofirst", "prev"), Npersons, replace = TRUE, 
                     prob = c(rep(0.33, 3)))]
  
  # ASL
  data[, ASL:=sample(c("CE", "NO", "SE"), Npersons, replace = TRUE, 
                     prob = c(rep(0.33, 3)))]
  
  # gender
  set.seed(1234)
  data[, gender := as.character(sample(1:2, Npersons, replace = TRUE, 
                                       prob = c(.5,.5)))]
  data[, gender := ifelse(gender == "1","M","F")]
  # eta
  data[, age := round(rtruncnorm(Npersons, a = 18, b = Inf, mean = 50, sd = 15),0)]
  
  # covariates at t0 and at fup: binary
  covariates_binary <- c("iperten", "cardioisc", "infart", "arit", "angi","ictus", "tia",
                          "scompcard", "dislip", "diab", "renal", "cortic", 
                          "antiang", "antitromb", "ipolip", "antidiab", "bifosf",
                          "switch_apalu_12", "switch_enzalu_12", "switch_darolu_12", 
                          "switch_other_oncol_12", "discont_12", "discont_24",
                          "switch_apalu_24", "switch_enzalu_24", "switch_darolu_24", 
                          "switch_other_oncol_24", "restarter", "death", "lostfup",
                          "infart_fup", "cardioisc_fup", "ictus_fup", 
                          "scompcard_fup", "angi_fup", "arit_fup", "CV_fup",
                          "renal_fup", "epa_fup", "fratt_fup")
  
  for (i in covariates_binary) {
  
    cov <- seq(0,1)
    probcov = runif(1, min = 0, max = 1)
    totprob = sum(probcov)
    probcov = c(probcov, 1 - totprob)
    data[, cov := sample(cov, Npersons, replace = TRUE, prob = probcov)]
    setnames(data,"cov",i)
  }
  
  # save
  saveRDS(data, file = paste0(thisdir, "/", namedataset, "_", k, ".rds"))

}

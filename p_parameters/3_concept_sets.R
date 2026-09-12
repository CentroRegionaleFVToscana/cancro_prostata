###################################################################
# DESCRIBE THE CONCEPT SETS
###################################################################
concept_sets_of_our_study_drugs <- c("abira","apalu","enzalu", "darolu", "med_iperten", "med_cardioisc_angi", "med_dislip", "med_diab", "med_RENDIS_Alg1_1", "med_RENDIS_Alg1_2", "med_RENDIS_Alg1_3", "med_RENDIS_Alg2", "med_cortic",  "med_antitromb",  "med_bifos")

concept_sets_of_our_study_diagnosis <- c("dia_iperten","dia_cardioisc","dia_angi","dia_dislip","dia_diab","dia_renal", "dia_ictus", "dia_infart", "dia_arit", "dia_tia", "dia_scompcard", "dia_renal_fup", "dia_epa_fup", "dia_fratt_fup")

drug_names <- c("abira", "apalu", "enzalu", "darolu")

# names of the concept sets

name_codelist <- list()

name_codelist[["abira"]] = "Abiraterone"
name_codelist[["apalu"]] = "Apalutamide"
name_codelist[["enzalu"]] = "Enzalutamide"
name_codelist[["darolu"]] = "Darolutamide"


name_codelist[["med_iperten"]] <- "Medicines contributing to the algorithm on iperten (Table B of the protocol)"
name_codelist[["med_cardioisc_angi"]] <- "Medicines contributing to the algorithm on cardioisc and to the algorithm on angi (Table B of the protocol)"
name_codelist[["med_dislip"]] <- "Medicines contributing to the algorithm on dislip (Table B of the protocol)"
name_codelist[["med_diab"]] <- "Medicines contributing to the algorithm on diab (Table B of the protocol)"
name_codelist[["med_RENDIS_Alg1_1"]] <- "Medicines of type DRUG1 contributing to the algorithm 1 on renal (Table B of the protocol), group 1"
name_codelist[["med_RENDIS_Alg1_2"]] <- "Medicines of type DRUG1 contributing to the algorithm 1 on renal (Table B of the protocol), group 2"
name_codelist[["med_RENDIS_Alg1_3"]] <- "Medicines of type DRUG1 contributing to the algorithm 1 on renal (Table B of the protocol), group 3"
name_codelist[["med_RENDIS_Alg2"]] <- "Medicines of type DRUG2 contributing to the algorithm 2 on renal (Table B of the protocol)"
name_codelist[["med_bifos"]] <- ""
name_codelist[["med_cortic"]] <- ""
name_codelist[["med_antitromb"]] <- ""
name_codelist[["med_dislip"]] <- ""





name_codelist[["dia_iperten"]] <- "Diagnoses contributing to the algorithm on iperten (Table B of the protocol)"
name_codelist[["dia_cardioisc"]] <- "Diagnoses contributing to the algorithm on cardioisc (Table B of the protocol)"
name_codelist[["dia_angi"]] <- "Diagnoses contributing to the algorithm on angi (Table B of the protocol)"
name_codelist[["dia_dislip"]] <- "Diagnoses contributing to the algorithm on dislip (Table B of the protocol)"
name_codelist[["dia_diab"]] <- "Diagnoses contributing to the algorithm on diab (Table B of the protocol)"
name_codelist[["dia_renal"]] <- "Diagnoses contributing to the algorithm on renal (Table B of the protocol)"
name_codelist[["dia_ictus"]] <- "Diagnoses contributing to the algorithm on ictus (Table B of the protocol)"
name_codelist[["dia_infart"]] <- "Diagnoses contributing to the algorithm on infart (Table B of the protocol)"
name_codelist[["dia_arit"]] <- "Diagnoses contributing to the algorithm on artitmie (Table B of the protocol)"
name_codelist[["dia_tia"]] <- "Diagnoses contributing to the algorithm on artitmie e arit_fup(Table B of the protocol)"
name_codelist[["dia_scompcard"]] <- "Diagnoses contributing to the algorithm on scompcard e scompcard_fup (Table B of the protocol)"
name_codelist[["dia_renal_fup"]] <- ""
name_codelist[["dia_epa_fup"]] <- ""
name_codelist[["dia_fratt_fup"]] <- ""


# -concept_set_domains- is a 2-level list encoding for each concept set the corresponding data domain

concept_set_domains <- vector(mode="list")

for (concept_id in concept_sets_of_our_study_drugs) {
  concept_set_domains[[concept_id]] = "Medicines"
}

for (concept_id in concept_sets_of_our_study_diagnosis) {
  concept_set_domains[[concept_id]]="Diagnosis"
}


# -concept_set_codes_our_study- is a nested list, with 3 levels: foreach concept set, for each coding system of its data domain, the list of codes is recorded

concept_set_codes_our_study <- vector(mode="list")
concept_set_codes_our_study_excl <- vector(mode="list")

concept_set_codes_our_study[["abira"]][["ATC"]] = c("L02BX03")
concept_set_codes_our_study[["apalu"]][["ATC"]] = c("L02BB05")
concept_set_codes_our_study[["enzalu"]][["ATC"]] = c("L02BB04")
concept_set_codes_our_study[["darolu"]][["ATC"]] = c("L02BB06")


concept_set_codes_our_study[["med_iperten"]][["ATC"]] <- c("C09", "C02", "C07", "C08C")
concept_set_codes_our_study[["med_cardioisc_angi"]][["ATC"]] <- "C01DA"
concept_set_codes_our_study[["med_dislip"]][["ATC"]] <- "C10"
concept_set_codes_our_study[["med_diab"]][["ATC"]] <- "A10"
concept_set_codes_our_study[["med_RENDIS_Alg1_1"]][["ATC"]] <- c("C09C")
concept_set_codes_our_study[["med_RENDIS_Alg1_2"]][["ATC"]] <- c("C09B")
concept_set_codes_our_study[["med_RENDIS_Alg1_3"]][["ATC"]] <- c("M04AA01")
concept_set_codes_our_study[["med_RENDIS_Alg2"]][["ATC"]] <- c("B03XA01", "V03AE03", "V03AE02", "V03AE01", "H05BX02", "B03XA02", "H05BX01")
concept_set_codes_our_study[["med_bifos"]][["ATC"]] <- c("M05BA", "M05BB")
concept_set_codes_our_study[["med_cortic"]][["ATC"]] <- c("H02AB","H02B")
concept_set_codes_our_study[["med_antitromb"]][["ATC"]] <- c("B01A")



concept_set_codes_our_study[["dia_iperten"]][["ICD9"]] <- c("401", "402", "403", "404", "405", "36211")
concept_set_codes_our_study[["dia_cardioisc"]][["ICD9"]] <- c("410", "414")
concept_set_codes_our_study[["dia_angi"]][["ICD9"]] <- c("413")
concept_set_codes_our_study[["dia_dislip"]][["ICD9"]] <- c("2720", "2721", "2723", "2724")
concept_set_codes_our_study[["dia_diab"]][["ICD9"]] <- c("250")
concept_set_codes_our_study[["dia_renal"]][["ICD9"]] <- c("5820", "5821", "5822", "5823", "5824", "5825", "5826", "5827", "5828", "5829", "581", "7531", "59000", "59001", "5890", "585", "586")
concept_set_codes_our_study[["dia_ictus"]][["ICD9"]] <- c("430", "431", "432", "434", "436")
concept_set_codes_our_study[["dia_infart"]][["ICD9"]] <- c("410")
concept_set_codes_our_study[["dia_arit"]][["ICD9"]] <- c("427")
concept_set_codes_our_study[["dia_tia"]][["ICD9"]] <- c("435")
concept_set_codes_our_study[["dia_scompcard"]][["ICD9"]] <- c("428", "3981", "40201", "40211", "40291", "40401", "40403", "40411", "40413", "40491", "40493")
concept_set_codes_our_study[["dia_renal_fup"]][["ICD9"]] <- c("580", "584")
concept_set_codes_our_study[["dia_epa_fup"]][["ICD9"]] <- c("570", "5722","5724")
concept_set_codes_our_study[["dia_fratt_fup"]][["ICD9"]] <- c("80", "81", "82", "7331")

###################################################################
# DESCRIBE THE CONCEPT SETS
###################################################################
concept_sets_of_our_study_drugs <- c("abira","apalu","enzalu", "darolu", "med_iperten", "med_cardioisc", "med_angi", "med_dislip", "med_diab", "med_renal")

concept_sets_of_our_study_diagnosis <- c("dia_iperten","dia_cardioisc","dia_angi","dia_dislip","dia_diab","dia_renal")

drug_names <- c("abira", "apalu", "enzalu", "darolu")

# names of the concept sets

name_codelist <- list()

name_codelist[["abira"]] = "Abiraterone"
name_codelist[["apalu"]] = "Apalutamide"
name_codelist[["enzalu"]] = "Enzalutamide"
name_codelist[["darolu"]] = "Darolutamide"


name_codelist[["med_iperten"]] <- "Medicines contributing to the algorithm on iperten (Table B of the protocol)"
name_codelist[["med_cardioisc"]] <- "Medicines contributing to the algorithm on cardioisc (Table B of the protocol)"
name_codelist[["med_angi"]] <- "Medicines contributing to the algorithm on angi (Table B of the protocol)"
name_codelist[["med_dislip"]] <- "Medicines contributing to the algorithm on dislip (Table B of the protocol)"
name_codelist[["med_diab"]] <- "Medicines contributing to the algorithm on diab (Table B of the protocol)"
name_codelist[["med_renal"]] <- "Medicines contributing to the algorithm on renal (Table B of the protocol)"

name_codelist[["dia_iperten"]] <- "Diagnoses contributing to the algorithm on iperten (Table B of the protocol)"
name_codelist[["dia_cardioisc"]] <- "Diagnoses contributing to the algorithm on cardioisc (Table B of the protocol)"
name_codelist[["dia_angi"]] <- "Diagnoses contributing to the algorithm on angi (Table B of the protocol)"
name_codelist[["dia_dislip"]] <- "Diagnoses contributing to the algorithm on dislip (Table B of the protocol)"
name_codelist[["dia_diab"]] <- "Diagnoses contributing to the algorithm on diab (Table B of the protocol)"
name_codelist[["dia_renal"]] <- "Diagnoses contributing to the algorithm on renal (Table B of the protocol)"

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



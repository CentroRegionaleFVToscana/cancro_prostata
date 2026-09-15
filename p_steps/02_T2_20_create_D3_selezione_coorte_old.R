# author: Rosa Gini

# v 1.0 14 Sep 2026

#########################################

if (TEST){
  testname <- "test_D3_selezione_coorte"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(dirtest,testname,"g_output")
  dir.create(thisdiroutput, showWarnings = F)
  thisdrug_names <- drug_names
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
  thisdrug_names <- drug_names
}




# load data

pers_medicines <- data.table()
medicines  <- data.table()
medicines[, drug := NA_character_]
for (i in drug_names) {
  medicine <- as.data.table(get(load(file.path(thisdirinput, paste0(i,".RData")))[[1]]))
  setnames(medicine, "ID", "person_id")
  medicine <- medicine[,.(person_id, DATE)]
  assign( i, medicine)
  pers_medicines <- unique(rbind(pers_medicines, medicine[,.(person_id)]), fill = T)
  medicines <- unique(rbind(medicines, medicine, fill = T))[]
  medicines[is.na(drug), drug := i]
}
medicines <- medicines[!is.na(person_id) & !is.na(DATE),]

obsperiods <- readRDS(file = file.path(thisdirinput, "D3_OBSPERIODS.rds"))

asl <- readRDS(file = file.path(thisdirinput, "D3_ASL.rds"))

persons <- readRDS(file = file.path(thisdirinput, "D3_PERSONS.rds"))

################################
# start processing

processing <- persons


############################
# selection variables

processing[, sel := 0]

# sel_data_incomplete

thissel <- "sel_data_incomplete"

processing[ , (thissel) := fifelse( sel == 1 | birth_date_or_gender_invalid == 1, 1, 0) ]

processing[ , sel := fifelse(get(thissel) == 1 , 1, 0) ]

# sel_no_obs_periods, sel_obs_period_not_overlapped_study_period, sel_never18plus_during_study_period

obsenriched <- merge(processing, obsperiods, by = "person_id", all.x = T)

obsenriched[, date_18th_birthday := birth_date %m+% years(18)]

thissel <- "sel_no_obs_periods"

temp <- unique(obsenriched[is.na(start_op),.(person_id)])

temp[, (thissel) := 1]

processing <- merge(processing, temp, by = "person_id", all.x = T)

processing[ , (thissel) := fifelse( sel == 1 | get(thissel) == 1, 1, 0, 0) ]

processing[ , sel := fifelse(sel == 1 |get(thissel) == 1 , 1, 0) ]

thissel <- "sel_obs_period_not_overlapped_study_period"

temp <- unique(obsenriched[start_op <= study_end_date & end_op >= study_start_date,.(person_id)])

temp[, (thissel) := 0]

processing <- merge(processing, temp, by = "person_id", all.x = T)

processing[ , (thissel) := fifelse( sel == 1 | is.na(get(thissel)), 1, 0) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]

# sel_no_drug

thissel <- "sel_no_drug"

medenriched <- merge(processing[sel == 0,], pers_medicines, by = "person_id", all = F)

temp <- unique(medenriched[,.(person_id)])

temp[, (thissel) := 0]

processing <- merge(processing, temp, by = "person_id", all.x = T)

processing[ , (thissel) := fifelse( sel == 1 | is.na(get(thissel)), 1, 0) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]
  
# date_first
# drug_first
# duplicate_drug

setorder(medicines, person_id, DATE, drug)
medicines[, ndrug := .N, by = c("person_id", "DATE")]
medicines[, n := rowid(person_id)]
temp <- medicines[n == 1, .(person_id, DATE, drug, ndrug)]
setnames(temp, c("DATE", "drug", "ndrug"), c("date_first", "drug_first", "duplicate_drug"))
processing <- merge(processing, temp, by = "person_id", all.x = T)
processing[, duplicate_drug := fifelse(duplicate_drug > 1, 1, 0)]

# sel_first_drug_not_during_study_period

thissel <- "sel_first_drug_not_during_study_period"

processing[ , (thissel) := fifelse( sel == 1 | date_first < study_start_date | date_first > study_end_date, 1, 0) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]



####################### DA QUI




# start_study_op
# end_study_op


processing[, ref_date := date_first]

processing <- obsperiods[
  processing,
  on = .(
    person_id,
    start_op <= ref_date,
    end_op >= ref_date
  )
]


setorder(temp, person_id, DATE)

temp[, n := rowid(person_id)]

temp <- temp[ n == 1, .(person_id, start_op, end_op, DATE)]

setnames(temp, c("start_op", "end_op", "DATE"), c("start_study_op", "end_study_op", "date_first"))

temp[, (thissel) := 0]

processing <- merge(processing, temp, by = "person_id", all.x = T)

processing[ , (thissel) := fifelse( sel == 1 | is.na(get(thissel)), 1, 0, 1) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]

# sel_no_lookback


thissel <- "sel_no_lookback"

processing[ , (thissel) := fifelse( sel == 1 | (date_first < start_study_op + 730 | date_first > end_study_op | date_first < start_study_op ), 1, 0, 1) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]

# sel_no_ASL

thissel <- "sel_no_ASL"

asl <- merge(asl, processing[sel == 0,.(person_id)], all = F)

processing[, ref_date := date_first]

processing <- asl[
  processing,
  on = .(
    person_id,
    start_d <= ref_date,
    end_d >= ref_date
  )
]

processing[, c("start_d", "end_d") := NULL]

processing[ , (thissel) := fifelse( sel == 1 | is.na(ASL), 1, 0) ]

processing[ , sel := fifelse(sel == 1 | get(thissel) == 1 , 1, 0) ]


####################
# final variables


# is_in_study

processing[, is_in_study := fifelse(sel == 0, 1, 0)]

# is_prevalent

temp <- merge(medicines, processing[is_in_study == 1,.(person_id), all = F])

temp <- temp[, .(min = min(DATE)), by = "person_id" ]

processing <- merge(processing, temp, by = "person_id", all.x = T)

processing[, is_prevalent := fifelse(is_in_study == 1 & min < date_first, 1L, 0L, NA_integer_)]

# period


# clean and save

tokeep <- c("person_id", "sel_data_incomplete", "sel_no_obs_periods", "sel_obs_period_not_overlapped_study_period", "sel_never18plus_during_study_period", "sel_no_drug", "sel_no_drug_during_obs_period_correct_age", "date_first", "start_study_op", "end_study_op", "sel_no_lookback", "sel_no_ASL", "is_in_study", "is_prevalent", "period", "ASL", "birth_date", "gender")

processing <- processing[, ..tokeep]

nameoutputfile <- paste0("D3_selezione_coorte.rds")

saveRDS(processing, file = file.path(thisdiroutput, nameoutputfile))

saveRDS(processing, file = file.path(thisdiroutput, nameoutputfile))

# incident population

processing <- processing[is_prevalent == 0,]

tokeep <- c("person_id", "birth_date", "gender","ASL", "date_first", "start_study_op", "end_study_op",  "period")

processing <- processing[, ..tokeep]

nameoutputfile <- paste0("D3_coorte.rds")

saveRDS(processing, file = file.path(thisdiroutput, nameoutputfile))



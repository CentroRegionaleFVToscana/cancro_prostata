############################################################
#                                                          #
####         create D3_episodi_farmaci_in_studio        ####
#                                                          #
############################################################


# author: Rosa Gini

# v 1.0 16 Sep 2026


print('CREATE D3_episodi_farmaci_in_studio')


#########################################
# assign directories and other parameters used in this step

if (TEST){
  testname <- "test_D3_episodi_farmaci_in_studio"
  thisdirinput <- file.path(dirtest,testname)
  thisdiroutput <- file.path(thisdirinput,"g_output")
  thisdirexp <- thisdiroutput
  thisdrug_names <- c("abira", "apalu")
  dir.create(thisdiroutput, showWarnings = F)
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
  thisdirexp <- direxp
  thisdrug_names <- drug_names
}

#########################################
# load parameters

for (i in thisdrug_names) { 
  
  print(i)
  
  # load data
  
  dispensings <- as.data.table(get(load(file.path(thisdirinput, paste0(i,".RData")))[[1]]))
  setnames(dispensings, "ID", "person_id")
  
  dispensings <- dispensings[,.(person_id, DATE)]
  assign(i, dispensings)


  persons <- readRDS(file.path(thisdirinput,paste0("D3_coorte_",i,".rds")))
  

  #########################################
  # start_processing

  dispensings <- unique(dispensings)
  
  dispensings <- merge(dispensings, persons[,.(person_id)], by = "person_id", all = F )
  
  dispensings <- dispensings[, duration := 28]

  # use AdhereR
  
  window_duration <- as.integer(study_end_date - study_start_date) + 730
  
  processing <- compute.treatment.episodes(dispensings,
                                       ID.colname= "person_id",
                                       event.date.colname= "DATE",
                                       event.duration.colname= "duration",
                                       # medication.class.colname= "codvar",
                                       carryover.within.obs.window = TRUE, # carry-over into the OW
                                       # carry.only.for.same.medication = TRUE, # & only for same type
                                       medication.change.means.new.treatment.episode = FALSE, # & type change
                                       maximum.permissible.gap = 28, # & a gap longer than 90 days
                                       maximum.permissible.gap.unit = "days",
                                       followup.window.duration = window_duration
    )
    processing <- as.data.table(processing)
    setnames(processing,c("episode.start","episode.end"),c("episode_start",	"episode_end"))
    processing[ , episode_end := episode_end + 28]    
  # keep only the episode  that includes index date
    
    processing <- merge(processing, persons[,.(person_id, date_first)], all = F)
    processing <- processing[date_first >= episode_start & date_first <= episode_end,]
  
 
  #########################################
  # clean

  listvartokeep <- c("person_id","date_first", "episode_start", "episode_end")
  
  setorder(processing, person_id, episode_start)
  

  processing <- processing[,..listvartokeep]



  #########################################
  # save

  outputfile <- processing

  nameoutput <- paste0("D3_episodi_farmaci_in_studio_",i)
  assign(nameoutput, outputfile)
  saveRDS(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,".rds")))
  #fwrite(outputfile, file = file.path(thisdiroutput, paste0(nameoutput,".csv")))
}

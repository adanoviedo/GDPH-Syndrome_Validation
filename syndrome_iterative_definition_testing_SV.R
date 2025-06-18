#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#             ___ _    ____________  ______      #  
#            /   | |  / / ____/ __ \/_  __/      #
#           / /| | | / / __/ / /_/ / / /         #
#          / ___ | |/ / /___/ _, _/ / /          #
#         /_/  |_|___/_____/_/ |_| /_/           #
#                                                #
#  Advancing Violence Epidemiology in Real Time  #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#' -----------------------------------------------------------------------------
#' R Script: syndrome_iterative_definition_testing_SV.R
#' 
#' Description:
#'  R script to pull and test iterative versions of SQL translated syndrome 
#'  definitions for sexual violence. This script will run an iterative version
#'  and then pull each updated query section individually. Each individual 
#'  term will then be exported into an excel file in its own tab for review
#'  by Ashley. 
#' 
#' Date: 2025-06-13
#' 
#' Questions or Requests: Adan.Oviedo@dph.ga.gov
#' 
#'------------------------------------------------------------------------------

#Load packages
library(tidyverse)
library(readxl)
library(lubridate)
library(writexl)
library(sqldf)

# Call in filepaths ------------------------------------------------------------
source("syndrome_iterative_definition_filepath_SV.R")

# Import Data and Get Intercept ------------------------------------------------
# ESSENCE
ESSENCE_ED_Q4_2023 <- read_csv(ESSENCE_ED_Q4_2023) %>% 
  select(Raw.Data.ID=C_Unique_Patient_ID,  #Unique identifier
         CCDDCategory_flat,
         essence_cc=ChiefComplaintOrig, 
         essence_dd=DischargeDiagnosis
  )

# SendSS
SENDSS_ED_Q4_2023 <- read_csv(SENDSS_ED_Q4_2023)
colnames(SENDSS_ED_Q4_2023) <- make.names(colnames(SENDSS_ED_Q4_2023), unique=TRUE) 

SENDSS_ED_Q4_2023 <- SENDSS_ED_Q4_2023 %>% 
  select(Raw.Data.ID, 
         cc=Chief.Complaint, #changed name to match oracle query in SendSS
         icd9=ICD.9 #changed name to match oracle query in SendSS
  )

# Merge to include intersect of records found in ESSENCE and SendSS in order to 
# have a 1:1 comparison.
intersect_visits <- merge(x=SENDSS_ED_Q4_2023, 
                          y=ESSENCE_ED_Q4_2023, 
                          by=c("Raw.Data.ID"),
                          all.x=FALSE,
                          all.y=FALSE)


# Call in iterative version of syndrome SQL definition --------------------------
#source("Definitions/Sexual_violence/Syn_Def_SV_V1.R")
source(version)


# Export for Analysis -----------------------------------------------------------
# Export to Excel with each data set as a separate sheet
write_xlsx(combined_list_test, path = "combined_output.xlsx")



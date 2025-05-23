# Inspiration was filling data gap in other attempts to quantify wealth:
# 1. Often only disaggregated to the county level. With only 23 counties and 1 city, this is too coarse
# 2. Static measure, doesn't show change or improvement
# 3. Often focused on income, which is a monetary rate, instead of wealth, which is a stock and can be monetary or non-monetary

# Check .env-example to see what API keys you need, and copy into .env before running

list.of.packages <- c(
  "data.table", "dplyr", "tidycensus", "tidyverse", "dotenv",
  "factoextra", "ggplot2", "scales", "sf", "tibble", "tidyr"
)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
suppressPackageStartupMessages(lapply(list.of.packages, require, character.only=T))

getCurrentFileLocation =  function()
{
  this_file = commandArgs() %>% 
    tibble::enframe(name = NULL) %>%
    tidyr::separate(col=value, into=c("key", "value"), sep="=", fill='right') %>%
    dplyr::filter(key == "--file") %>%
    dplyr::pull(value)
  if (length(this_file)==0)
  {
    this_file = rstudioapi::getSourceEditorContext()$path
  }
  return(dirname(this_file))
}

setwd(getCurrentFileLocation())

load_dot_env()
api_key = Sys.getenv("CENSUS_API_KEY")
census_api_key(api_key)

# all_acs_vars = load_variables(2023, "acs5")
# race_disaggregated_vars = subset(
#   all_acs_vars, 
#   grepl("black|african american", label, ignore.case=T) |
#   grepl("black|african american", concept, ignore.case=T)
# )
# unique_race_concepts = unique(race_disaggregated_vars$concept)[order(unique(race_disaggregated_vars$concept))]
# 
# ethnicity_disaggregated_vars = subset(
#   all_acs_vars, 
#   grepl("hispanic|latino", label, ignore.case=T) |
#     grepl("hispanic|latino", concept, ignore.case=T)
# )
# unique_ethnicity_concepts = unique(ethnicity_disaggregated_vars$concept)[order(unique(ethnicity_disaggregated_vars$concept))]

# Black or African American inputs ####

# B01001B_001
# Estimate!!Total:
# Sex by Age (Black or African American Alone)
# tract

# B25003B_001
# Estimate!!Total:
# Tenure (Black or African American Alone Householder)
# block group

# B25003B_002
# Estimate!!Total:!!Owner occupied
# Tenure (Black or African American Alone Householder)
# block group

# B25077B_001
# Estimate!!Median value (dollars)
# Median Value (Dollars, Black or African American Alone Householder)
# block group

# B08105B_001
# Estimate!!Total:
# Means of Transportation to Work (Black or African American Alone)
# tract

# B08105B_002
# Estimate!!Total:!!Car, truck, or van - drove alone
# Means of Transportation to Work (Black or African American Alone)
# tract

# B08105B_007
# Estimate!!Total:!!Worked from home
# Means of Transportation to Work (Black or African American Alone)
# tract

# B25014B_001
# Estimate!!Total:
# Occupants per Room (Black or African American Alone Householder)
# tract

# B25014B_002
# Estimate!!Total:!!1.00 or less occupants per room
# Occupants per Room (Black or African American Alone Householder)
# tract

# B25032B_001
# Estimate!!Total:
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_002
# Estimate!!Total:!!1, detached
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_003
# Estimate!!Total:!!1, attached
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_004
# Estimate!!Total:!!2
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_005
# Estimate!!Total:!!3 or 4
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_006
# Estimate!!Total:!!5 to 9
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_007
# Estimate!!Total:!!10 to 19
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_008
# Estimate!!Total:!!20 to 49
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_009
# Estimate!!Total:!!50 or more
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_010
# Estimate!!Total:!!Mobile home
# Units in Structure (Black or African American Alone Householder)
# tract

# B25032B_011
# Estimate!!Total:!!Boat, RV, van, etc.
# Units in Structure (Black or African American Alone Householder)
# tract

# B28009B_001
# Estimate!!Total:
# Presence of a Computer and Type of Internet Subscription in Household (Black or African American Alone)
# block group

# B28009B_002
# Estimate!!Total:!!Has a computer:
# Presence of a Computer and Type of Internet Subscription in Household (Black or African American Alone)
# block group

# B22005B_001
# Estimate!!Total:
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (Black or African American Alone)
# tract

# B22005B_003
# Estimate!!Total:!!Household did not receive Food Stamps/SNAP in the past 12 months
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (Black or African American Alone)
# tract


# Hispanic or Latino inputs ####

# B01001I_001
# Estimate!!Total:
# Sex by Age (Hispanic or Latino)
# tract

# B25003I_001
# Estimate!!Total:
# Tenure (Hispanic or Latino Householder)
# block group

# B25003I_002
# Estimate!!Total:!!Owner occupied
# Tenure (Hispanic or Latino Householder)
# block group

# B25077I_001
# Estimate!!Median value (dollars)
# Median Value (Dollars, Hispanic or Latino Householder)
# block group

# B08105I_001
# Estimate!!Total:
# Means of Transportation to Work (Hispanic or Latino)
# tract

# B08105I_002
# Estimate!!Total:!!Car, truck, or van - drove alone
# Means of Transportation to Work (Hispanic or Latino)
# tract

# B08105I_007
# Estimate!!Total:!!Worked from home
# Means of Transportation to Work (Hispanic or Latino)
# tract

# B25014I_001
# Estimate!!Total:
# Occupants per Room (Hispanic or Latino Householder)
# tract

# B25014I_002
# Estimate!!Total:!!1.00 or less occupants per room
# Occupants per Room (Hispanic or Latino Householder)
# tract

# B25032I_001
# Estimate!!Total:
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_002
# Estimate!!Total:!!1, detached
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_003
# Estimate!!Total:!!1, attached
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_004
# Estimate!!Total:!!2
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_005
# Estimate!!Total:!!3 or 4
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_006
# Estimate!!Total:!!5 to 9
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_007
# Estimate!!Total:!!10 to 19
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_008
# Estimate!!Total:!!20 to 49
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_009
# Estimate!!Total:!!50 or more
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_010
# Estimate!!Total:!!Mobile home
# Units in Structure (Hispanic or Latino Householder)
# tract

# B25032I_011
# Estimate!!Total:!!Boat, RV, van, etc.
# Units in Structure (Hispanic or Latino Householder)
# tract

# B28009I_001
# Estimate!!Total:
# Presence of a Computer and Type of Internet Subscription in Household (Hispanic or Latino)
# block group

# B28009I_002
# Estimate!!Total:!!Has a computer:
# Presence of a Computer and Type of Internet Subscription in Household (Hispanic or Latino)
# block group

# B22005I_001
# Estimate!!Total:
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (Hispanic or Latino)
# tract

# B22005I_003
# Estimate!!Total:!!Household did not receive Food Stamps/SNAP in the past 12 months
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (Hispanic or Latino)
# tract

# White, not hispanic inputs ####

# B01001H_001
# Estimate!!Total:
# Sex by Age (White Alone, Not Hispanic or Latino)
# tract

# B25003H_001
# Estimate!!Total:
# Tenure (White Alone, Not Hispanic or Latino Householder)
# block group

# B25003H_002
# Estimate!!Total:!!Owner occupied
# Tenure (White Alone, Not Hispanic or Latino Householder)
# block group

# B25077H_001
# Estimate!!Median value (dollars)
# Median Value (Dollars, White Alone, Not Hispanic or Latino Householder)
# block group

# B08105H_001
# Estimate!!Total:
# Means of Transportation to Work (White Alone, Not Hispanic or Latino)
# tract

# B08105H_002
# Estimate!!Total:!!Car, truck, or van - drove alone
# Means of Transportation to Work (White Alone, Not Hispanic or Latino)
# tract

# B08105H_007
# Estimate!!Total:!!Worked from home
# Means of Transportation to Work (White Alone, Not Hispanic or Latino)
# tract

# B25014H_001
# Estimate!!Total:
# Occupants per Room (White Alone, Not Hispanic or Latino Householder)
# tract

# B25014H_002
# Estimate!!Total:!!1.00 or less occupants per room
# Occupants per Room (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_001
# Estimate!!Total:
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_002
# Estimate!!Total:!!1, detached
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_003
# Estimate!!Total:!!1, attached
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_004
# Estimate!!Total:!!2
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_005
# Estimate!!Total:!!3 or 4
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_006
# Estimate!!Total:!!5 to 9
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_007
# Estimate!!Total:!!10 to 19
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_008
# Estimate!!Total:!!20 to 49
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_009
# Estimate!!Total:!!50 or more
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_010
# Estimate!!Total:!!Mobile home
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B25032H_011
# Estimate!!Total:!!Boat, RV, van, etc.
# Units in Structure (White Alone, Not Hispanic or Latino Householder)
# tract

# B28009H_001
# Estimate!!Total:
# Presence of a Computer and Type of Internet Subscription in Household (White Alone, Not Hispanic or Latino)
# block group

# B28009H_002
# Estimate!!Total:!!Has a computer:
# Presence of a Computer and Type of Internet Subscription in Household (White Alone, Not Hispanic or Latino)
# block group

# B22005H_001
# Estimate!!Total:
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (White Alone, Not Hispanic or Latino)
# tract

# B22005H_003
# Estimate!!Total:!!Household did not receive Food Stamps/SNAP in the past 12 months
# Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (White Alone, Not Hispanic or Latino)
# tract

demographic_codes = c(
  "B" = "black", # Black or African American
  "I" = "latino", # Hispanic or Latino
  "H" = "white" # White Alone, not Hispanic or Latino
)

variable_parts = list(
  "population" = c("B01001", "001"),
  "tenureDenominator" = c("B25003", "001"),
  "tenureOwnerOccupied" = c("B25003", "002"),
  # "medianHomeValue" = c("B25077", "001"), # Only available in 2023
  "commuteDenominator" = c("B08105", "001"),
  "commuteDroveAlone" = c("B08105", "002"),
  "commuteWfh" = c("B08105", "007"),
  "occupantsDenominator" = c("B25014", "001"),
  "occupantsLte1" = c("B25014", "002"),
  "unitsDenominator" = c("B25032", "001"),
  "units1detached" = c("B25032", "002"),
  "units1attached" = c("B25032", "003"),
  "units2" = c("B25032", "004"),
  "units3to4" = c("B25032", "005"),
  "units5to9" = c("B25032", "006"),
  "units10to19" = c("B25032", "007"),
  "units20to49" = c("B25032", "008"),
  "units50orMore" = c("B25032", "009"),
  "unitsMobileHome" = c("B25032", "010"),
  "unitsBoatRvVanEtc" = c("B25032", "011"),
  # "computerDenominator" = c("B28009", "001"), # Only available 2018+
  # "computerPresent" = c("B28009", "002"),
  "snapDenominator" = c("B22005", "001"),
  "snapDidNotReceive" = c("B22005", "003")
)

variable_names = c()
variables = c()
for(i in 1:length(variable_parts)){
  variable_name_stem = names(variable_parts)[i]
  variable_part = variable_parts[[i]]
  for(j in 1:length(demographic_codes)){
    demographic_code = names(demographic_codes)[j]
    demographic_name = demographic_codes[j]
    variable = paste0(variable_part[1], demographic_code, "_", variable_part[2])
    variable_name = paste0(variable_name_stem, "_", demographic_name)
    variable_names = c(variable_names, variable_name)
    variables = c(variables, variable)
  }
}

names(variables) = variable_names


if(!file.exists("wealth_index.RData")){
  acs_list = list()
  acs_index = 1
  years = c(2014:2023)
  for(year in years){
    message(year)
    acs_tmp = get_acs(
      survey="acs5",
      geography="tract",
      variables=variables,
      year=year,
      state=24
    )
    acs_tmp$year = year
    acs_list[[acs_index]] = acs_tmp
    acs_index = acs_index + 1
  }
  acs_long = rbindlist(acs_list)
  save(acs_long, file="wealth_index.RData")
}else{
  load("wealth_index.RData")
}

acs = dcast(data.table(acs_long), GEOID+year~variable, value.var="estimate")
acs = data.table(acs)

source("util_nhgis_census_crosswalk.R")

acs_2010_tracts = subset(acs, year <= 2019)
original_pop = sum(acs_2010_tracts$population_black)
acs_2020_tracts = subset(acs, year > 2019)

acs_2010_tracts_crosswalked = acs_2010_tracts %>% nhgis_crosswalk(
  start_year=2010,
  end_year=2020,
  GEOID_col="GEOID",
  value_cols=variable_names,
  states = c(
    "24" # MD
  )
)
acs_2010_tracts_crosswalked$GEOID = acs_2010_tracts_crosswalked$end_GEOID
acs_2010_tracts_crosswalked = subset(acs_2010_tracts_crosswalked, !is.na(GEOID))
acs_2010_tracts_crosswalked = acs_2010_tracts_crosswalked[,
  setNames(lapply(.SD, sum, na.rm = TRUE), variable_names),
  by = .(GEOID, year),
  .SDcols = paste0("crosswalk_", variable_names)
]
new_pop = sum(acs_2010_tracts_crosswalked$population_black)
stopifnot(
  {
    (original_pop - new_pop) == 0
  }
)

acs = rbindlist(list(acs_2010_tracts_crosswalked, acs_2020_tracts), fill=T)
acs = data.frame(acs)
keep = c("GEOID", "year")
for(demographic_name in demographic_codes){
  keep = c(keep, paste0("population_", demographic_name))
  
  tenureDenominator_var = paste0("tenureDenominator_", demographic_name)
  tenureOwner_var = paste0("tenureOwnerOccupied_", demographic_name)
  tenureOwnerRate_var = paste0("tenureOwnerOccupiedRate_", demographic_name)
  acs[,tenureOwnerRate_var] = acs[,tenureOwner_var] / acs[,tenureDenominator_var]
  acs[,tenureOwnerRate_var][which(is.nan(acs[,tenureOwnerRate_var]))] = NA
  keep = c(keep, tenureOwnerRate_var)
  
  commuteDenominator_var = paste0("commuteDenominator_", demographic_name)
  commuteDroveAlone_var = paste0("commuteDroveAlone_", demographic_name)
  commuteWfh_var = paste0("commuteWfh_", demographic_name)
  commuteDroveOrWfhRate_var = paste0("commuteDroveOrWfhRate_", demographic_name)
  acs[,commuteDroveOrWfhRate_var] = 
    rowSums(acs[,c(commuteDroveAlone_var, commuteWfh_var)]) /
    acs[,commuteDenominator_var]
  acs[,commuteDroveOrWfhRate_var][which(is.nan(acs[,commuteDroveOrWfhRate_var]))] = NA
  keep = c(keep, commuteDroveOrWfhRate_var)
  
  occupantsDenominator_var = paste0("occupantsDenominator_", demographic_name)
  occupantsLte1_var = paste0("occupantsLte1_", demographic_name)
  occupantsLte1Rate_var = paste0("occupantsLte1Rate_", demographic_name)
  acs[,occupantsLte1Rate_var] = acs[,occupantsLte1_var] / acs[,occupantsDenominator_var]
  acs[,occupantsLte1Rate_var][which(is.nan(acs[,occupantsLte1Rate_var]))] = NA
  keep = c(keep, occupantsLte1Rate_var)
  
  unit_numerator_stems = c(
    "1detached",
    "1attached",
    "2",
    "3to4",
    "5to9",
    "10to19",
    "20to49",
    "50orMore",
    "MobileHome",
    "BoatRvVanEtc"
  )
  unitsDenominator_var = paste0("unitsDenominator_", demographic_name)
  for(unit_numerator_stem in unit_numerator_stems){
    unitsNumerator_var = paste0("units", unit_numerator_stem, "_", demographic_name)
    unitsNumeratorRate_var = paste0("units", unit_numerator_stem, "Rate_", demographic_name)
    acs[,unitsNumeratorRate_var] = acs[,unitsNumerator_var] / acs[,unitsDenominator_var]
    acs[,unitsNumeratorRate_var][which(is.nan(acs[,unitsNumeratorRate_var]))] = NA
    keep = c(keep, unitsNumeratorRate_var)
  }
  
  snapDenominator_var = paste0("snapDenominator_", demographic_name)
  snapDidNotReceive_var = paste0("snapDidNotReceive_", demographic_name)
  snapDidNotReceiveRate_var = paste0("snapDidNotReceiveRate_", demographic_name)
  acs[,snapDidNotReceiveRate_var] = acs[,snapDidNotReceive_var] / acs[,snapDenominator_var]
  acs[,snapDidNotReceiveRate_var][which(is.nan(acs[,snapDidNotReceiveRate_var]))] = NA
  keep = c(keep, snapDidNotReceiveRate_var)
}

acs = acs[,keep]

acs_demographic_long = melt(data.table(acs), id.vars=c("GEOID", "year"))

acs_demographic_var_split = strsplit(as.character(acs_demographic_long$variable), split="_")
acs_demographic_long$variable = sapply(
  acs_demographic_var_split,
  `[[`,
  1
)
acs_demographic_long$demographic = sapply(
  acs_demographic_var_split,
  `[[`,
  2
)

acs_demographic_wide = dcast(
  acs_demographic_long,
  GEOID+year+demographic~variable
)
complete_case_indices = which(complete.cases(acs_demographic_wide) & acs_demographic_wide$population >= 50)

x = acs_demographic_wide[complete_case_indices,c(
  "commuteDroveOrWfhRate"
  ,"occupantsLte1Rate"
  ,"snapDidNotReceiveRate"
  ,"tenureOwnerOccupiedRate"
  ,"units1attachedRate"
  ,"units1detachedRate"
  ,"units2Rate"
  ,"units3to4Rate"
  ,"units5to9Rate"
  ,"units10to19Rate"
  # ,"units20to49Rate" # Past this point, decreases explanatory power of model
  # ,"units50orMoreRate"
  # ,"unitsBoatRvVanEtcRate"
  # ,"unitsMobileHomeRate"
)]

pca_result = prcomp(x, scale.=T)
fviz_eig(pca_result, addlabels = TRUE)
fviz_pca_var(pca_result, col.var = "black")
FLIP_SIGN = -1

acs_demographic_wide$wealth_index = NA
acs_demographic_wide$wealth_index[complete_case_indices] = pca_result$x[, 1]  * FLIP_SIGN

acs_demographic_wide = acs_demographic_wide[,c("GEOID","year","demographic","wealth_index")]
acs_demographic_wide_wide = 
  dcast(
    acs_demographic_wide,
    GEOID+year~demographic,value.var="wealth_index"
  )
setnames(
  acs_demographic_wide_wide,
  c("black","latino","white"),
  c("black_wealth_index", "latino_wealth_index", "white_wealth_index")
)
acs_demographic_wide_wide$black_white_gap =
  acs_demographic_wide_wide$black_wealth_index -
  acs_demographic_wide_wide$white_wealth_index

acs_demographic_wide_wide$latino_white_gap =
  acs_demographic_wide_wide$latino_wealth_index -
  acs_demographic_wide_wide$white_wealth_index

fwrite(acs_demographic_wide_wide,"wealth_indicies_data.csv")
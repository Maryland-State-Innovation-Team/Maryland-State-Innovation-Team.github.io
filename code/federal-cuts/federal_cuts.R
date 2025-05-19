list.of.packages <- c(
  "data.table", "dplyr","openxlsx", "Hmisc", "dotenv", "jsonlite", "sf", "ggplot2", "scales", "tibble", "tidyr"
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
FRED_KEY = Sys.getenv("FRED_KEY")

if(!file.exists("fred_pov_md.RData")){
  series_observations = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/series/observations?series_id=PPU18MD24000A156NCEN&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$observations
  dat = series_observations[,c('date','value')]
  dat$value[which(dat$value==".")] = NA
  dat$year = year(dat$date)
  dat$value = as.numeric(dat$value)/100
  dat$geo = "Maryland"
  save(dat, file="fred_pov_md.RData")
}else{
  load("fred_pov_md.RData")
}
setnames(dat,"value","maryland_child_pov_rate")

if(!file.exists("fred_pov_count_md.RData")){
  series_observations = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/series/observations?series_id=PEU18MD24000A647NCEN&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$observations
  pov_count = series_observations[,c('date','value')]
  pov_count$value[which(pov_count$value==".")] = NA
  pov_count$year = year(pov_count$date)
  pov_count$value = as.numeric(pov_count$value)
  pov_count$geo = "Maryland"
  save(pov_count, file="fred_pov_count_md.RData")
}else{
  load("fred_pov_count_md.RData")
}
setnames(pov_count,"value","maryland_child_pov_count")
pov_count$date = NULL
dat = merge(dat, pov_count, by=c("geo","year"), all.x=T)


# Population
if(!file.exists("state_pops.RData")){
  series = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/release/series?release_id=118&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$seriess
  data_list = list()
  for(i in 1:nrow(series)){
    message(i)
    row = series[i,]
    if(!grepl(" in the ", row$title) & !grepl("DISCONTINUED", row$title)){
      geo = strsplit(row$title, split=" in ")[[1]][2]
      series_observations = fromJSON(
        paste0(
          "https://api.stlouisfed.org/fred/series/observations?series_id=",
          row$id,
          "&api_key=",
          FRED_KEY,
          "&file_type=json"
        )
      )$observations
      series_observations = series_observations[,c('date','value')]
      series_observations$geo = geo
      series_observations$units = row$units
      series_observations$seasonal_adjustment = row$seasonal_adjustment
      data_list[[as.character(i)]] = series_observations
    }
  }
  pop = rbindlist(data_list)
  pop$value = as.numeric(pop$value) * 1e3
  save(pop, file="state_pops.RData")
}else{
  load("state_pops.RData")
}

setnames(pop,"value","population")
pop$year = year(pop$date)
pop = pop[,c("geo","year","population")]
dat = merge(dat, pop, by=c("geo", "year"), all.x=T)
setnames(dat,"population","maryland_population")

pop_nat = data.table(pop)[,.(us_population=sum(population)),by=.(year)]
dat = merge(dat, pop_nat, by="year", all.x=T)

# Real GDP
if(!file.exists("state_gdp.RData")){
  series_suffix = "RGSP"
  series_observations = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/series/observations?series_id=",
      "MD",series_suffix,
      "&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$observations
  real_gdp = series_observations[,c('date','value')]
  real_gdp$geo = "Maryland"
  real_gdp$value = as.numeric(real_gdp$value) * 1e6
  save(real_gdp, file="state_gdp.RData")
}else{
  load("state_gdp.RData")
}

setnames(real_gdp, "value", "maryland_real_gdp")
real_gdp$year = year(real_gdp$date)
real_gdp = real_gdp[,c("geo","year","maryland_real_gdp")]
dat = merge(dat, real_gdp, by=c("geo", "year"), all.x=T)


# State/local gov spend (real)
if(!file.exists("state_local_gov_md.RData")){
  series_observations = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/series/observations?series_id=MDGOVSLRGSP",
      "&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$observations
  sl_gov = series_observations[,c('date','value')]
  sl_gov$geo = "Maryland"
  sl_gov$value = as.numeric(sl_gov$value) * 1e6
  save(sl_gov, file="state_local_gov_md.RData")
}else{
  load("state_local_gov_md.RData")
}

setnames(sl_gov, "value", "maryland_state_local_govt_spend")
sl_gov$year = year(sl_gov$date)
sl_gov = sl_gov[,c("geo","year","maryland_state_local_govt_spend")]
dat = merge(dat, sl_gov, by=c("geo", "year"), all.x=T)

# Unemployment rate
if(!file.exists("unemployment_md.RData")){
  series_observations = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/series/observations?series_id=LAUST240000000000003A",
      "&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$observations
  unemp = series_observations[,c('date','value')]
  unemp$geo = "Maryland"
  unemp$value = as.numeric(unemp$value) / 100
  save(unemp, file="unemployment_md.RData")
}else{
  load("unemployment_md.RData")
}

setnames(unemp, "value", "maryland_unemployment")
unemp$year = year(unemp$date)
unemp = unemp[,c("geo","year","maryland_unemployment")]
dat = merge(dat, unemp, by=c("geo", "year"), all.x=T)

# Fed total exp, source: https://www.cbo.gov/data/budget-economic-data
cbo_fed_desc = read.xlsx("51134-2025-01-Historical-Budget-Data.xlsx",sheet="4. Discretionary Outlays",startRow = 8)
cbo_fed_desc = cbo_fed_desc[c(1:63),c("X1","Defense","Nondefense")]
names(cbo_fed_desc) = c("year", "federal_expend_military_discretionary", "federal_expend_nonmilitary_discretionary")
cbo_fed_desc$federal_expend_military_discretionary = cbo_fed_desc$federal_expend_military_discretionary * 1e6
cbo_fed_desc$federal_expend_nonmilitary_discretionary = cbo_fed_desc$federal_expend_nonmilitary_discretionary * 1e6

cbo_fed_mand = read.xlsx("51134-2025-01-Historical-Budget-Data.xlsx",sheet="5. Mandatory Outlays",startRow = 8)
cbo_fed_mand = cbo_fed_mand[c(1:63),c("X1","Total")]
names(cbo_fed_mand) = c("year", "federal_expend_mandatory")
cbo_fed_mand$federal_expend_mandatory = cbo_fed_mand$federal_expend_mandatory * 1e6

dat = merge(dat, cbo_fed_desc, by=c("year"), all.x=T)
dat = merge(dat, cbo_fed_mand, by=c("year"), all.x=T)

recession_years = c(1990, 1991, 2001, 2007, 2008, 2009, 2020)
dat$recession = dat$year %in% recession_years

fit = lm(
  log(maryland_child_pov_count)~
    recession+
    log(maryland_population)+
    log(maryland_real_gdp)+
    maryland_unemployment+
    log(maryland_state_local_govt_spend)+
    log(federal_expend_military_discretionary)+
    log(federal_expend_nonmilitary_discretionary)+
    log(federal_expend_mandatory), data=dat)
summary(fit)


dat_2023 = subset(dat, year==2023)
implied_total_child_count = dat_2023$maryland_child_pov_count / dat_2023$maryland_child_pov_rate

# Estimate
current_child_poverty_rate = dat_2023$maryland_child_pov_rate

dat_2023_predict = dat_2023
dat_2023_predict$federal_expend_nonmilitary_discretionary = 
  dat_2023_predict$federal_expend_nonmilitary_discretionary * 
  (1 + federal_nonmilitary_discretionary_percent_cut)

dat_2023_predict$maryland_child_pov_count_prime = 
  exp(predict(fit, newdata = dat_2023_predict))
additional_children_in_poverty = dat_2023_predict$maryland_child_pov_count_prime -
  dat_2023_predict$maryland_child_pov_count
new_child_poverty_rate = dat_2023_predict$maryland_child_pov_count_prime / implied_total_child_count

current_child_poverty_rate
new_child_poverty_rate
new_child_poverty_rate - current_child_poverty_rate
number_format(big.mark=",")(ceiling(additional_children_in_poverty))


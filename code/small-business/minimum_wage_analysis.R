# Source: https://www.census.gov/econ/bfs/current/index.html

list.of.packages <- c(
  "data.table", "dplyr","openxlsx", "Hmisc", "dotenv", "jsonlite", "sf",
  "tidycensus", "forecast", "ggplot2", "scales", "tibble", "tidyr"
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

if(!file.exists("minimum_wages.RData")){
  series = fromJSON(
    paste0(
      "https://api.stlouisfed.org/fred/release/series?release_id=387&api_key=",
      FRED_KEY,
      "&file_type=json"
    )
  )$seriess
  series = subset(series, frequency=="Annual")
  data_list = list()
  for(i in 1:nrow(series)){
    message(i)
    row = series[i,]
    if(startsWith(row$title, "State")){
      geo = strsplit(row$title, split=" for ")[[1]][2]
    }else{
      geo = "Federal"
    }
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
    data_list[[i]] = series_observations
  }
  minimum_wage = rbindlist(data_list)
  minimum_wage$value = as.numeric(minimum_wage$value)
  save(minimum_wage, file="minimum_wages.RData")
}else{
  load("minimum_wages.RData")
}

states = fread("states.csv")
missing_states = setdiff(states$NAME, minimum_wage$geo)
federal_minimum = subset(minimum_wage, geo=="Federal")
minimum_wage = subset(minimum_wage, geo!="Federal")
for(state in missing_states){
  state_federal_copy = federal_minimum
  state_federal_copy$geo = state
  minimum_wage = rbind(
    minimum_wage,
    state_federal_copy
  )
}
usps_map = states$STUSPS
names(usps_map) = states$NAME
minimum_wage$geo = usps_map[minimum_wage$geo]
setnames(minimum_wage, "value", "minimum_wage")
minimum_wage$year = year(minimum_wage$date)
minimum_wage = minimum_wage[,c("geo","year","minimum_wage")]


dat = fread("bfs_monthly.csv")

month_map = c(
  "jan"=1,
  "feb"=2,
  "mar"=3,
  "apr"=4,
  "may"=5,
  "jun"=6,
  "jul"=7,
  "aug"=8,
  "sep"=9,
  "oct"=10,
  "nov"=11,
  "dec"=12
)

# Seasonally adjusted business applications
dat = subset(dat, sa=="A" & series=="BA_BA")[,c("year","geo",names(month_map)),with=F]
dat_long = melt(dat, id.vars=c("year","geo"))
dat_long$month = month_map[dat_long$variable]
dat_long$date = as.Date(paste(dat_long$year,dat_long$month, "01", sep="-"))
dat_long$value = as.numeric(dat_long$value)
dat_long = subset(dat_long, !is.na(value))
dat_long = subset(dat_long, !geo %in% c("US","NO","SO","WE"))

dat_long = merge(dat_long, minimum_wage, by=c("geo","year"), all.x=T)

# Structural change
md_dat = subset(dat_long, geo %in% c(
  "DC","NJ","MD","PA","VA","WV"
))
md_dat[,"change_in_minwage":=case_when(
  minimum_wage != dplyr::lag(minimum_wage) ~ T,
  .default=NA
), by=.(geo)]
md_dat[,"value_baseline":=(value/first(value)) - 1, by=.(geo)]
md_dat[,"vline_y":=max(value_baseline, na.rm=T) * 1.25]
md_dat$vline_date = md_dat$date
md_dat$vline_date[which(is.na(md_dat$change_in_minwage))] = NA
md_dat$vline_minimum_wage = md_dat$minimum_wage
md_dat$vline_minimum_wage[which(is.na(md_dat$change_in_minwage))] = NA
geo_to_name = states$NAME
names(geo_to_name) = states$STUSPS
md_dat$state_name = geo_to_name[md_dat$geo]
ggplot(md_dat, aes(x=date, y=value_baseline)) +
  geom_line(linewidth = 0.8, color = "black") +
  scale_y_continuous(labels=percent) +
  expand_limits(y=c(0, max(md_dat$value_baseline, na.rm=T) * 1.25)) +
  geom_vline(
    aes(xintercept=vline_date, color="Change in state minimum wage"),
    linetype="dashed",
    linewidth=0.7,
    alpha=0.8
  ) +
  geom_text(
    aes(x=vline_date, y=vline_y, label=dollar(vline_minimum_wage)),
    angle=90,
    vjust=-0.2,
    hjust=1,
    size=5.5,
    family="sans"
  ) +
  scale_color_manual(values="firebrick") +
  facet_wrap( . ~ state_name, scales = "free_x") +
  theme_light(base_size=25) +
  labs(
    x="", color="", y="Seasonally adjusted business applications\n(percent increase from July 2004 baseline)"
  ) +
  theme(
    legend.position="bottom"
  )
ggsave("minimum_wage_facet.png",width=18, height=12)

md_dat = subset(md_dat, geo=="MD")
# Filter data to be between March 2010 and March 2020
pre_covid_data <- md_dat %>%
  filter(
    date >= as.Date("2010-01-01") &
    date < as.Date("2020-03-01")
  )

# Fit auto ARIMA model
md_ts = ts(
  data=pre_covid_data$value,
  start=c(2010, 1),
  frequency=12
)
fit = auto.arima(md_ts)
summary(fit)


forecast_dates <- seq.Date(from = max(pre_covid_data$date, na.rm = TRUE),
                           to = as.Date("2025-04-01"),
                           by = "month")

predictions = forecast(fit, h = length(forecast_dates) - 1)

# Convert historical data to a data frame
df_historical <- data.frame(
  date = as.Date(as.yearmon(time(predictions$x))),
  value = as.numeric(predictions$x)
)

post_covid_data <- md_dat %>%
  filter(
    date >= as.Date("2020-03-01")
  )
df_historical = rbind(
  df_historical,
  post_covid_data[,c("date","value")]
)

# Convert forecast data to a data frame
time_forecast <- time(predictions$mean)
dates_forecast <- as.Date(as.yearmon(time_forecast))

df_forecast <- data.frame(
  date = dates_forecast,
  mean_forecast = as.numeric(predictions$mean),
  lower_80 = as.numeric(predictions$lower[,1]),
  upper_80 = as.numeric(predictions$upper[,1]),
  lower_95 = as.numeric(predictions$lower[,2]),
  upper_95 = as.numeric(predictions$upper[,2])
)

color_historical <- "black"
color_forecast_mean <- "#0072B2"
color_ribbon_95 <- "grey80"
color_ribbon_80 <- "#a6bddb"

ggplot() +
  geom_ribbon(data = df_forecast, aes(x = date, ymin = lower_95, ymax = upper_95, fill="95% conf"),
              alpha = 0.7) +
  geom_ribbon(data = df_forecast, aes(x = date, ymin = lower_80, ymax = upper_80, fill="80% conf"),
              alpha = 0.8) +
  geom_line(data = df_historical, aes(x = date, y = value),
            color = color_historical, linewidth = 0.6) +
  geom_line(data = df_forecast, aes(x = date, y = mean_forecast, color="Forecast"),
            linewidth = 0.8) +
  labs(
    x = "Year",
    y = "Seasonally adjusted business applications",
    color="",
    fill=""
  ) +
  scale_x_date(date_breaks = "3 years", date_labels = "%Y") +
  scale_y_continuous(
    labels=number_format(big.mark=","),
    expand = expansion(mult = c(0.05, 0.05))
  ) +
  scale_color_manual(
    values = c(
      "Forecast" = color_forecast_mean
    ),
    breaks = c("Forecast")
  ) +
  scale_fill_manual(
    values = c(
      "80% conf" = color_ribbon_80,
      "95% conf" = color_ribbon_95
    ),
    breaks = c("80% conf", "95% conf")
  ) +
  theme_light(base_size = 25) + 
  theme(
    axis.title = element_text(size = rel(1.1)),
    axis.text = element_text(size = rel(1.0)),
    legend.position="bottom"
  )

ggsave("minimum_wage_forecast.png",width=14, height=12)

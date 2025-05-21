# Source: https://www.fedsmallbusiness.org/reports/survey/2025/2025-report-on-employer-firms

list.of.packages <- c(
  "openxlsx", "data.table", "Hmisc", "stringr", "ggplot2", "scales", "tibble", "tidyr"
)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

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

qual5 = c(
  "Funds from owner"="#4E79A7",
  "Loan from family or friends"="#59A14F",
  "Grant"="#F28E2B",
  "Equity investment"="#7970A9",
  "Fundraising or donations"="#E15759"
)

dat_census = read.xlsx("sbcs-employer-firms-appendix-2024.xlsx", sheet="Census division")
dat_census_funding = subset(
  dat_census,
  Survey.question == "Other types of funding received"
)
dat_census_funding = subset(dat_census_funding, Percent > 0)
dat_census_funding$Response.option[which(dat_census_funding$Response.option=="Equity investment (including friends/family)")] = "Equity investment"
dat_census_funding = dat_census_funding[order(dat_census_funding$Percent),]
dat_census_funding$Response.option = factor(dat_census_funding$Response.option, levels=unique(dat_census_funding$Response.option))
dat_census_funding = data.table(dat_census_funding)[order(dat_census_funding$Census.division, -dat_census_funding$Response.option), ]
dat_census_funding[,"cumsumPercent":=cumsum(Percent),by=.(Census.division)]
dat_census_funding$y_text_pos = dat_census_funding$cumsumPercent - (dat_census_funding$Percent / 2)
ggplot(dat_census_funding, aes(x=Census.division, y=Percent, group=Response.option, fill=Response.option)) +
  geom_bar(stat="identity") +
  geom_text(data=subset(dat_census_funding, Response.option %in% c("Funds from owner", "Loan from family or friends", "Grant")), aes(y=y_text_pos, label=percent(Percent))) +
  scale_y_continuous(expand = c(0, 0), labels=percent) +
  scale_fill_manual(values=qual5) +
  theme_bw() +
  theme(
    panel.border = element_blank()
    ,panel.grid.major.x = element_blank()
    ,panel.grid.minor.x = element_blank()
    ,panel.grid.major.y = element_line(colour = "grey80")
    ,panel.grid.minor.y = element_blank()
    ,panel.background = element_blank()
    ,plot.background = element_blank()
    ,axis.line.x = element_line(colour = "black")
    ,axis.line.y = element_blank()
    ,axis.ticks = element_blank()
    ,axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)
    ,legend.position = "bottom"
  ) +
  labs(
    y="Percent of surveyed\nsmall businesses",
    x="",
    fill=""
  ) + guides(
    fill = guide_legend(ncol=2, reverse=T)
  )
ggsave("sbcs_census_division_funding.png", height=6, width=6)

dat_revenue = read.xlsx("sbcs-employer-firms-appendix-2024.xlsx", sheet="Revenue")
dat_revenue_funding = subset(
  dat_revenue,
  Survey.question == "Other types of funding received"
)
dat_revenue_funding$Response.option[which(dat_revenue_funding$Response.option=="Equity investment (including friends/family)")] = "Equity investment"
dat_revenue_funding = subset(dat_revenue_funding, Percent > 0)
dat_revenue_funding = dat_revenue_funding[order(dat_revenue_funding$Percent),]
dat_revenue_funding$Response.option = factor(dat_revenue_funding$Response.option, levels=unique(dat_revenue_funding$Response.option))
dat_revenue_funding$Revenue = factor(
  dat_revenue_funding$Revenue,
  levels=c(
    "$0-$25,000",
    "$25,001-$50,000",
    "$50,001-$100,000",
    "$100,001-$250,000",
    "$250,001-$500,000",
    "$500,001-$1 million",
    "$1 million-$5 million",
    "$5 million-$10 million",
    "More than $10 million"
  )
)
dat_revenue_funding = data.table(dat_revenue_funding)[order(dat_revenue_funding$Revenue, -dat_revenue_funding$Response.option), ]
dat_revenue_funding[,"cumsumPercent":=cumsum(Percent),by=.(Revenue)]
dat_revenue_funding$y_text_pos = dat_revenue_funding$cumsumPercent - (dat_revenue_funding$Percent / 2)
ggplot(dat_revenue_funding, aes(x=Revenue, y=Percent, group=Response.option, fill=Response.option)) +
  geom_bar(stat="identity") +
  geom_text(data=subset(dat_revenue_funding, Response.option %in% c("Funds from owner", "Loan from family or friends", "Grant")), aes(y=y_text_pos, label=percent(Percent))) +
  scale_y_continuous(expand = c(0, 0), labels=percent) +
  scale_fill_manual(values=qual5) +
  theme_bw() +
  theme(
    panel.border = element_blank()
    ,panel.grid.major.x = element_blank()
    ,panel.grid.minor.x = element_blank()
    ,panel.grid.major.y = element_line(colour = "grey80")
    ,panel.grid.minor.y = element_blank()
    ,panel.background = element_blank()
    ,plot.background = element_blank()
    ,axis.line.x = element_line(colour = "black")
    ,axis.line.y = element_blank()
    ,axis.ticks = element_blank()
    ,axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)
    ,legend.position = "bottom"
  ) +
  labs(
    y="Percent of surveyed\nsmall businesses",
    x="",
    fill=""
  ) + guides(
    fill = guide_legend(ncol=2, reverse=T)
  )
ggsave("sbcs_revenue_funding.png", height=6, width=6)

# Maryland Child Poverty Correlates Data

## Data Sources

- **American Community Survey (ACS) 5-Year Estimates (2023)**: Socioeconomic, housing, and demographic variables via the `tidycensus` and `censusapi` R packages.
- **Maryland Family Network Childcare Center Locations**: Custom geocoded dataset.
- **Small Business Lending Data**: Federal Financial Institution Examination Council (tract-level lending, 2014–2023).
- **Maryland Census Tract Names**: OpenStreetMap.

## Methodology

- **Variable Selection**: Variables are chosen to capture correlates of child poverty, including unemployment, underemployment, self-employment, industry, education, family structure, language, commute, internet access, housing burden, health insurance, social capital, childcare access, and small business lending.
- **Data Acquisition**: Data is pulled using R packages (`tidycensus`, `censusapi`, `sf`, etc.) and merged by census tract GEOID.
- **Derived Metrics**: Most variables are calculated as rates (e.g., child poverty rate, unemployment rate, percent without internet) by dividing relevant ACS estimates.
- **Special Calculations**:
  - **Child Poverty Rate**: Sum of children under 18 in poverty divided by total children under 18.
  - **Unemployment/Underemployment Rates**: Calculated for various age/gender groups, including labor force non-participation.
  - **Self-Employment & Industry**: Rates for self-employment and employment in agriculture, manufacturing, and transportation/warehousing/utilities.
  - **Education**: Percent of families in poverty with less than high school education.
  - **Family Structure**: Rates for married-couple, single-dad, and single-mom families in poverty, including those under 25.
  - **Grandparent Responsibility**: Rates for grandparents responsible for grandchildren, including duration and absence of parent.
  - **Language**: Percent of children in poverty speaking a non-English language at home.
  - **Commute**: Percent using various transportation modes among those in poverty.
  - **Internet Access**: Percent of households without broadband or any internet.
  - **Housing**: Percent renter-occupied, percent with rent/mortgage >30% of income.
  - **Health Insurance**: Percent uninsured by age group among those in poverty.
  - **Childcare Access**: Count of childcare centers per tract (spatial join), and average childcare cost as a percent of median family income.
  - **Small Business Lending**: Dollars per capita from tract-level lending data.
  - **Urban Status**: Urban/rural/mixed classification from tract data.
- **Data Cleaning**: All NaN or infinite rates are set to zero.
- **Merging**: All data is merged by tract GEOID, with tract names appended.

## Key Variables

- `child_pov_rate`: Child poverty rate
- `laborforce_nonparticipation_rate`: Labor force non-participation rate (16+)
- `civilian_unemployment_rate`: Unemployment rate (civilian labor force)
- `male_*_unemployment_rate`, `female_*_unemployment_rate`: Unemployment rates by age/gender
- `male_*_laborforce_nonparticipation_rate`, `female_*_laborforce_nonparticipation_rate`: Labor force non-participation by age/gender
- `mean_usual_hours_worked`: Mean usual hours worked (16–64)
- `male_underemployment_rate`, `female_underemployment_rate`: Underemployment rates by gender
- `self_employment_rate`: Self-employment rate
- `industry_agriforestfishhuntmine_rate`, `industry_manufacturing_rate`, `industry_transportwarehouseutility_rate`: Industry employment rates
- `poverty_education_lthighschool_rate`: Percent of families in poverty with less than high school education
- `poverty_family_marriedcouple_rate`, `poverty_family_singledad_rate`, `poverty_family_singlemom_rate`: Family structure rates in poverty
- `poverty_family_under25_rate`: Percent of families in poverty with householder under 25
- `poverty_grandparents_responsible_rate`: Grandparents responsible for grandchildren in poverty
- `grandparents_responsible_noparentpresent_rate`: Grandparents responsible with no parent present
- `grandparents_responsible_length_gt1year_rate`: Grandparents responsible for >1 year
- `poverty_language_nonenglish_rate`: Percent of children in poverty speaking non-English at home
- `internet_no_internet_rate`: Percent of households without any internet
- `childcare_centers`: Count of childcare centers in tract
- `childcare_cost_percent_median_family_income`: Average childcare cost as percent of median family income
- `small_business_loan_dollars_per_capita`: Small business loan dollars per capita
- `Urban_status`: Urban/rural/mixed classification
- *(Tract name fields appended)*

## Notes

- All rates are calculated at the census tract level for Maryland.
- Some variables (e.g., commute, health insurance, housing cost burden, voting, census response rates) are present in the code but may not be included in the final output dataset.
- All NaN or infinite values are set to zero.

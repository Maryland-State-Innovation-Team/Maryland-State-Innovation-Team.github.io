# Maryland Child Poverty Correlates Data

## Data Sources

- **American Community Survey (ACS) 5-Year Estimates (2023)**: Socioeconomic, housing, and demographic variables via the `tidycensus` and `censusapi` R packages.
- **2020 Decennial Census Response Rates**: Census Bureau API.
- **2020 Maryland Precinct-Level Election Results**: Voting and Election Science Team, Harvard Dataverse.
- **Maryland Childcare Center Locations**: Custom geocoded dataset based on Maryland Family Network.
- **Small Business Lending Data**: Federal Financial Institution Examination Council.
- **Maryland Census Tract Names**: OpenStreetMap.

## Methodology

- **Variable Selection**: Variables were selected to capture key correlates of child poverty, including unemployment, underemployment, self-employment, industry, education, family structure, language, commute, internet access, housing burden, health insurance, social capital, and childcare access.
- **Data Acquisition**: Data is pulled using R packages (`tidycensus`, `censusapi`, `sf`, etc.) and merged by census tract GEOID.
- **Derived Metrics**: Many variables are calculated as rates (e.g., child poverty rate, unemployment rate, percent without internet) by dividing relevant numerator and denominator ACS estimates.
- **Special Calculations**:
  - **Child Poverty Rate**: Sum of children under 18 in poverty divided by total children under 18.
  - **Unemployment/Underemployment Rates**: Calculated for various age/gender groups.
  - **Education**: Percent of adults with less than high school education.
  - **Family Structure**: Rates for married-couple, single-dad, and single-mom families in poverty.
  - **Language**: Percent of children in poverty speaking a non-English language at home.
  - **Commute**: Percent using various transportation modes among those in poverty.
  - **Internet Access**: Percent of households without broadband or any internet.
  - **Housing Cost Burden**: Percent of renters/owners spending >30% of income on housing.
  - **Health Insurance**: Percent uninsured by age group among those in poverty.
  - **Social Capital**: Census response rates and votes per capita (spatially weighted from precinct to tract).
  - **Childcare Access**: Count of childcare centers per tract (spatial join).
  - **Small Business Lending**: Dollars per capita from MCIV tract-level lending data.
- **Data Cleaning**: All NaN or infinite rates are set to zero.
- **Merging**: All data is merged by tract GEOID, with tract names appended.


## Key Variables

- `child_pov_rate`: Child poverty rate
- `civilian_unemployment_rate`: Unemployment rate (civilian labor force)
- `male_16_19_unemployment_rate`, ...: Unemployment rates by age/gender
- `male_underemployment_rate`, `female_underemployment_rate`
- `self_employment_rate`
- `industry_*_rate`: Industry employment rates
- `poverty_education_lthighschool_rate`: Percent of families in poverty with less than high school education
- `poverty_family_*_rate`: Family structure rates in poverty
- `poverty_language_nonenglish_rate`
- `poverty_commute_*_rate`
- `internet_no_broadband_rate`, `internet_no_internet_rate`
- `renter_occupied_rate`
- `cost_of_rent_gt30_rate`, `cost_of_mortgage_gt30_rate`
- `poverty_healthinsurance_*_noinsurance_rate`
- `decennial_census_response_rate`, `decennial_census_internet_response_rate`
- `votes_per_capita`
- `childcare_centers`
- `small_business_loan_dollars_per_capita`
- `Urban_status`
- Tract name fields

## Notes

- All rates are calculated at the census tract level for Maryland.

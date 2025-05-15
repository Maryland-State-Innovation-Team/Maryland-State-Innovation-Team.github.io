# Access to Capital Data Outputs

## FFIEC Aggregate Loan Data (all_ffiec_loans.csv)

A CSV file containing aggregate Community Reinvestment Act (CRA) loan data by year and state, downloaded from the FFIEC website.  
- **Key columns:**  
  - count_lte100k: Number of small business loan originations in the census tract with values less than or equal to $100,000
  - valueThousands_lte100k: Dollar amount of loans with values less than or equal to $100,000
  - count_lte250k: Number of loans with values less than or equal to $250,000
  - valueThousands_lte250k: Dollar amount of loans with values less than or equal to $250,000
  - count_gt250k: Number of loans with values greater than $250,000
  - valueThousands_gt250k: Dollar amount of loans with values greater than $250,000
  - count_revenuegte1m: Number of loans to businesses with revenues greater than $1 million
  - valueThousands_revenuegte1m: Dollar amount of loans to businesses with revenues greater than $1 million
  - GEOID: U.S. Census compatible census tract GEOID
- **Notes:**  
  - State FIPS codes are used for state identification.
  - Data is organized by MSA/MD within each state and year.

## FDIC Branch Data (fdic_branches_regional.csv)

This file contain FDIC-insured bank branch locations for MD, DE, DC, PA, VA, and WV from the FDIC SOD API.
- **Key columns:**  
  - Institution and branch identifiers  
  - Branch address, city, state, ZIP  
  - Geographic coordinates (longitude, latitude)  
  - Additional branch attributes (e.g., county FIPS, institution type)

## NCUA Credit Union Branch Data (ncua_branches_regional.csv)

This file contain credit union branch locations for the same six states, sourced from NCUA.  
- **Key columns:**  
  - Credit union name and branch details  
  - Branch address, city, state, ZIP  
  - Geographic coordinates (longitude, latitude)  
  - Additional branch attributes (e.g., branch type, services)

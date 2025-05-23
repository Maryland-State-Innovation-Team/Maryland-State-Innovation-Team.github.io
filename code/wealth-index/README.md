# Maryland Wealth Index Construction

This directory contains the code and documentation for constructing the Maryland Wealth Index, a composite measure of asset wealth at the census tract level, disaggregated by race/ethnicity and tracked over time.

## Purpose

The Wealth Index addresses gaps in existing measures of wealth by:
- Providing tract-level (not just county-level) estimates
- Tracking changes in wealth over time (not just static snapshots)
- Focusing on wealth (a stock) rather than just income (a flow)
- Disaggregating by key demographic groups: Black or African American, Hispanic or Latino, and White (not Hispanic or Latino)

## Data Sources
- U.S. Census Bureau American Community Survey (ACS) 5-Year Estimates (2014–2023)
- Census tract crosswalks from IPUMS NHGIS for consistent geography over time

## Key Variables
The index is constructed from a set of ACS variables related to housing, tenure, commuting, household crowding, and SNAP receipt, for each demographic group. Example variables include:
- Population counts
- Owner-occupied housing rates
- Commute modes (drove alone, worked from home)
- Households with ≤1 occupant per room
- Housing unit types (detached, attached, multi-unit, mobile home, etc.)
- SNAP (food stamp) receipt rates

See the comments in `construct_wealth_index.R` for the full list of variables and ACS codes used for each group.

## Methodology
1. **Data Download:**
   - Downloads ACS 5-year data for Maryland tracts for all variables and years of interest.
   - Uses a crosswalk to align 2010 and 2020 tract boundaries.
2. **Variable Calculation:**
   - Calculates rates (e.g., owner-occupied rate, commute mode rate) for each group and tract.
3. **Principal Component Analysis (PCA):**
   - Performs PCA on selected variables to derive a single wealth index per group, per tract, per year.
   - The first principal component (flipped sign for interpretability) is used as the index.
4. **Output:**
   - Outputs a CSV (`wealth_indicies_data.csv`) with columns for tract, year, group, and wealth index, as well as Black-White and Latino-White gaps.

## Usage

1. **Set up API keys:**
   - Copy `.env-example` to `.env` and add your Census API key.
2. **Install R dependencies:**
   - The script will auto-install required R packages if missing.
3. **Run the script:**
   - Execute `construct_wealth_index.R` in R or RStudio.
   - The script will download data, process, and output `wealth_indicies_data.csv`.

## Outputs
- `wealth_indicies_data.csv`: Main output with wealth index values by tract, year, and demographic group, plus gap indicators.
- Intermediate files: `wealth_index.RData` (cached ACS data)

## Customization
- To change variables or years, edit the relevant sections in `construct_wealth_index.R`.
- To use for other states, adjust the `state` parameter in the script.

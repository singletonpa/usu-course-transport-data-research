# Transportation datasets

## Bicycle safety at roundabouts survey data

This dataset comes from a research project investigating bicycling and roundabouts, specifically bicyclists’ safety perceptions of roundabouts, and bicyclists’ preferences for various roundabout elements. Survey data was collected from US bicyclists in 2020. Information about this project can be found on the following site: https://github.com/singletonpa/bicycle-safety-roundabouts/tree/main

**Download the bicycle safety roundabouts data (dat3)**
* **RDS format: https://raw.github.com/singletonpa/bicycle-safety-roundabouts/main/Data/Survey/dat3.rds**
* **CSV format: https://raw.github.com/singletonpa/bicycle-safety-roundabouts/main/Data/Survey/dat3.csv**

Each row is a survey response from a single person. The meaning of various column names can be taken from the survey questions documents here: https://github.com/singletonpa/bicycle-safety-roundabouts/tree/main/Data/Survey

## Utah Smart Location Database data 

This dataset includes information on the built environment and transportation accessibility characteristics of every US Census block group in Utah. Data were provided by the U.S. Environmental Protection Agency through their Smart Location Database in 2021: https://www.epa.gov/smartgrowth/smart-location-mapping#SLD

**Get the Smart Location Database for Utah (sld_utah) in [rds](EPA_SLD_Utah/sld_utah.rds) (spatial) and [csv](EPA_SLD_Utah/sld_utah.csv) (data only) formats.**

**Get the Smart Location Database for Utah (sld_utah) in [Shapefile](EPA_SLD_Utah/sld_utah) format.**

**Download the Smart Location Database for Utah (sld_utah)**
* **RDS (spatial) format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/EPA_SLD_Utah/sld_utah.rds**

Each row is a Census block group and contains a variety of information. Specific column names are described in the SLD User Guide: https://www.epa.gov/sites/default/files/2021-06/documents/epa_sld_3.0_technicaldocumentationuserguide_may2021.pdf
* Administrative, CBSA-wide statistics, Area
* Demographics, Employment
* Built environment/accessibility measures: Density, Diversity, Design, Transit, Destination accessibility

## Logan non-motorized trail count data

This dataset includes information on hourly counts of non-motorized (walking and bicycling) traffic at two specific locations in/near Logan, UT. Data are available for two infrared counters between June 2017 and February 2020. These data were obtained from the Cache County active transportation and trails planner. They also include data on air quality and weather information. 

**Download the trail-volumes-air-quality data**
* **RDS format: https://raw.github.com/saileshacharya1/trail-volumes-air-quality/main/online-repository/data/intermediate/main_data.rds**

These data were used in the following journal article. See the article for descriptions of the dataset's variables. 
* Acharya, S., & Singleton, P. A. (2022). Associations of inclement weather and poor air quality with non-motorized trail volumes. _Transportation Research Part D: Transport and Environment, 109_, 103337. https://doi.org/10.1016/j.trd.2022.103337

## Swissmetro data

This dataset is the result of a stated-preference mode choice survey of train and car travelers in Switzerland in 1998. The survey examined the potential impacts of a new proposed technology -- the [Swissmetro](https://en.wikipedia.org/wiki/Swissmetro), a high-speed train traveling via maglev and vacuum -- on mode choices for inter-city travel. Although there are multiple responses per person (due to the stated preference nature of the dataset), we will treat this as a cross-sectional dataset with independent observations (ignoring any within-person correlated errors).

**Download the Swissmetro dataset (smdata)**
* **Tab-separated-value format: http://transp-or.epfl.ch/data/swissmetro.dat**

See the [data description](https://transp-or.epfl.ch/documents/technicalReports/CS_SwissmetroDescription.pdf) for more details about each column (some have been slightly simplified):

* **Mode choice**: chosen mode (CHOICE) with alternatives train (1), Swissmetro (2), or car (3).
* **Survey info**: respondent identifier (ID), survey location (SURVEY), population group (GROUP), survey type (SP).
* **Personal characteristics** (non-varying IVs): age (AGE), gender (MALE), income (INCOME), annual rail/bus pass (GA).
* **Trip+traveler characteristics** (non-varying IVs): trip purpose (PURPOSE), ticket class (FIRST), ticket type (TICKET), who pays ticket (WHO), luggage (LUGGAGE), trip origin (ORIGIN), trip destination (DEST).
* **Trip+mode characteristics** (varying IVs, one for each mode: TRAIN_, _CAR_, _SM_): availability (AV), travel time in minutes (TT), cost in Swiss Francs CHF (CO), headway time between departures in minutes (HE) only for train and Swissmetro, seat configuration (SEATS) only for Swissmetro.

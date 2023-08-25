# Transportation datasets

## Utah Smart Location Database data 

This dataset includes information on the built environment and transportation accessibility characteristics of every US Census block group in Utah. Data were provided by the U.S. Environmental Protection Agency through their [Smart Location Database](https://www.epa.gov/smartgrowth/smart-location-mapping#SLD) in 2021. Get the Smart Location Database for Utah (sld_utah) [here](EPA_SLD_Utah) in CSV (data only), Rdata (data only), RDS (spatial), and Shapefile formats. 

**Download the Smart Location Database for Utah (sld_utah):**
* **CSV (data only) format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/EPA_SLD_Utah/sld_utah.csv**
* **RData (data only) format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/EPA_SLD_Utah/sld_utah.Rdata**
* **RDS (spatial) format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/EPA_SLD_Utah/sld_utah.rds**

Each row is a Census block group and contains a variety of information. Specific column names are described in the [SLD User Guide](https://www.epa.gov/sites/default/files/2021-06/documents/epa_sld_3.0_technicaldocumentationuserguide_may2021.pdf): 
* Administrative, CBSA-wide statistics, Area
* Demographics, Employment
* Built environment/accessibility measures: Density, Diversity, Design, Transit, Destination accessibility

## Bicycle safety at roundabouts survey data

This dataset comes from a research project investigating bicycling and roundabouts, specifically bicyclists’ safety perceptions of roundabouts, and bicyclists’ preferences for various roundabout elements. Survey data was collected from US bicyclists in 2020. Each row is a survey response from a single person. The meaning of various column names can be taken from the [survey questions documents found here](https://github.com/singletonpa/bicycle-safety-roundabouts/tree/main/Data/Survey). More information can be found at this project's [GitHub page](https://github.com/singletonpa/bicycle-safety-roundabouts/).  

**Download the bicycle safety roundabouts data (dat3):**
* **CSV format: https://raw.github.com/singletonpa/bicycle-safety-roundabouts/main/Data/Survey/dat3.csv**
* **RDS format: https://raw.github.com/singletonpa/bicycle-safety-roundabouts/main/Data/Survey/dat3.rds**

These data were used in the following journal articles: 
* Poudel, N., & Singleton P. A. (2021). Bicycle safety at roundabouts: A systematic literature review. _Transport Reviews, 41_(5), 1877207. https://doi.org/10.1080/01441647.2021.1877207
* Poudel, N., & Singleton, P. A. (2022). Preferences for roundabout attributes among US bicyclists: A discrete choice experiment. _Transportation Research Part A: Policy and Practice, 155_, 316-329. https://doi.org/10.1016/j.tra.2021.11.023
* Singleton, P. A. & Poudel, N. (2023). Bicycling comfort at roundabouts: Effects of design and situational factors. _Transportation Research Part F: Traffic Psychology and Behaviour, 94_, 227-242. https://doi.org/10.1016/j.trf.2023.02.008

## Logan non-motorized trail count data

This dataset includes information on hourly counts of non-motorized (walking and bicycling) traffic at two specific locations in/near Logan, UT. Data are available for two infrared counters between June 2017 and February 2020. These data were obtained from the Cache County active transportation and trails planner. They also include data on air quality and weather information. More information can be found at this project's [GitHub page](https://github.com/saileshacharya1/trail-volumes-air-quality/). 

**Download the trail-volumes-air-quality data (main_data):**
* **RDS format: https://raw.github.com/saileshacharya1/trail-volumes-air-quality/main/online-repository/data/intermediate/main_data.rds**

These data were used in the following journal article. See the article for descriptions of the dataset's variables. 
* Acharya, S., & Singleton, P. A. (2022). Associations of inclement weather and poor air quality with non-motorized trail volumes. _Transportation Research Part D: Transport and Environment, 109_, 103337. https://doi.org/10.1016/j.trd.2022.103337

## Cache County multimodal traffic volumes data

This data comes from a research project investigating the impacts of air quality and weather on multimodal traffic volumes (pedestrian and motor vehicle volumes) in the same location (sites around Cache County, UT). The data include daily counts of motor vehicle volumes at 6 [count stations](https://www.arcgis.com/home/item.html?id=d8d3476ad6c946499c9823ae6bf2c4c2), daily estimates of pedestrian crossing volumes at 42 [traffic signals](https://udottraffic.utah.gov/atspm/), and information about daily weather and air quality, for 2018 and 2019. 

**Download the various datasets in RDS format:**
* **Pedestrian volumes, long format (PEDESTRIAN_LONG): https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Traffic_AQ/PEDESTRIAN_LONG.RDS**
* **Pedestrian volumes, wide format (PEDESTRIAN_WIDE): https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Traffic_AQ/PEDESTRIAN_WIDE.RDS**
* **Motor vehicle traffic volumes (POOLED_TRAFFIC): https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Traffic_AQ/POOLED_TRAFFIC.RDS**
* **Weather data (CACHE_WEATHER): https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Traffic_AQ/CACHE_WEATHER.RDS**
* **Air quality data (CACHE_AIR_QUALITY): https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Traffic_AQ/CACHE_AIR_QUALITY.RDS**

## Portland commuting survey data

This dataset consists of the results of a survey of ~700 commuters in the Portland, Oregon, area. The survey was a 30-minute online questionnaire conducted from October to December, 2016. Participates were recruited via email at their place of work. Respondents provided detailed information about their personal and transportation characteristics, their home and job locations, and their most recent commute trip from home to work, including answering questions about their chosen mode, how much their found their commute to be a good use of time, and how much they liked their commute. To these data were added weather information from nearby weather stations. The data were also post-processed to obtain estimated travel times and costs for all commute modes they considered using.

**Download the Portland commuting dataset (pdxcommute):**
* **CSV format, wide format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Portland_commute/pdxcommute_wide.csv**
* **RDS format, wide format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Portland_commute/pdxcommute_wide.rds**
* **CSV format, long format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Portland_commute/pdxcommute_long.csv**
* **RDS format, long format: https://raw.github.com/singletonpa/usu-course-transport-data-safety/main/Data/Portland_commute/pdxcommute_long.rds**

The dataset includes the following types of variables: 
* _Mode choice_: full name (CMODE6), short name (CMODE5), abbreviation (MC).
* _Personal characteristics_: age (AGE, AGE2), race/ethnicity (RACE), gender (GEND), educational attainment (EDUC), student status (STUD), household size (HHSIZE), # HH members employed (HHMEMEMP), # HH members in school (HHMEMSTU), # HH members children (HHMEML16), # HH members older adults (HHMEM65P), household income (HHINC), disability status (DISAB), driver license (DLIC), # HH bicycles (HHVEHBIKE), # HH motor vehicles (HHVEHAUTO), transit pass (TPASS), car-share member (VSHMEMAUTO), bike-share member (VSHMEMBIKE), housing type (HTYPE), housing tenure (HTEN), # years in current residence (HDUR), self-employed (WSELF), # days worked / week (WDAYS1), work schedule flexibility (WSFLEX), satisfaction with typical commute (TYPSAT), satisfaction with typical commute travel time (TYPSATTT), ideal travel time (IDEALTT), would prefer to teleport than to commute (TPORT).
* _Weather characteristics_: maximum temperature in *F (DAYTempMax), minimum temperature (DAYTempMin), temperature below freezing (DAYTempFrz), temperature deviation from average (DATTempAvgDev), rainy weather (DAYWeatherRAIN), misty weather (DAYWeatherIMIST), foggy weather (DAYWeatherFOG), snowy weather (DAYWeatherSNOW), precipitation in inches (DAYPrecip), any precipitation (DAYPrecipTrace), precipitation > 0.10 in (DAYPrecipTenth), precipitation > 0.25 in (DAYPrecipQuart), precipitation > 0.50 in (DAYPrecipHalf).
* _Mode-specific variables_ (one for each mode: _W, _B, _P, _D, _T): if mode was an available option (AV), distance in miles (GDIST), travel time in minutes (GTT), cost in dollars (GCO), usefulness of commute (TAUSE3), commute liking (TELIKE3).

Different versions of this dataset were used in the following publications:
* Humagain, P., De Vos, J., & Singleton, P. A. (2021). Analyzing travel captivity by measuring the gap in travel satisfaction between chosen and alternative commute modes. _Transportation Research Part D: Transport and Environment, 97_, 102965. https://doi.org/10.1016/j.trd.2021.102965
* Humagain, P., & Singleton, P. A. (2020). Investigating travel time satisfaction and actual versus ideal commute times: A path analysis approach. _Journal of Transport & Health, 16_, 100829. https://doi.org/10.1016/j.jth.2020.100829
* Humagain, P., & Singleton, P. A. (2020). Would you rather teleport or spend some time commuting? Investigating individuals’ teleportation preferences. _Transportation Research Part F: Traffic Psychology and Behaviour, 74_, 458-470. https://doi.org/10.1016/j.trf.2020.09.010
* Humagain, P., & Singleton, P. A. (2021). Exploring satisfaction with travel time profiles towards understanding intrinsic utilities of travel time. _Travel Behaviour and Society, 24_, 22-33. https://doi.org/10.1016/j.tbs.2021.02.001
* Poudel, N., & Singleton, P. A. (2022). Analyzing simple work time and commute time tradeoffs for insights into components of the value of travel time savings. _Travel Behaviour and Society, 28_, 330-337. https://doi.org/10.1016/j.tbs.2022.04.011
* Runa, F., & Singleton, P. A. (2021). What factors are associated with travel liking? Evidence from commuters in Portland, Oregon. _Travel Behaviour and Society, 23_, 207-215. https://doi.org/10.1016/j.tbs.2021.01.004
* Singleton, P. A. (2017). _Exploring the positive utility of travel and mode choice_ (doctoral dissertation). Portland State University, Portland, OR. http://doi.org/10.15760/etd.3447
* Singleton, P. A. (2017). _Exploring the positive utility of travel and mode choice_ (NITC-DIS-1005). National Institute for Transportation and Communities. http://nitc.trec.pdx.edu/research/project/1005/
* Singleton, P. A. (2018). How useful is travel-based multitasking? Evidence from Portland, Oregon, commuters. _Transportation Research Record: Journal of the Transportation Research Board, 2672_(50), 11–22. https://doi.org/10.1177/0361198118776151
* Singleton, P. A. (2019). Multimodal travel-based multitasking during the commute: Who does what? _International Journal of Sustainable Transportation, 14_(2), 150–162. https://doi.org/10.1080/15568318.2018.1536237
* Singleton, P. A. (2019). Validating the Satisfaction with Travel Scale as a measure of hedonic subjective well-being for commuting in a U.S. city. _Transportation Research Part F: Psychology and Behaviour, 60_, 399–414. https://doi.org/10.1016/j.trf.2018.10.029
* Singleton, P. A. (2019). Walking (and cycling) to well-being: Modal and other determinants of subjective well-being during the commute. _Travel Behaviour and Society, 16_, 249–261. https://doi.org/10.1016/j.tbs.2018.02.005
* Singleton, P. A. (2020). Exploring the Positive Utility of Travel and mode choice: Subjective well-being and travel-based multitasking during the commute. In K. G. Goulias & A. W. Davis (Eds.), _Mapping the travel behavior genome_ (pp. 259–277). Cambridge, MA: Elsevier. https://doi.org/10.1016/B978-0-12-817340-4.00014-0
* Singleton, P. A., & Clifton, K. J. (2021). Towards measures of affective and eudaimonic subjective well-being in the travel domain. _Transportation, 48_(1), 303-336. https://doi.org/10.1007/s11116-019-10055-1

## Swissmetro data

This dataset is the result of a stated-preference mode choice survey of train and car travelers in Switzerland in 1998. The survey examined the potential impacts of a new proposed technology -- the [Swissmetro](https://en.wikipedia.org/wiki/Swissmetro), a high-speed train traveling via maglev and vacuum -- on mode choices for inter-city travel. Although there are multiple responses per person (due to the stated preference nature of the dataset), we will treat this as a cross-sectional dataset with independent observations (ignoring any within-person correlated errors).

**Download the Swissmetro dataset (smdata):**
* **Tab-separated-value format: http://transp-or.epfl.ch/data/swissmetro.dat**

See the [data description](https://transp-or.epfl.ch/documents/technicalReports/CS_SwissmetroDescription.pdf) for more details about each column (some have been slightly simplified):

* *Mode choice*: chosen mode (CHOICE) with alternatives train (1), Swissmetro (2), or car (3).
* *Survey info*: respondent identifier (ID), survey location (SURVEY), population group (GROUP), survey type (SP).
* *Personal characteristics* (non-varying IVs): age (AGE), gender (MALE), income (INCOME), annual rail/bus pass (GA).
* *Trip+traveler characteristics* (non-varying IVs): trip purpose (PURPOSE), ticket class (FIRST), ticket type (TICKET), who pays ticket (WHO), luggage (LUGGAGE), trip origin (ORIGIN), trip destination (DEST).
* *Trip+mode characteristics* (varying IVs, one for each mode: TRAIN_, _CAR_, _SM_): availability (AV), travel time in minutes (TT), cost in Swiss Francs CHF (CO), headway time between departures in minutes (HE) only for train and Swissmetro, seat configuration (SEATS) only for Swissmetro.

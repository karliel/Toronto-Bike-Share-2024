# Toronto Bike Share Analysis (2024)

## Introduction
An SQL analysis of bike share ridership data in Toronto between January and September 2024, combined with weather information, to explore patterns in usage, peak hours, membership types, and route popularity.  
This project was created as part of my transition into data analytics, focusing on demonstrating strong fundamentals in SQL and analytical reasoning.  


## Project Overview
The goal of this project is to understand:  
- Differences between weekday and weekend bike share usage  
- Differences between annual members and casual members bike share usage 
- Time-of-day usage  
- Popular stations, round-trips and one-way routes 
- The impacts of weather on bike share usage
- Prevalence of bike share trip errors

This analysis demonstrates SQL-based data manipulation, aggregation, window functions, and basic data cleaning.  
The analytical workflow and insights are explained in [QUESTIONS_AND_ANSWERS.md](QUESTIONS_AND_ANSWERS.md), with all SQL queries available in the `scripts/` directory.

## Data Sources
Due to GitHub file size limits, raw bike share ridership and weather dataset are not included. Cleaned, sampled subsets of the data are provided for reference. The full analysis was performed on the complete data.  

- **Toronto Bike Share Ridership Data January to September 2024 - Toronto Open Data**  
[Toronto Open Data](https://open.toronto.ca/dataset/bike-share-toronto-ridership-data/)  

- **Toronto Daily Weather Data Report 2024 Subset - Environment Canada**  
[toronto_weather_2024.csv](data/toronto_weather_2024.csv)

- **Sampled Toronto Bike Share Ridership Data 2024 Subset**  
[bike_share_sample.csv](data/bike_share_sample.csv)

## Tools and Skills Used
- **SQL** : data cleaning, aggregation, filtering, CTEs, window functions
- **Data analysis** : exploratory data analysis (EDA), feature engineering, and pattern identification

## Project Structure
- [README.md](README.md) : project overview and documentation
- [QUESTIONS_AND_ANSWERS.md](QUESTIONS_AND_ANSWERS.md) : key analytical questions, findings, and interpretations
- `data/` : contains source datasets:
    - `bike_share_sample.csv` : Toronto bike share ridership sample data (Jan–Sep 2024)
    - `toronto_weather_data_2024.csv` : Toronto temperature and precipitation data (2024)
- `scripts/` : contains SQL scripts used for data preparation and analysis:
    - `data_cleaning.sql` : data cleaning and feature engineering
    - `analysis.sql` : queries for analysis supporting the findings in QUESTIONS_AND_ANSWERS.md

## Key Findings
- Bike share usage in Toronto 2024 was predominantly weekday-driven and commute-oriented, with clear morning and evening peak hours, while weekend usage reflected more leisure-oriented behaviour with fewer but longer trips
- Casual members accounted for the majority of ridership and tended to take longer, discretionary trips, while annual members exhibited shorter, more consistent trips concentrated on weekdays, indicating routine commuter use
- Usage was highest on warm, dry days and declined steadily with colder temperatures and increased precipitation, with weather impacted more pronounced among casual riders
- Error trips were concentrated during weekday rush hours and at high-traffic downtown and transit-adjacent stations, suggesting that operational friction was primarily driven by usage intensity rather than isolated station issues

## Limitations
- Datasets from Toronto Open Data only cover January to September 2024 and exclude the data of late fall and winter months. This may underrepresent extreme cold weather usage patterns, and limit conclusions about full-year ridership behaviour.
- User type data are missing in the dataset of bike share January 2024, such limited the depth of the analysis  
- Bias may occur in the analysis of error trips by filtering trips with duration under 1 minute. This filtering approach may help identify operational issues, but also exclude some valid but atypical trips
- Bias may also occur when trip purpose were inferred in this analysis. Commute- and leisure-oriented behaviours were assumed from temporal patterns, trip durations, and route characteristics rather than directly observed or recorded trip purposes, therefore, interpretations of rider usage and motivations may not be fully captured
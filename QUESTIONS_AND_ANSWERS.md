## Questions and Answers
Author: Karlie Leung  
Email: karlieleung21@gmail.com  
Linkedin: https://www.linkedin.com/in/karlie-leung-/  

An SQL analysis of bike share ridership data in Toronto between January and September 2024, combined with weather information, to explore patterns in usage, peak hours, membership types, and route popularity.  

## Data Preparation Highlights
Supporting SQL queries can be found in [data_cleaning.sql](scripts/data_cleaning.sql)  

- Standardized column names  
- Reviewed raw data to identify missing or invalid values (e.g. the string 'NULL' instead of actual NULL values), and preserved them using standardized labels to maintain data integrity and highlight data quality gaps
- Reviewed station IDs and station names to identify stations with same the ID but multiple names. Station IDs, rather than station names, were used in the analysis to ensure accuracy. Raw station names were preserved to avoid loss of information  
- Created analytical features (day_of_week, day_type, time_period, temp_range, precipitation classification) for behavioural comparisons  
- Created a main view with trip-duration-based outlier thresholds (<1 minute and >24 hours) to support accurate behavioral analysis, while enabling separate analysis of stations with recording anomalies  

## Key Questions and Findings
Supporting SQL queries can be found in [analysis.sql](scripts/analysis.sql)  
Each question focuses on a distinct analytical angle (e.g. temporal, behavioral, spatial, and environmental) to avoid overlapping insights, while building a cohesive understanding of bike share usage.

### How does trip volume differ between weekdays and weekends?
- Trip volumes were consistently higher on weekdays (73.3%) than weekends (26.7%). Even after normalizing by the number of days, weekdays showed a higher average number of trips per day than weekends (19940 trips per day on weekdays vs 18274 trips per day at weekends)
- Weekend trips occurred less frequently but tended to have slightly longer average durations than weekday trips (15.1 minutes on weekdays vs 18.6 minutes at weekends)
- Weekday usage showed significant morning (8am) and evening (4-7pm) peaks, while weekends were more evenly distributed across the afternoon (2-6pm)
- Morning bike share usage (7-9am) was significantly higher on the weekdays than the weekends. Specifically, trips occurring during 7-9am on Tuesdays, Wednesdays, and Thursdays were significantly higher than the rest of the weeks (> 17.5% of the total trips per day)

-> Results suggested that weekday trips accounted for the majority of the bike share ridership, and primarily driven by commute-oriented behaviour. This resulted in stronger and more consistent demand for bike share. Higher percentages of morning usage on Tuesdays, Wednesdays, and Thursdays also indicated the higher demand of bike share on common 'in office' days.  
In contrast, weekend trips reflected more for leisure-oriented behaviour, with fewer but longer rides, and less pronounced time-of-day concentration.

### How do usage patterns differ between annual and casual members?
- Casual members accounted for the majority of total trips (88.7%), while annual member contributed fewer trips (11.3%)
- Casual members tended to take longer rides on average (16.8 minutes), especially at weekends (19.5 minutes). In contrast, average trip durations of annual members were significantly shorter (11.3 minutes), regardless of weekdays or weekends
- Both annual and casual members used more bike share on weekdays. Annual members showed a strong weekday orientation (77.3% weekday vs 22.6% weekend). Casual members had a higher weekend share (27.6%) than annual members

-> Results suggested that bike share ridership was primarily used by casual members across both weekdays and weekends. Casual members' longer average trip durations suggesed more leisure-oriented or flexible travel patterns, especially at the weekends.  
In contrast, annual members appeared more to be regular commuters, with more frequent and consistent short trips concentrated on weekdays, aligning with routine, utilitarian use such as commuting.

### How do weekday time-of-day usage patterns differ between annual and casual members?
- The majority of bike share was accounted for by casual members across all weekday time periods. Casual members represented over 86% of trips in each time periods, including morning rush hours(7-9am), evening rush hours(4-6pm), and non-peak hours
- Both annual and casual members showed similar time-of-day distributions, with most usage occurred during non-peak hours, then evening rush hours, and lastly, morning rush hours
- Average trip durations of casual members were consistently longer than annual members, regardless of the time period of the day

-> Results suggested weekday time-of-day did not significantly differentiate between annual and casual members. Instead, the key distinction between annual and casual members appeared to lie in the trip purpose, where annual members tended to use bike share for shorter, task-oriented trips, and casual members tended to take longer, discretionary trips throughout the day.

### Which are the most frequently used stations and routes (round-trips & one-way routes)?
- **Frequently used stations** : The most frequently used start and end stations largely overlapped, with most in downtown core and financial district, selected examples of the top 5 included Union Station, York St / Queens Quay W, Bay St / College St (East Side).  
-> The overlap of the start and end stations suggested these stations functioned as key hubs for both trip origins and destinations, and possibly key transfer stations of different transportation modes within the bike share network.

- **Round-trips** : The most frequently used round-trips were highly concentrated in parks, and along the waterfront trails, with Tommy Thompson Park (Leslie Street Spit) appeared as a top-five route across the week, followed by Humber Bay Shores Park / Marine Parade Dr. Most of these round-trips occurred predominantly at weekends with significantly long average trip durations, ranging from 45 to 100 minutes  
-> Round-trip routes appeared to be more recreational, where riders returned bikes to the same station after long leisure rides.

- **One-way trips** : The most frequently used one-way routes primarily connect downtown core and transit hubs. Top 5 one-way routes were all Front St W / Blue Jays Way or King St W / Portland St <-> Union Station or King St W / Bay St on Tuesdays, Wednesdays, and Thursdays  
-> One-way routes appeared to be repeatedly used on weekdays, consistent with point-to-point commute behavior.


### How do weather conditions (temperature vs precipitation) influence usage patterns?
- As temperature decreased, both trip volume and duration appeared to decline. 69% of all trips occurred on warm days (15-25°C), making the warm weather the most favourable conditions for cycling. Trip volumes decreased steadily when the temperature dropped, with cold days (<5°C) contributing 12% of the trips, and significantly shorter average trip durations (11.6 minutes). While hot days (>25°C) represented a small proportion of trips, average trip durations were the longest (15 minutes) among all the temperature ranges
- As total precipitation increased, both trip volume and duration appeared to decrease. Approximately two-thirds of all trips occurred on days with no rain, followed by days with light precipitation, then moderate to heavy precipitation. Average trip durations also reduced along the increased precipitation levels, indicating that riders may shift toward shorter, more utilitarian trips when weather conditions worsen
- Combining the effects of temperature and precipitation, warm, dry days showed the highest bike share usage, with a large proportion of total trips and relatively long trip durations. Within the same temperature range, trip volumes dropped noticeably as precipitation increased, indicating that precipitation reduced the likelihood of bike share ridership even under favourable warmer conditions
- Cold and rainy conditions consistently showed the lowest trip volumes and shortest average durations suggesting that adverse weather strongly discourages cycling
- Trip volume decreased with higher precipitation for both annual and casual members, but the drop was more pronounced for casual members
- Temperature had a significant impact on casual members' ridership, where their trips peaked in hot and warm weather, with both average trip durations more than 17.5 minutes. Meanwhile, annual members’ usage remained fairly consistent across temperatures, ranging from 10.5 to 11.6 minutes

-> Results suggested bike share ridership was the highest under warm temperature and dry conditions, while both extreme temperature and increased precipitations significantly suppressed the demand for bike share. This highlighted that weather remained an important factor for planning and demand forecasting in bike share ridership, and potentially, further development of bike share programme enhancements.

### Prevalence of Bike trip errors (trips with durations <1 minute)
- Bike trip errors accounted for 15% of total trips
- Both start and end stations with bike trip errors were concentrated at high-traffic, downtown, and campus- and transit-adjacent stations, such as College Park, Huron St/ Harbord St and Union Station. This suggested that error trips could primarily be driven by high usage intensity, time pressure, and operational frictions
- Besides core downtown areas, error trips were also frequently observed at recreational locations when ending the trips, such as Tommy Thompson Park. This suggested that bike testing behaviours before long recreational rides and dock availability may also contribute to these errors
- No records showed error trips starting and ending at the same station, indicating that failed unlock signals were less likely to be a main trip errors in bike share 2024
- Error trips occured significantly more at 8-9am and 4-6pm, from Tuesday to Wednesday, which matched with the weekday commute rush hours, indicating that the high usage volume and congestion increased the likelihood of departing and docking errors
- Occurrence of error trips gradually increased from January to September 2024, peaked in May and June with both months recorded more than 1350 errors. Increasing error trips reflected potential increases of seasonal bike share usage, first-time users, and system expansion throughout the time

-> Results suggested error trips appeared to reflect system usage intensity and operational friction rather than isolated station-specific issues, supported by the high occurrence of trip errors observed on weekdays commute rush hours usage. Although the number of error trips increased over time, this trend likely reflected overall ridership growth rather than system performance deterioration. More importantly, these error patterns may help identify locations or periods where maintenance, bike availability, or user guidance could be improved.
-- Create a view for bike share trips
CREATE OR ALTER VIEW bike_share_view AS
SELECT [trip_id]
      ,CAST(start_time AS DATE) AS trip_date
	  ,[start_time]
      ,[start_station_id]
      ,[start_station_name]
      ,[end_time]
      ,[end_station_id]
	  ,[end_station_name]
	  ,[trip_duration] / 60.0 AS trip_duration_min
      ,DATENAME(WEEKDAY, start_time) AS day_of_week
	  ,CASE 
		WHEN DATENAME(WEEKDAY, start_time) IN ('Saturday', 'Sunday')
		THEN 1 
		ELSE 0
	   END AS is_weekend
	  ,DATEPART(HOUR, start_time) AS start_hour
	  ,CASE 
		WHEN DATEPART(HOUR, start_Time) BETWEEN 7 AND 9 THEN 'morning_rush'
		WHEN DATEPART(HOUR, start_Time) BETWEEN 16 AND 18 THEN 'evening_rush'
		ELSE 'non_peak'
	   END AS time_period
	  ,[bike_id]
      ,[user_type]
      ,[model]
FROM [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
WHERE trip_duration BETWEEN 60 AND 86400
GO

-- Q1: Compare trip volume between weekdays and weekends
SELECT 
    CASE 
        WHEN is_weekend = 1 
		THEN 'Weekend' 
		ELSE 'Weekday' 
	END AS day_type
    ,COUNT(*) AS trip_count
    ,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS trip_share_percentage
FROM bike_share_view
GROUP BY is_weekend
ORDER BY day_type;

-- Q1: Average number of trips per day for weekdays vs weekends
SELECT
	CASE
		WHEN is_weekend = 1 
		THEN 'Weekend' 
		ELSE 'Weekday' 
	END AS day_type
	,COUNT(*) AS trip_count
	,COUNT(DISTINCT trip_date) AS num_days
	,COUNT(*) / COUNT(DISTINCT trip_date) AS avg_trip_per_day
FROM bike_share_view
GROUP BY is_weekend
ORDER BY day_type;

-- Q1: Top 5 start hours for weekdays vs weekends
WITH hour_rank AS(
	SELECT
		CASE
			WHEN is_weekend = 1 
			THEN 'Weekend' 
			ELSE 'Weekday' 
		END AS day_type
		,COUNT(*) AS trip_count
		,start_hour
		,RANK() OVER(PARTITION BY is_weekend ORDER BY COUNT(*) DESC) AS ranked_hour
	FROM bike_share_view
	GROUP BY is_weekend, start_hour
)
SELECT
	day_type
	,trip_count
	,start_hour
FROM hour_rank
WHERE ranked_hour <= 5
ORDER BY trip_count DESC;

-- Q1: Trip distribution by time period (morning rush, evening rush, non-peak) for each day of the week
SELECT 
		day_of_week
		,time_period
		,COUNT(*) AS trip_count,
		ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY day_of_week), 2) AS day_trip_ratio_percentage
FROM bike_share_view
GROUP BY day_of_week, time_period
ORDER BY day_of_week
         ,CASE time_period
             WHEN 'morning_rush' THEN 1
             WHEN 'evening_rush' THEN 2
             ELSE 3
         END;

-- Q2: Compare trip count and average duration between Annual and Casual members
SELECT 
	user_type
	,COUNT(*) AS trip_count
	,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS trip_share_percentage
FROM bike_share_view
WHERE start_time >= '2024-02-01'
GROUP BY user_type;

-- Q2: Weekday vs Weekend trip distribution by user type
SELECT 
	user_type
	,COUNT(*) AS trip_count
	,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY user_type), 2) AS member_trip_ratio
	,CASE
		WHEN is_weekend = 1 
		THEN 'Weekend' 
		ELSE 'Weekday' 
	 END AS day_type
FROM bike_share_view
WHERE start_time >= '2024-02-01'
GROUP BY user_type, is_weekend
ORDER BY user_type, day_type;

-- Q2: Weekday vs Weekend trip distribution by weekend indicator (is_weekend)
SELECT 
	user_type
	,COUNT(*) AS trip_count
	,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY is_weekend), 2) AS day_type_member_ratio
	,CASE
		WHEN is_weekend = 1 
		THEN 'Weekend' 
		ELSE 'Weekday' 
	 END AS day_type
FROM bike_share_view
WHERE start_time >= '2024-02-01'
GROUP BY user_type, is_weekend
ORDER BY user_type, day_type;

-- Q3: Within Annual vs Casual members, analyze weekday trips by time period
SELECT 
	user_type
	,time_period
	,COUNT(*) AS trip_count
	,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.00 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY user_type), 2) AS member_trip_ratio
FROM bike_share_view
WHERE Start_Time >= '2024-02-01' 
		AND is_weekend = 0
GROUP BY user_type, time_period
ORDER BY user_type
		,CASE time_period
			WHEN 'morning_rush' THEN 1
			WHEN 'evening_rush' THEN 2
			ELSE 3
		END;

-- Q3: Annual member VS Casual member, analyze weekday trips within time period
SELECT 
	user_type
	,time_period
	,COUNT(*) AS trip_count
	,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
	,ROUND(100.00 * COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY time_period), 2) AS member_trip_ratio
FROM bike_share_view
WHERE Start_Time >= '2024-02-01' 
		AND is_weekend = 0
GROUP BY user_type, time_period
ORDER BY user_type
		,CASE time_period
			WHEN 'morning_rush' THEN 1
			WHEN 'evening_rush' THEN 2
			ELSE 3
		END;

-- Q3: Top 5 start hours for weekday trips within Annual vs Casual members
WITH member_hour_rank AS (
	SELECT 
		user_type
		,start_hour
		,COUNT(*) AS trip_count
		,RANK() OVER(PARTITION BY user_type ORDER BY COUNT(*) DESC) AS ranked_hour
	FROM bike_share_view
	WHERE start_time >= '2024-02-01'
			AND is_weekend = 0
	GROUP BY user_type, start_hour
)
SELECT
	user_type
	,start_hour
	,trip_count
FROM member_hour_rank
WHERE ranked_hour <= 5
ORDER BY user_type, trip_count DESC;

-- Q4: Top 10 most popular start stations
SELECT TOP 10
    start_station_id
	,MIN(start_station_name) AS start_station
    ,COUNT(*) AS trip_count
FROM bike_share_view
GROUP BY start_station_id
ORDER BY trip_count DESC;

-- Q4: Top 10 most popular end stations
SELECT TOP 10
    end_station_id
	,MIN(end_station_name) AS end_station
    ,COUNT(*) AS trip_count
FROM bike_share_view
GROUP BY end_station_id
ORDER BY trip_count DESC;

-- Q4: Top 10 ranked round-trip routes
WITH ranked_round_trip AS(
	SELECT 
		day_of_week
		,start_station_id
		,MIN(start_station_name) AS start_station
		,end_station_id
		,MIN(end_station_name) AS end_station
		,COUNT(*) AS trip_count
		,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
		,RANK() OVER(ORDER BY COUNT(*) DESC) AS route_rank
	FROM bike_share_view
	WHERE start_station_id = end_station_id
	GROUP BY day_of_week, start_station_id, end_station_id
)
SELECT *
FROM ranked_round_trip
WHERE route_rank <= 10
ORDER BY route_rank;

-- Q4: Top 10 ranked one-way routes
WITH ranked_one_way AS(
	SELECT 
		day_of_week
		,start_station_id
		,MIN(start_station_name) AS start_station
		,end_station_id
		,MIN(end_station_name) AS end_station
		,COUNT(*) AS trip_count
		,ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
		,RANK() OVER(ORDER BY COUNT(*) DESC) AS route_rank
	FROM bike_share_view
	WHERE start_station_id <> end_station_id
	GROUP BY day_of_week, start_station_id, end_station_id
)
SELECT *
FROM ranked_one_way
WHERE route_rank <= 10
ORDER BY route_rank;

-- Create a daily bike-weather view by user type and bike model
CREATE OR ALTER VIEW bike_weather_daily_by_segment_view AS
WITH daily_bike_by_segment AS(
	SELECT
		CAST(start_time AS DATE) AS trip_date
		,user_type
		,model
		,COUNT(*) AS trip_count
		,ROUND(AVG(trip_duration_min),2) AS avg_duration_min
	FROM bike_share_view
	GROUP BY 
		CAST(start_time AS DATE)
		,user_type
		,model
	),
daily_weather AS(
	SELECT
		CAST(date_time AS DATE) AS weather_date
		,AVG(temp) AS avg_temp
		,SUM(precip) AS total_precip
    FROM toronto_weather_2024
    GROUP BY CAST(date_time AS DATE)
	)
SELECT
	b.trip_date
	,b.trip_count
	,b.avg_duration_min
	,b.user_type
	,b.model
	,w.avg_temp
	,w.total_precip
FROM daily_bike_by_segment b
INNER JOIN daily_weather w
	ON b.trip_date = w.weather_date;
GO

-- Q5: Trip volume and average duration by temperature range
SELECT 
	SUM(trip_count) AS total_trip
	,ROUND(AVG(avg_duration_min), 2) AS avg_trip_duration
	,ROUND(100.0 * SUM(trip_count) / SUM(SUM(trip_count)) OVER(), 2) AS trip_percentage
	,CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END AS temp_range
FROM bike_weather_daily_by_segment_view
GROUP BY 
	CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END
ORDER BY total_trip DESC;

-- Q5: Trip volume and average duration by precipitation level
SELECT 
	SUM(trip_count) AS total_trip
	,ROUND(AVG(avg_duration_min), 2) AS avg_trip_duration
	,ROUND(100.0 * SUM(trip_count) / SUM(SUM(trip_count)) OVER(), 2) AS trip_percentage
	,CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END AS precip_range
FROM bike_weather_daily_by_segment_view
GROUP BY 
	CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END
ORDER BY total_trip DESC;

-- Q5: Trip volume and average duration by both temperature and precipitation
SELECT 
	SUM(trip_count) AS total_trip
	,ROUND(AVG(avg_duration_min), 2) AS avg_trip_duration
	,CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END AS temp_range
	,CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END AS precip_range
FROM bike_weather_daily_by_segment_view
GROUP BY 
	CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END
	,CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END
ORDER BY total_trip DESC;

-- Q5: Average trip duration and count for Annual vs Casual members by precipitation
SELECT
	user_type
	,AVG(trip_count) AS avg_daily_trip
	,ROUND(AVG(avg_duration_min), 2) AS avg_trip_duration
	,CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END AS precip_range
FROM bike_weather_daily_by_segment_view
GROUP BY 
	user_type
	,CASE
        WHEN total_precip = 0 THEN 'Dry Conditions'
        WHEN total_precip BETWEEN 0.1 AND 5 THEN 'Light Precipitation'
        ELSE 'Moderate to Heavy Precipitation'
	END 
ORDER BY user_type, avg_daily_trip DESC;

-- Q5: Average trip duration and count for Annual vs Casual members by temperature
SELECT
	user_type
	,AVG(trip_count) AS avg_daily_trip
	,ROUND(AVG(avg_duration_min), 2) AS avg_trip_duration
	,CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END AS temp_range
FROM bike_weather_daily_by_segment_view
GROUP BY 
	user_type
	,CASE 
		WHEN avg_temp < 5 THEN 'Cold (<5°C)'
		WHEN avg_temp BETWEEN 5 AND 15 THEN 'Mild (5-15°C)'
		WHEN avg_temp BETWEEN 15 AND 25 THEN 'Warm (15-25°C)'
		ELSE 'Hot (>25°C)'
	END
ORDER BY user_type, avg_daily_trip DESC;

-- Create a raw bike data view for error analysis
CREATE OR ALTER VIEW bike_raw_view AS
SELECT [trip_id]
	  ,[start_time]
      ,[start_station_id]
      ,[start_station_name]
      ,[end_time]
      ,[end_station_id]
	  ,[end_station_name]
	  ,[trip_duration] / 60.0 AS trip_duration_min
	  ,[bike_id]
      ,[model]
	  ,[user_type]
FROM [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
GO

-- Q6: Overall bike trip error rate (trips with duration < 1 minute)
SELECT
    COUNT(*) AS error_trip_count
    ,(SELECT COUNT(*) FROM bike_raw_view) AS total_trip
    ,ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM bike_raw_view),2) AS error_rate
FROM bike_raw_view
WHERE trip_duration_min < 1;

-- Q6: Start stations with trip errors
SELECT
    start_station_id
	,MIN(start_station_name) AS start_station
	,COUNT(*) AS error_trip_count
FROM bike_raw_view
WHERE trip_duration_min < 1
GROUP BY start_station_id
ORDER BY error_trip_count DESC;

-- Q6: End stations with trip errors
SELECT
    end_station_id
	,MIN(end_station_name) AS end_station
	,COUNT(*) AS error_trip_count
FROM bike_raw_view
WHERE trip_duration_min < 1
GROUP BY end_station_id
ORDER BY error_trip_count DESC;

-- Q6: Trips starting and ending at the same station with errors
SELECT
    COUNT(*) AS error_trip_count
	,ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM bike_raw_view WHERE trip_duration_min < 1),2) AS error_rate
FROM bike_share_view
WHERE trip_duration_min < 1
  AND start_station_id = end_station_id;

-- Q6: Trip errors by hour of day
SELECT
    DATEPART(HOUR, start_time) AS start_hour
    ,COUNT(*) AS error_trip_count
FROM bike_raw_view
WHERE trip_duration_min < 1
GROUP BY DATEPART(HOUR, start_time)
ORDER BY error_trip_count DESC;

-- Q6: Trip errors by day of week
SELECT
    DATENAME(WEEKDAY, start_time) AS day_of_week
    ,COUNT(*) AS error_trip_count
FROM bike_raw_view
WHERE trip_duration_min < 1
GROUP BY DATENAME(WEEKDAY, start_time)
ORDER BY error_trip_count DESC;

-- Q6: Trip errors over time
SELECT
    YEAR(start_time) AS year
    ,MONTH(start_time) AS month
    ,COUNT(*) AS error_trip_count
FROM bike_raw_view
WHERE trip_duration_min < 1
GROUP BY
    YEAR(start_time),
    MONTH(start_time)
ORDER BY year, month;
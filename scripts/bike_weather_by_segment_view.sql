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
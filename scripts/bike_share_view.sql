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
		WHEN DATEPART(HOUR, Start_Time) BETWEEN 7 AND 9 THEN 'morning_rush'
		WHEN DATEPART(HOUR, Start_Time) BETWEEN 16 AND 18 THEN 'evening_rush'
		ELSE 'non_peak'
	   END AS time_period
	  ,[bike_id]
      ,[user_type]
      ,[model]
FROM [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
WHERE trip_duration BETWEEN 60 AND 86400
GO
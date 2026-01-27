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
FROM [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
GO
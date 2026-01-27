-- Join bike share tables
SELECT *
INTO dbo.Bike_Share_Ridership_2024_Jan_to_Sep
FROM(
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,NULL AS [Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-01]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-02]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-03]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-04]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-05]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-06]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-07]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-08]
UNION ALL
SELECT [Trip_Id]
      ,[Trip_Duration]
      ,[Start_Station_Id]
      ,[Start_Time]
      ,[Start_Station_Name]
      ,[End_Station_Id]
      ,[End_Time]
      ,[End_Station_Name]
      ,[Bike_Id]
      ,[User_Type]
      ,[Model]
FROM [bike_share].[dbo].[Bike share ridership 2024-09]
) t;

-- Standardize column names
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Trip_Id]', 'trip_id', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Trip_Duration]', 'trip_duration', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Start_Station_Id]', 'start_station_id', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Start_Time]', 'start_time', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Start_Station_Name]', 'start_station_name', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[End_Station_Id]', 'end_station_id', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[End_Time]', 'end_time', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[End_Station_Name]', 'end_station_name', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Bike_Id]', 'bike_id', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[User_Type]', 'user_type', 'COLUMN';
EXEC sp_rename 'dbo.[Bike_Share_Ridership_2024_Jan_to_Sep].[Model]', 'model', 'COLUMN';

-- Change string values 'NULL' to NULL values
UPDATE [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
SET start_station_name = NULL
WHERE LTRIM(RTRIM(start_station_name)) = 'NULL';

UPDATE [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
SET end_station_name = NULL
WHERE LTRIM(RTRIM(end_station_name)) = 'NULL';

UPDATE [bike_share].[dbo].[Bike_Share_Ridership_2024_Jan_to_Sep]
SET model = NULL
WHERE LTRIM(RTRIM(model)) = 'NULL';

-- Create weather tables
SELECT *
INTO [bike_share].dbo.toronto_weather_2024
FROM(
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_01-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_02-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_03-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_04-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_05-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_06-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_07-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_08-2024_P1H]
UNION ALL
SELECT
       [Date_Time_LST]
      ,[Temp_C]
      ,[Precip_Amount_mm]
  FROM [bike_share].[dbo].[en_climate_hourly_ON_6158359_09-2024_P1H]
)t;

-- Standardize column names
EXEC sp_rename 'dbo.toronto_weather_2024.Date_Time_LST', 'date_time', 'COLUMN';
EXEC sp_rename 'dbo.toronto_weather_2024.Temp_C', 'temp', 'COLUMN';
EXEC sp_rename 'dbo.toronto_weather_2024.Precip_Amount_mm', 'precip', 'COLUMN';
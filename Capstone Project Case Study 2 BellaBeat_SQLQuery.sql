SELECT * 
FROM CapstoneProject2BellaBeat..dailyActivity_merged

-- <count how many users in dailyactivity> -- 
SELECT COUNT(DISTINCT Id) AS Id_Total                           
FROM CapstoneProject2BellaBeat..dailyActivity_merged    
-- # 33

-- <count how many days in dailyactivity> --  
SELECT COUNT(DISTINCT ActivityDate) AS day_Total               
FROM CapstoneProject2BellaBeat..dailyActivity_merged    
-- # 31

SELECT *
FROM CapstoneProject2BellaBeat..dailyCalories_merged

-- <count how many users in dailyCalories> --
SELECT COUNT(DISTINCT Id) AS Id_Total                   
FROM CapstoneProject2BellaBeat..dailyCalories_merged    
-- # 33

SELECT *
FROM CapstoneProject2BellaBeat..dailyIntensities_merged

-- <count how many users in dailyintensities> --
SELECT COUNT(DISTINCT Id) AS Id_Total                   
FROM CapstoneProject2BellaBeat..dailyIntensities_merged 
-- # 33

SELECT *
FROM CapstoneProject2BellaBeat..dailySteps_merged

-- <count how many users in dailysteps> --
SELECT COUNT(DISTINCT Id) AS Id_Total                   
FROM CapstoneProject2BellaBeat..dailySteps_merged       
-- # 33

SELECT * 
FROM CapstoneProject2BellaBeat..sleepDay_merged

-- <count how many users in dailysteps>--
SELECT COUNT(DISTINCT Id) AS Id_Total                  
FROM CapstoneProject2BellaBeat..sleepDay_merged         
-- # 24

SELECT * 
FROM CapstoneProject2BellaBeat..weightLogInfo_merged

-- <count how many users in dailysteps> --
SELECT COUNT(DISTINCT Id) AS Id_Total                   
FROM CapstoneProject2BellaBeat..weightLogInfo_merged    
-- # 8

-- <Calcualte how many days for each user would be in the dailyActivity>
SELECT COUNT(DISTINCT activitydate) AS days_available   
FROM CapstoneProject2BellaBeat..dailyActivity_merged
GROUP BY Id; 
-- # 31  31  30  31  31  31  31  31  18  31  20  30  31   4  31  31  31  
--   31  31  31  30  28  29  26  31  26  31  31  19  31  31  29  31

-- <Finding the start date and end date of DailyActivity table>

SELECT MIN(ActivityDate) AS start_date, 
       MAX(ActivityDate) AS end_date 
FROM CapstoneProject2BellaBeat..dailyActivity_merged
-- # 2016-04-12 00:00:00.000	2016-05-12 00:00:00.000 # -- 

-- <Finding start date and end date of Sleepday table>
SELECT MIN(SleepDay) AS start_date, 
       MAX(SleepDay) AS end_date 
FROM CapstoneProject2BellaBeat..sleepDay_merged
-- # 2016-04-12 00:00:00.000	2016-05-12 00:00:00.000 # -- 

-- <Finding start date and end date of weightLogInfo table> 
SELECT MIN(Date) AS start_date, 
       MAX(Date) AS end_date 
FROM CapstoneProject2BellaBeat..weightLogInfo_merged
-- # 2016-04-12 06:47:11.000	2016-05-12 23:59:59.000 # -- 

-- <Find if any duplicated rows in Daily Activity table>
SELECT Id, ActivityDate 
FROM CapstoneProject2BellaBeat..dailyActivity_merged
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1
-- # No duplicated rows

-- <Find if any duplicated rows in SleepDay table>
SELECT * 
FROM CapstoneProject2BellaBeat..sleepDay_merged
GROUP BY Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
HAVING COUNT(*) > 1
-- # FOUND 3 Duplicated Rows -- 
-- 4388161847	2016-05-05 00:00:00.000	1	471	495 --
-- 4702921684	2016-05-07 00:00:00.000	1	520	543 --
-- 8378563200	2016-04-25 00:00:00.000	1	388	402 --

DELETE 
FROM CapstoneProject2BellaBeat..sleepDay_merged
WHERE Id = 4388161847 
      AND TotalMinutesAsleep = 471 
	  AND TotalTimeInBed = 495

DELETE 
FROM CapstoneProject2BellaBeat..sleepDay_merged
WHERE Id = 4702921684 
      AND TotalMinutesAsleep = 520 
	  AND TotalTimeInBed = 543

DELETE 
FROM CapstoneProject2BellaBeat..sleepDay_merged
WHERE Id = 8378563200 
      AND TotalMinutesAsleep = 388 
	  AND TotalTimeInBed = 402

--INSERT INTO CapstoneProject2BellaBeat..sleepDay_merged(Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed)
--VALUES ('4388161847',	'2016-05-05 00:00:00.000',	'1',	'471',	'495'),
       --('4702921684',	'2016-05-07 00:00:00.000',	'1',	'520',	'543'),
	   --('8378563200',	'2016-04-25 00:00:00.000',	'1',	'388',	'402')

	   -- <Run the query again to check if duplicated rows exits> -- 
SELECT * 
FROM CapstoneProject2BellaBeat..sleepDay_merged
GROUP BY Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
HAVING COUNT(*) > 1
     -- # No duplicated rows --

 -- <Finding if any duplicated rows in WeightLogInfo table> --
SELECT * 
FROM CapstoneProject2BellaBeat..weightLogInfo_merged
GROUP BY Id, Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId
HAVING COUNT(*) > 1
     -- # No duplicated rows -- 

  -- <Double check to make sure that all IDs in DailyActivity have the same number of characters> -- 
  SELECT LEN(Id)
  FROM CapstoneProject2BellaBeat..dailyActivity_merged
    -- # All the IDs are 12 digits -- 

	-- <Double check to make sure that all IDs in SleepDay have the same number of characters> --
  SELECT LEN(Id)
  FROM CapstoneProject2BellaBeat..sleepDay_merged
    -- # There are 25 IDs are 11 digits -- 

  -- <Double check to make sure that all IDs in WeightLogInfo have the same number of characters> --
  SELECT LEN(Id)
  FROM CapstoneProject2BellaBeat..weightLogInfo_merged
  -- # There are 2 IDs are 11 digits -- 

  --SELECT * 
  --FROM CapstoneProject2BellaBeat..weightLogInfo_merged
  --WHERE LogId IN (
  --SELECT LogId
  --FROM CapstoneProject2BellaBeat..weightLogInfo_merged
  --GROUP BY LogId 
  --HAVING COUNT(LogId) > 1 
  --)
  --ORDER BY LogId

  -- < Fidning the 0 users in TotalSteps colum of Daily Activity table
  SELECT Id, COUNT(*) AS Days_ZeroSteps
  FROM CapstoneProject2BellaBeat..dailyActivity_merged
  WHERE TotalSteps = 0
  GROUP BY Id
  ORDER BY Days_ZeroSteps DESC
  --# 15 users had 0 step days -- 

  -- <Calculate how many total zero days> -- 
  SELECT SUM(Days_ZeroSteps) AS Total_Zero_Days
  FROM ( 
       SELECT COUNT(*) AS Days_ZeroSteps
       FROM CapstoneProject2BellaBeat..dailyActivity_merged
       WHERE TotalSteps = 0
	   ) AS ZeroTable
  -- # 77 days in total with 0 steps -- 

  -- <Finding the 0 steps in DailyActivity table and delete the rows> --
  SELECT *, ROUND((SedentaryMinutes / 60), 2) AS SedentaryHours
  FROM CapstoneProject2BellaBeat..dailyActivity_merged
  WHERE TotalSteps = 0

  DELETE FROM CapstoneProject2BellaBeat..dailyActivity_merged
  WHERE TotalSteps = 0

  # BellaBeat Data Analysis 

-- <Join tables of dailyactivity, dailycalories,dailysteps and dailyintensities> --

SELECT a.Id, 
       a.ActivityDate,
       s.StepTotal, 
	   a.TotalDistance, 
	   c.Calories, 
	   i.SedentaryMinutes, 
	   i.LightlyActiveMinutes, 
	   i.FairlyActiveMinutes, 
	   i.VeryActiveMinutes,
       i.SedentaryActiveDistance, 
	   i.LightActiveDistance, 
	   i.ModeratelyActiveDistance, 
	   i.VeryActiveDistance
FROM CapstoneProject2BellaBeat..dailyActivity_merged a
LEFT OUTER JOIN CapstoneProject2BellaBeat..dailyCalories_merged c
	ON a.Id = c.Id
	AND a.ActivityDate=c.ActivityDay
	AND a.Calories = c.Calories
LEFT OUTER JOIN CapstoneProject2BellaBeat..dailyIntensities_merged i
    ON a.Id = i.Id
	AND a.ActivityDate = i.ActivityDay
	AND a.FairlyActiveMinutes = i.FairlyActiveMinutes
	AND a.LightActiveDistance = i.LightActiveDistance
	AND a.ModeratelyActiveDistance = i.ModeratelyActiveDistance
	AND a.SedentaryActiveDistance = i.SedentaryActiveDistance
	AND a.VeryActiveMinutes = i.VeryActiveMinutes
LEFT OUTER JOIN CapstoneProject2BellaBeat..dailySteps_merged s
    ON a.Id = s.Id
	AND a.ActivityDate = s.ActivityDay
LEFT OUTER JOIN CapstoneProject2BellaBeat..sleepDay_merged sl
    ON a.Id = sl.Id
	AND a.ActivityDate = sl.SleepDay; 

-- Exporting the data into EXCEL and form a table to be called "dailyTable" and import this table into SQL 

SELECT ActivityDate, DATENAME(WEEKDAY, ActivityDate) AS DaysOfWeek
FROM CapstoneProject2BellaBeat..dailyTable;

SELECT ActivityDate, 
		CASE 
		      WHEN DaysOfWeek = 'Monday' THEN 'Weekday'
			  WHEN DaysOfWeek = 'Tuesday' THEN 'Weekday'
			  WHEN DaysOfWeek = 'Wednesday' THEN 'Weekday'
			  WHEN DaysOfWeek = 'Thursday' THEN 'Weekday'
			  WHEN DaysOfWeek = 'Friday' THEN 'Weekday'
	     ELSE 'Weekend'
		END AS Weekparts
FROM (SELECT ActivityDate, DATENAME(WEEKDAY, ActivityDate) AS DaysOfWeek
      FROM CapstoneProject2BellaBeat..dailyTable) AS Temp; 

	  ---< Average Steps, distance, and calories on weekday vs weekend>---
SELECT Weekparts, AVG(StepTotal) AS AvgSteps, AVG(TotalDistance) AS AvgDistance, AVG(Calories) AS AvgCalories
FROM 
		 (SELECT *, 
		        CASE 
				   WHEN DaysOfWeek = 'Monday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Tuesday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Wednesday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Thursday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Friday' THEN 'Weekday'
	               ELSE 'Weekend'
		        END AS Weekparts
          FROM 
		        (SELECT *, DATENAME(WEEKDAY, ActivityDate) AS DaysOfWeek 
                 FROM CapstoneProject2BellaBeat..dailyTable) AS Temp -- I have to use table dailyactivity_merge instead of dailytable because there is no step information in daily table
		  ) AS Temp2 
 GROUP BY Weekparts; 

 -- # Weekparts	AvgSteps	      AvgDistance	    AvgCalories
--    Weekend	8295.47085201794  5.98327353960864	2370.63228699552
--    Weekday	8327.728125	      5.97820311760588	2358.0421875


    ------< Min. and Max. Steps, distance, and calories on weekday vs weekend > --

SELECT Weekparts, 
	       MIN(StepTotal) AS MinSteps, 
		   MAX(StepTotal) AS MaxSteps, 
		   MIN(TotalDistance) AS MinDistance,
		   MAX(TotalDistance) AS MaxDistance,
		   MIN(Calories) AS MinCalories,
		   MAX(Calories) AS MaxCalories
FROM 
		 (SELECT *, 
		        CASE 
				   WHEN DaysOfWeek = 'Monday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Tuesday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Wednesday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Thursday' THEN 'Weekday'
			       WHEN DaysOfWeek = 'Friday' THEN 'Weekday'
	               ELSE 'Weekend'
		        END AS Weekparts
          FROM 
		        (SELECT *, DATENAME(WEEKDAY, ActivityDate) AS DaysOfWeek
                 FROM CapstoneProject2BellaBeat..dailyTable) AS Temp
		  ) AS Temp2 
 GROUP BY Weekparts; 

 --- # Weekparts	MinSteps	MaxSteps	MinDistance	         MaxDistance	    MinCalories	   MaxCalories
--     Weekend	    16	        36019	    0.00999999977648258	 28.0300006866455	1032	       4552
--     Weekday	    4	        23629	    0	                 20.6499996185303	52	           4900

 --- < Finding the average steps, distance and caloreis for each day of the week

 SELECT DATENAME(weekday, ActivityDate) AS DaysOfWeek, 
        AVG(StepTotal) AS AvgSteps, 
		AVG(TotalDistance) AS AvgDistance, 
		AVG(Calories) AS AvgCalories
 FROM CapstoneProject2BellaBeat..dailyTable
 GROUP BY DATENAME(weekday, ActivityDate) -- Here I can't use clause as GROUP BY DaysOfweek, I have to use GROUP BY DATENAME(weekday, ActivityDate)
 ORDER BY AvgSteps DESC  
 -- # DaysOfWeek	AvgSteps	      AvgDistance	      AvgCalories
--    Tuesday	 8949.28260869565	6.42391300596891	2440.97826086957
--    Saturday	 8946.62831858407	6.4246017735913	    2428.75221238938
--    Monday	 8488.21818181818	6.05772726569664	2385.61818181818
--    Thursday	 8185.3984962406	5.87142859966515	2274.43609022556
--    Wednesday	 8157.59712230216	5.92266186456725	2339.43165467626
--    Friday	 7820.64166666667	5.5754166523926	    2351.60833333333
--    Sunday	 7626.55454545455	5.52990908106281	2310.92727272727


-- < Finding average time spent on sleeping, average time on bed and average fall asleep time for each day of the week > --

 SELECT DATENAME(weekday, SleepDay) AS DaysOfWeek, 
        ROUND(AVG(TotalMinutesAsleep/60), 2) AS AvgHourAsleepTime, 
		ROUND(AVG(TotalTimeInBed/60), 2) AS AvgHourTimeInBed, 
		ROUND(AVG(TotalTimeInBed-TotalMinutesAsleep)/60, 2) AS AvgHourFallAsleepTime
 FROM CapstoneProject2BellaBeat..sleepDay_merged
 GROUP BY DATENAME(weekday, SleepDay) 
 ORDER BY AvgHourFallAsleepTime 
  
-- # DaysOfWeek	AvgHourAsleepTime	AvgHourTimeInBed	AvgHourFallAsleepTime
--    Thursday	   6.69	                   7.25	                0.56
--    Wednesday	   7.24	                   7.83	                0.59
--     Monday	   6.99	                   7.62	                0.63
--     Tuesday	   6.74	                   7.39	                0.65
--     Friday	   6.76	                   7.42	                0.66
--    Saturday	   6.98	                   7.66	                0.68
--     Sunday	   7.55	                   8.39	                0.85

-----------<join dailytable, sleepday and weightloginfo tables into one>--
SELECT * 
FROM CapstoneProject2BellaBeat..dailyTable AS dt
LEFT OUTER JOIN CapstoneProject2BellaBeat..sleepDay_merged AS sd
     ON dt.ActivityDate = sd.SleepDay
	 AND dt.Id = sd.Id
LEFT OUTER JOIN CapstoneProject2BellaBeat..weightLogInfo_merged AS wli
     ON sd.Id = wli.Id
	 AND sd.SleepDay = wli.Date
ORDER BY dt.Id, Date; 

---< Check to see manual reports and non-manual reports > 
SELECT IsManualReport, COUNT(DISTINCT Id)  
FROM CapstoneProject2BellaBeat..weightLogInfo_merged
GROUP BY IsManualReport

-- # IsManualReport	(No column name)
--         0	           3
--         1	           5

SELECT IsManualReport, COUNT(*) AS numberofreports, AVG(WeightPounds) AS avg_weight  
FROM CapstoneProject2BellaBeat..weightLogInfo_merged
GROUP BY IsManualReport

-- IsManualReport	numberofreports	       avg_weight
--        0	              26	         192.285490896195
--        1	              41	         137.584583644866


---< Finding the trend between active minutes and total fall asleep minutes> ---

WITH TEMP_ACTIVE AS (
	SELECT dt.Id, 
		   (LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS TotalActiveMinutes,
		   (TotalTimeInBed - TotalMinutesAsleep) AS TotalFallAsleepMinutes
    FROM CapstoneProject2BellaBeat..dailyTable dt
    LEFT OUTER JOIN CapstoneProject2BellaBeat..sleepDay_merged sd
        ON dt.Id = sd.Id
	    AND dt.ActivityDate = sd.SleepDay
		            )
SELECT Id,
       TotalActiveMinutes,
	   TotalFallAsleepMinutes
FROM TEMP_ACTIVE
WHERE TotalFallAsleepMinutes IS NOT NULL
ORDER BY Id

----<Finding the trend between average asleep minutes and average active minutes> ---

WITH TEMP_SLEEP AS (
	SELECT dt.Id, 
	   AVG(TotalMinutesAsleep) AS AvgAsleepMinutes,
       AVG(SedentaryMinutes + LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS AvgActiveMinutes
	FROM CapstoneProject2BellaBeat..dailyTable dt
     LEFT OUTER JOIN CapstoneProject2BellaBeat..sleepDay_merged sd
        ON dt.Id = sd.Id
	    AND dt.ActivityDate = sd.SleepDay
	GROUP BY dt.Id
	 )
SELECT Id, AvgAsleepMinutes, AvgActiveMinutes
FROM TEMP_SLEEP
WHERE AvgAsleepMinutes IS NOT NULL
ORDER BY Id

---<Finding the average sedentary, lightly active, fairly active and very active minutes for each user>---

SELECT Id, 
	   ROUND(AVG(SedentaryMinutes)/60, 2) AS AvgSedentaryhours,
	   ROUND(AVG(LightlyActiveMinutes)/60, 2) AS AvgLightlyActivehours,
	   ROUND(AVG(FairlyActiveMinutes)/60, 2) AS AvgFairlyActivehours,
	   ROUND(AVG(VeryActiveMinutes)/60, 2) AS AvgVeryActivehours
FROM CapstoneProject2BellaBeat..dailyTable
GROUP BY Id
ORDER BY Id



---<Finding the trend between total active minutes and total active distance>----

SELECT Id,
      (LightlyActiveMinutes + FairlyActiveMinutes + VeryActiveMinutes) AS TotalActiveMinutes,
      ROUND((LightActiveDistance + ModeratelyActiveDistance + VeryActiveDistance), 2) AS TotalActiveDistance
FROM CapstoneProject2BellaBeat..dailyTable


---<Finding the trend between average total steps, average Calories and average total active distance>---
SELECT Id,
      AVG(StepTotal) AS AvgTotalSteps, 
	  AVG(Calories) AS AvgCalories,
      ROUND(AVG(LightActiveDistance + ModeratelyActiveDistance + VeryActiveDistance), 2) AS AvgTotalActiveDistance
FROM CapstoneProject2BellaBeat..dailyTable
GROUP BY Id
ORDER BY Id



-- JOIN Hourly table and create the table-- 

CREATE TABLE #TEMP_HOURLYTABLE
(Id int, 
 ActivityHour datetime, 
 Calories float, 
 StepTotal int, 
 TotalIntensity float, 
 AverageIntensity float)

 INSERT INTO #TEMP_HOURLYTABLE
SELECT c.Id, 
	   c.ActivityHour, 
	   c.Calories, 
	   s.StepTotal, 
	   i.TotalIntensity, 
	   i.AverageIntensity
FROM CapstoneProject2BellaBeat..hourlyCalories_merged c
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlySteps_merged s
    ON c.Id = s.Id
	AND c.ActivityHour = s.ActivityHour
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlyIntensities_merged i
    ON c.Id = i.Id
	AND c.ActivityHour = i.ActivityHour

	SELECT *
	FROM #TEMP_HOURLYTABLE

--- < Count how many users participating in the hourly table> ---

WITH TEMP_HOURLYTABLE AS (
SELECT c.Id, 
	   c.ActivityHour, 
	   c.Calories, 
	   s.StepTotal, 
	   i.TotalIntensity, 
	   i.AverageIntensity
FROM CapstoneProject2BellaBeat..hourlyCalories_merged c
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlySteps_merged s
    ON c.Id = s.Id
	AND c.ActivityHour = s.ActivityHour
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlyIntensities_merged i
    ON c.Id = i.Id
	AND c.ActivityHour = i.ActivityHour
						)
SELECT COUNT(DISTINCT Id) AS NumberOfId 
FROM TEMP_HOURLYTABLE

---- < Finding the trends for TotalCalories, Total Steps, TotalIntensities and AverageIntensities> ---

WITH TEMP_HOURLYTABLE AS (
SELECT c.Id, 
	   c.ActivityHour, 
	   c.Calories, 
	   s.StepTotal, 
	   i.TotalIntensity, 
	   i.AverageIntensity
FROM CapstoneProject2BellaBeat..hourlyCalories_merged c
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlySteps_merged s
    ON c.Id = s.Id
	AND c.ActivityHour = s.ActivityHour
LEFT OUTER JOIN CapstoneProject2BellaBeat..hourlyIntensities_merged i
    ON c.Id = i.Id
	AND c.ActivityHour = i.ActivityHour
						)
SELECT Id, 
       SUM(Calories) AS TotalCalories,
	   SUM(StepTotal) AS TotalSteps,
	   SUM(TotalIntensity) AS TotalIntensities,
	   SUM(AverageIntensity) AS AverageIntensities
FROM TEMP_HOURLYTABLE
GROUP BY Id
ORDER BY Id


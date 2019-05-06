--4
CREATE DATABASE FPdb
LOCATION '/final_project';
DESCRIBE DATABASE FPdb;

--10b
CREATE TABLE IF NOT EXISTS FPdb.fd3_t (
  FL_DATE STRING,
  FL_NUM STRING,
  CARRIER_DELAY DOUBLE,
  WEATHER_DELAY DOUBLE,
  NAS_DELAY DOUBLE,
  SECURITY_DELAY DOUBLE,
  LATE_AIRCRAFT_DELAY DOUBLE)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';
LOAD DATA INPATH '/final_project/theDelays/part-v000-o000-r-00002'
OVERWRITE INTO TABLE FPdb.fd3_t;
SELECT * FROM FPdb.fd3_t LIMIT 10;

--10c
CREATE TABLE IF NOT EXISTS FPdb.fd4_t
LIKE FPdb.fd3_t;
LOAD DATA INPATH '/final_project/theDelays/part-v000-o000-r-00003'
OVERWRITE INTO TABLE FPdb.fd4_t;

CREATE TABLE IF NOT EXISTS FPdb.fd5_t
LIKE FPdb.fd3_t;
LOAD DATA INPATH '/final_project/theDelays/part-v000-o000-r-00004'
OVERWRITE INTO TABLE FPdb.fd5_t;

CREATE TABLE IF NOT EXISTS FPdb.fd6_t
LIKE FPdb.fd3_t;
LOAD DATA INPATH '/final_project/theDelays/part-v000-o000-r-00005'
OVERWRITE INTO TABLE FPdb.fd6_t;

CREATE TABLE IF NOT EXISTS FPdb.fd7_t
LIKE FPdb.fd3_t;
LOAD DATA INPATH '/final_project/theDelays/part-v000-o000-r-00006'
OVERWRITE INTO TABLE FPdb.fd7_t;
SELECT * FROM FPdb.fd7_t LIMIT 10;

--11
CREATE TABLE IF NOT EXISTS FPdb.fd_t AS
SELECT * FROM FPdb.fd1_t
UNION ALL
SELECT * FROM FPdb.fd2_t
UNION ALL
SELECT * FROM FPdb.fd3_t
UNION ALL
SELECT * FROM FPdb.fd4_t
UNION ALL
SELECT * FROM FPdb.fd5_t
UNION ALL
SELECT * FROM FPdb.fd6_t
UNION ALL
SELECT * FROM FPdb.fd7_t;

DESCRIBE FORMATTED FPdb.fd_t;

--12
SELECT MAX(CARRIER_DELAY) max_carrier_delay, 
              MAX(WEATHER_DELAY) max_weather_delay,
              MAX(NAS_DELAY) max_nas_delay,
              MAX(SECURITY_DELAY) max_security_delay, 
              MAX(LATE_AIRCRAFT_DELAY) max_late_aircraft_delay
FROM FPdb.fd_t;

SELECT ROUND(AVG(CARRIER_DELAY), 2) mean_carrier_delay, 
              ROUND(AVG(WEATHER_DELAY), 2) mean_weather_delay,
              ROUND(AVG(NAS_DELAY), 2) mean_nas_delay,
              ROUND(AVG(SECURITY_DELAY), 2) mean_security_delay, 
              ROUND(AVG(LATE_AIRCRAFT_DELAY), 2) mean_late_aircraft_delay
FROM FPdb.fd_t;

--13
CREATE VIEW averageDelays_v AS                                                                                                                                                  
 SELECT ROUND(AVG(CARRIER_DELAY), 2) mean_carrier_delay,                                                                                                                        
               ROUND(AVG(WEATHER_DELAY), 2) mean_weather_delay,                                                                                                                        
               ROUND(AVG(NAS_DELAY), 2) mean_nas_delay,                                                                                                                                
               ROUND(AVG(SECURITY_DELAY), 2) mean_security_delay,                                                                                                                      
               ROUND(AVG(LATE_AIRCRAFT_DELAY), 2) mean_late_aircraft_delay                                                                                                             
 FROM FPdb.fd_t;
ADD FILE /FP/FindMaxAverageDelayType.py;
SELECT TRANSFORM(mean_carrier_delay, mean_weather_delay, mean_nas_delay,                                                                                                        
                                      mean_security_delay, mean_late_aircraft_delay)                                                                                                                 
USING 'python FindMaxAverageDelayType.py' AS maxAverageDelay                                                                                                                    
FROM averageDelays_v;

--14
SELECT ROUND((COUNT(*) * SUM(WEATHER_DELAY * CARRIER_DELAY) - 
	                 SUM(WEATHER_DELAY) * SUM(CARRIER_DELAY)) /
                             SQRT((COUNT(*) * SUM(POW(WEATHER_DELAY, 2)) - 
		               POW(SUM(WEATHER_DELAY), 2)) *
			(COUNT(*) * SUM(POW(CARRIER_DELAY, 2)) - 
		               POW(SUM(CARRIER_DELAY), 2))), 4)
             AS w_c 
FROM FPdb.fd_t;

SELECT ROUND(CORR(WEATHER_DELAY, CARRIER_DELAY), 4) AS w_c FROM FPdb.fd_t;

SELECT ROUND(CORR(WEATHER_DELAY, CARRIER_DELAY), 4) AS w_c,
              ROUND(CORR(NAS_DELAY, CARRIER_DELAY), 4) AS n_c,
              ROUND(CORR(SECURITY_DELAY, CARRIER_DELAY), 4) AS s_c,
              ROUND(CORR(LATE_AIRCRAFT_DELAY, CARRIER_DELAY), 4) AS l_c,
              ROUND(CORR(NAS_DELAY, WEATHER_DELAY), 4) AS n_w,
              ROUND(CORR(SECURITY_DELAY, WEATHER_DELAY), 4) AS s_w,
              ROUND(CORR(LATE_AIRCRAFT_DELAY, WEATHER_DELAY), 4) AS l_w,
              ROUND(CORR(SECURITY_DELAY, NAS_DELAY), 4) AS s_n,
              ROUND(CORR(LATE_AIRCRAFT_DELAY, NAS_DELAY), 4) AS l_n,
              ROUND(CORR(LATE_AIRCRAFT_DELAY, SECURITY_DELAY), 4) AS l_s
FROM FPdb.fd_t;

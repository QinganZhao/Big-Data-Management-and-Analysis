--5
flightDelays = LOAD '/final_project/data/flightDelays_*'
                         USING org.apache.pig.piggybank.storage.CSVExcelStorage(',')
                         AS (YEAR: INT,
                  	     FL_DATE: CHARARRAY,
                               UNIQUE_CARRIER: CHARARRAY,
                               CARRIER: CHARARRAY,
                               FL_NUM: CHARARRAY,
                               ORIGIN_AIRPORT_ID: CHARARRAY,
                               ORIGIN: CHARARRAY,
                               ORIGIN_CITY_NAME: CHARARRAY,
                               ORIGIN_STATE_ABR: CHARARRAY,
                               DEST_AIRPORT_ID: CHARARRAY,
                               DEST: CHARARRAY,
                               DEST_CITY_NAME: CHARARRAY,
                               DEST_STATE_ABR: CHARARRAY,
                               DEP_DELAY_NEW: FLOAT,
                               ARR_DELAY: FLOAT,
                               ARR_DELAY_NEW: FLOAT,
                               CARRIER_DELAY: FLOAT,
                               WEATHER_DELAY: FLOAT,
                               NAS_DELAY: FLOAT,
                               SECURITY_DELAY: FLOAT,
                               LATE_AIRCRAFT_DELAY: FLOAT);

--6
grpd = GROUP flightDelays ALL;
averageDelays = FOREACH grpd GENERATE ROUND_TO(AVG(flightDelays.CARRIER_DELAY), 2),
                                                                              ROUND_TO(AVG(flightDelays.WEATHER_DELAY), 2),
                                                                              ROUND_TO(AVG(flightDelays.NAS_DELAY), 2),
                                                                              ROUND_TO(AVG(flightDelays.SECURITY_DELAY), 2),
                                                                              ROUND_TO(AVG(flightDelays.LATE_AIRCRAFT_DELAY), 2);
DUMP averageDelays;

--7
grpd = GROUP flightDelays ALL;
maxDelays = FOREACH grpd GENERATE MAX(flightDelays.CARRIER_DELAY),
                                                                       MAX(flightDelays.WEATHER_DELAY),
                                                                       MAX(flightDelays.NAS_DELAY),
                                                                       MAX(flightDelays.SECURITY_DELAY),
                                                                       MAX(flightDelays.LATE_AIRCRAFT_DELAY);
DUMP maxDelays;

--8
REGISTER '/FP/flight_delay_udf.py' USING jython AS myudf;
joined = JOIN flightDelays BY CARRIER_DELAY, maxDelays BY $0;
res = FOREACH joined GENERATE myudf.get_max((('YEAR', $0),
                                                   			            ('FL_DATE', $1),
                                                   			            ('UNIQUE_CARRIER', $2),
                                                   			            ('CARRIER', $3),
						            ('FL_NUM', $4),
                                                   			            ('ORIGIN_AIRPORT_ID', $5),
                                                  		                         ('ORIGIN', $6),
                                                   			            ('ORIGIN_CITY_NAME', $7),
                                                  			            ('ORIGIN_STATE_ABR', $8),
                                                  	 		            ('DEST_AIRPORT_ID', $9),
                                                  			            ('DEST', $10),
                                                   			            ('DST_CITY_NAME', $11),
                                                  			            ('DEST_STATE_ABR', $12),
                                                  			            ('DEP_DELAY_NEW', $13),
                                                   			            ('ARR_DELAY', $14),
                                                   			            ('ARR_DELAY_NEW', $15),
                                                   			            ('CARRIER_DELAY', $16),
                                                   		                         ('WEATHER_DELAY', $17),
                                                  			            ('NAS_DELAY', $18),
                                                   			            ('SECURITY_DELAY', $19),
                                                   			            ('LATE_AIRCRAFT_DELAY', $20)));                                                                 
DUMP res;

--9
allTheDelays = FOREACH flightDelays GENERATE FL_DATE, FL_NUM, CARRIER_DELAY,                         
                                                                   WEATHER_DELAY, NAS_DELAY, SECURITY_DELAY, 
                                                                   LATE_AIRCRAFT_DELAY;
theDelays = FILTER allTheDelays BY (CARRIER_DELAY IS NOT NULL AND
                                                                 WEATHER_DELAY IS NOT NULL AND
                                    		            NAS_DELAY IS NOT NULL AND
                                    		            SECURITY_DELAY IS NOT NULL AND
                                    		            LATE_AIRCRAFT_DELAY IS NOT NULL);
STORE theDelays INTO '/final_project/theDelays';


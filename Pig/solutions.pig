--1B
stocks_prices = LOAD '/HW4/NYSE_daily_prices.csv'
		 USING PigStorage(',')
               	 AS (exchng: chararray, symbol: chararray, ymd: chararray, 
                   	       price_open: double, price_high: double, price_low: double, 
                   	       price_close: double, volume: int, price_adj_close: double);
DUMP stocks_prices;

stock_dividends = LOAD '/HW4/NYSE_dividends.csv'
		      USING PigStorage(',')
                  	      AS (exchng: chararray, symbol: chararray, ymd: chararray, dividend: double);
DUMP stock_dividends;

--1C
grpd = GROUP stocks_prices BY symbol;
cnt = FOREACH grpd GENERATE group, COUNT(stocks_prices);
sorted = ORDER cnt BY group;
DUMP sorted;

--1D
grpd = GROUP stocks_prices BY symbol;
avgopen = FOREACH grpd GENERATE group, ROUND_TO(AVG(stocks_prices.price_open), 4) AS ap;
DUMP avgopen;

--1E
grpd = GROUP avgopen ALL;
highest = FOREACH grpd GENERATE MAX(avgopen.ap) AS maxopen;
joined = JOIN avgopen BY ap, highest BY maxopen;
result = FOREACH joined GENERATE $0, $1;
DUMP result;

grpd = GROUP avgopen ALL;
lowest = FOREACH grpd GENERATE MIN(avgopen.ap) AS minopen;
joined = JOIN avgopen BY ap, lowest BY minopen;
result = FOREACH joined GENERATE $0, $1;
DUMP result;

--1F
stock_div = LOAD '/HW4/NYSE_dividends.csv'
        USING PigStorage(',')
                     AS (exchng: chararray, symbol: chararray, ymd: chararray, dividend: double);
grpd = GROUP stock_div ALL;
highest = FOREACH grpd GENERATE MAX(stock_div.dividend) AS maxdiv;
joindiv = JOIN stock_div BY dividend, highest BY maxdiv;
joinprice = JOIN joindiv BY (exchng, symbol, ymd), stocks_prices BY (exchng, symbol, ymd);
result = FOREACH joinprice GENERATE stocks_prices::symbol, stocks_prices::ymd, 
                                                                      stocks_prices::price_open;
DUMP result;

--2A
alldata = LOAD '/HW4/flight12.csv'
          	   USING org.apache.pig.piggybank.storage.CSVExcelStorage(',')
                AS (YEAR, FL_DATE, UNIQUE_CARRIER, CARRIER, FL_NUM, ORIGIN_AIRPORT_ID, ORIGIN,
                       ORIGIN_CITY_NAME, ORIGIN_STATE_ABR, DEST_AIRPORT_ID, DEST,
                       DEST_CITY_NAME, DEST_STATE_ABR, DEP_DELPAY_NEW: FLOAT, ARR_DELAY: FLOAT,
                       ARR_DELAY_NEW: FLOAT, CARRIER_DELAY: FLOAT, WEATHER_DELAY: FLOAT,
                       NAS_DELAY: FLOAT, SECURITY_DELAY: FLOAT, LATE_AIRCRAFT_DELAY: FLOAT);
DUMP alldata;

--2B
wanted_data = FOREACH alldata GENERATE FL_DATE, FL_NUM, CARRIER_DELAY, WEATHER_DELAY,
                                                                                NAS_DELAY, SECURITY_DELAY, LATE_AIRCRAFT_DELAY;
DUMP wanted_data;

--2C
grpd = GROUP wanted_data ALL;
longest = FOREACH grpd GENERATE MAX(wanted_data.CARRIER_DELAY), 
            MAX(wanted_data.WEATHER_DELAY),
				            MAX(wanted_data.NAS_DELAY), 
            MAX(wanted_data.SECURITY_DELAY),
                                                                 MAX(wanted_data.LATE_AIRCRAFT_DELAY);
DUMP longest;

--2D
grpd = GROUP wanted_data ALL;
avg_result = FOREACH grpd GENERATE ROUND_TO(AVG(wanted_data.CARRIER_DELAY), 2), 
                                                                       ROUND_TO(AVG(wanted_data.WEATHER_DELAY), 2),
				                  ROUND_TO(AVG(wanted_data.NAS_DELAY), 2), 
                               	 	                  ROUND_TO(AVG(wanted_data.SECURITY_DELAY), 2),
                                		                  ROUND_TO(AVG(wanted_data.LATE_AIRCRAFT_DELAY), 2);
DUMP avg_result;

--2E
REGISTER '/HW4/delay_udf.py' USING jython AS myudf;
out = FOREACH avg_result GENERATE myudf.delay_udf((('CARRIER_DELAY', $0),
                                                   ('WEATHER_DELAY', $1),
                                                   ('NAS_DELAY', $2),
                                                   ('SECURITY_DELAY', $3),
                                                   ('LATE_AIRCRAFT_DELAY', $4)));
DUMP out;
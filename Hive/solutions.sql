-- PS1

-- Q(B)
CREATE DATABASE stocksdb;

CREATE TABLE IF NOT EXISTS stocksdb.stock_prices (
	exchng STRING,
	symbol STRING,
	ymd STRING,
	price_open DOUBLE,
	price_high DOUBLE,
	price_low DOUBLE,
	price_close DOUBLE,
	price_volume DOUBLE,
	price_adj_close DOUBLE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS stocksdb.stock_dividends (
	exchng STRING,
	symbol STRING,
	ymd STRING,
	dividend DOUBLE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n';

DESCRIBE stocksdb.stock_prices;

DESCRIBE stocksdb.stock_dividends;

-- Q(C)
LOAD DATA INPATH '/HW3/stockdata/NYSE_daily_prices.csv'
OVERWRITE INTO TABLE stocksdb.stock_prices;

LOAD DATA INPATH '/HW3/stockdata/NYSE_dividends.csv'
OVERWRITE INTO TABLE stocksdb.stock_dividends;

-- Q(D)
SELECT symbol, COUNT(*)
FROM stocksdb.stock_prices
GROUP BY symbol;

-- Q(E)
SELECT symbol, ROUND(AVG(price_open), 4) ap
FROM stocksdb.stock_prices
GROUP BY symbol;

-- Q(F)
CREATE VIEW average_price_v AS
SELECT symbol, ROUND(AVG(price_open), 4) ap
FROM stocksdb.stock_prices
GROUP BY symbol;

-- Q(G)
SELECT symbol, ap
FROM average_price_v
ORDER BY ap DESC
LIMIT 1;

SELECT symbol, ap
FROM average_price_v
ORDER BY ap
LIMIT 1;

-- Q(H)
SELECT d.symbol symbol, d.ymd ymd, p.price_open price_open, d.dividend dividend
FROM stocksdb.stock_dividends d
JOIN stocksdb.stock_prices p
ON d.exchng = p.exchng
AND d.symbol = p.symbol
AND d.ymd = p.ymd
JOIN (SELECT MAX(dividend) d FROM stocksdb.stock_dividends) m
ON d.dividend = m.d;


-- PS2

-- Q(A)
CREATE DATABASE flightsdb;

CREATE TABLE IF NOT EXISTS flightsdb.flight_delays_hw3 (
	ymd STRING,
	flight_num STRING,
	carrier_delay DOUBLE,
	weather_delay DOUBLE,
	nas_delay DOUBLE,
	security_delay DOUBLE,
	late_aircraft_delay DOUBLE);

-- Q(B)
CREATE TABLE IF NOT EXISTS temp_flight (tmp_flight STRING)
TBLPROPERTIES("skip.header.line.count" = "1");

LOAD DATA INPATH '/HW3/flight12.csv'
OVERWRITE INTO TABLE temp_flight;

-- Q(C)
INSERT OVERWRITE TABLE flightsdb.flight_delays_hw3
SELECT REGEXP_EXTRACT(tmp_flight, '.*?,(.*?),', 1) AS ymd,
REGEXP_EXTRACT(tmp_flight, '(.*?,){4}(.*?),', 2) AS flight_num,
REGEXP_EXTRACT(tmp_flight, '(.*?,){18}(.*?),', 2) AS carrier_delay,
REGEXP_EXTRACT(tmp_flight, '(.*?,){19}(.*?),', 2) AS weather_delay,
REGEXP_EXTRACT(tmp_flight, '(.*?,){20}(.*?),', 2) AS nas_delay,
REGEXP_EXTRACT(tmp_flight, '(.*?,){21}(.*?),', 2) AS security_delay,
REGEXP_EXTRACT(tmp_flight, '(.*?,){22}(.*?),', 2) AS late_aircraft_delay
FROM temp_flight;

-- Q(D)
SELECT * FROM flightsdb.flight_delays_hw3 LIMIT 10;

-- Q(E)
SELECT MAX(carrier_delay) max_carrier_delay, MAX(weather_delay) max_weather_delay,
MAX(nas_delay) max_nas_delay, MAX(security_delay) max_security_delay,
MAX(late_aircraft_delay) max_late_aircraft_delay FROM flightsdb.flight_delays_hw3;

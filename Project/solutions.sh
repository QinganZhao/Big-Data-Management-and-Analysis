hadoop fs -mkdir /final_project
hadoop fs -mkdir /final_project/data

mkdir /FP
hadoop fs -copyToLocal /final_project/data/flightDelays.tar.gz /FP/flightDelays.tar.gz
cd /FP
tar -xzf /FP/flightDelays.tar.gz
rm flightDelays.tar.gz
ls –lh

hadoop fs -copyFromLocal /FP/flightDelays* /final_project/data
hadoop fs -put /FP/flightDelays* /final_project/data

hive

vi /FP/flight_delay_udf.py

vi /FP/FindMaxAverageDelayType.py
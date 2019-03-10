hadoop fs -mkdir /course-data

mkdir /data-set

cd /data-set/
wget http://data.gdeltproject.org/events/1990.zip
unzip 1990.zip
wget http://data.gdeltproject.org/events/1991.zip
unzip 1991.zip

hadoop fs -put 1990.csv 1991.csv /course-data

hadoop fs -ls /course-data

hadoop fsck /course-data -files -blocks | less

hadoop fs -rm /course-data/1990.csv

mkdir /HW2Q4
cd /HW2Q4/
scp -P 2222 shakespeare.txt root@127.0.0.1:/HW2Q4

vi WDmapper.py
vi WDreducer.py
chmod +x WDmapper.py
chmod +x WDreducer.py
cat ./shakespeare.txt | ./WDmapper.py | sort | ./WDreducer.py

hadoop jar /usr/hdp/2.6.1.0-129/hadoop-mapreduce/hadoop-streaming.jar\
-file WDmapper.py -file WDreducer.py\ 
-mapper WDmapper.py -reducer WDreducer.py\ 
-input /course-data/shakespeare.txt -output /course-data/Q4a_reducer-output/

scp -P 2222 Q4b_Reducer-output.txt root@127.0.0.1:/HW2Q4
cat Q4a_Reducer-output.txt | head -n 50
cat Q4a_Reducer-output.txt | tail -n 50

vi WDmapper1.py
vi WDreducer1.py
chmod +x WDmapper1.py
chmod +x WDreducer1.py

hadoop jar /usr/hdp/2.6.1.0-129/hadoop-mapreduce/hadoop-streaming.jar\
-file WDmapper1.py -file WDreducer1.py\ 
-mapper WDmapper1.py -reducer WDreducer1.py\ 
-input /course-data/shakespeare.txt -output /course-data/Q4b_reducer-output/

scp -P 2222 Q4a_Reducer-output.txt root@127.0.0.1:/HW2Q4
cat Q4b_Reducer-output.txt 

vim WDmapper2.py
vim WDreducer2.py
chmod +x WDmapper2.py
chmod +x WDreducer2.py

hadoop jar /usr/hdp/2.6.1.0-129/hadoop-mapreduce/hadoop-streaming.jar\ 
-file WDmapper2.py -file WDreducer2.py\ 
-mapper WDmapper2.py -reducer WDreducer2.py\ 
-input /course-data/shakespeare.txt -output /course-data/Q4c_reducer-output/

scp -P 2222 Q4c_Reducer-output.txt root@127.0.0.1:/HW2Q4
cat Q4c_Reducer-output.txt 

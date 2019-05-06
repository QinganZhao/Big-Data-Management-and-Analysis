#!/usr/bin/python
import sys
def FindMaxAverageDelayType(carrier, weather, nas, security, late_aircraft):                                                                                                          
key = ['CARRIER_DELAY', 'WEATHER_DELAY', 'NAS_DELAY',                                                                                                                         
       'SECURITY_DELAY', 'LATE_AIRCRAFT_DELAY']                                                                                                                               
        	value = [carrier, weather, nas, security, late_aircraft]                                                                                                                      
        	max_val = max(value)                                                                                                                                                          
        	max_key = key[value.index(max_val)]                                                                                                                                           
        	return (max_key, str(max_val))
for line in sys.stdin:                                                                                                                                                                
        	line = line.strip()                                                                                                                                                           
        	carrier, weather, nas, security, late_aircraft = line.split('\t')                                                                                                             
        	max_key = FindMaxAverageDelayType(float(carrier), float(weather), float(nas),                                                                                                 
                                              float(security), float(late_aircraft))[0]                                                                                                   
        	max_val = FindMaxAverageDelayType(float(carrier), float(weather), float(nas),                                                                                                 
                                              float(security), float(late_aircraft))[1]                                                                                                   
        	print('The delay category with the longest average delay is ' + max_key +                                                                                                     
                  '; the average delay time is ' + max_val + ' minutes.')

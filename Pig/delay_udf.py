@outputSchema("res:chararray")                                                                                                   
def delay_udf(carrier, weather, nas, security, late_aircraft):                                                                   
        dic = {carrier: 'CARRIER_', weather: 'WEATHER_', nas: 'NAS_',                                                            
               security: 'SECURITY_', late_aircraft: 'LATE_AIRCRAFT_'}                                                           
        values = [carrier, weather, nas, security, late_aircraft]                                                                
        max_value, min_value = max(values), min(values)                                                                          
        res = 'The most common delay category is ' + dic[max_value] + \                                                          
              'DELAY, which has an average delay of ' + str(max_value) + \                                                       
              ' minutes, and the most uncommon delay category is ' + \                                                           
              dic[min_value] + 'DELAY, which has an average delay of ' + \                                                       
              str(min_value) + ' minutes.'                                                                                       
        return res
@outputSchema("res:chararray")                                                                                                                                              
def delay_udf(data):                                                                                                                                                        
        max_value, min_value = -float('inf'), float('inf')                                                                                                                  
        for key, value in data:                                                                                                                                             
                if value > max_value:                                                                                                                                       
                        max_key, max_value = key, value                                                                                                                     
                if value < min_value:                                                                                                                                       
                        min_key, min_value = key, value                                                                                                                     
        res = 'The most common delay category is ' + max_key + \                                                                                                            
              ', which has an average delay of ' + str(max_value) + \                                                                                                       
              ' minutes,\n' + 'and the most uncommon delay category is ' + min_key + \                                                                                      
              ', which has an average delay of ' + str(min_value) + ' minutes.'                                                                                             
        return res
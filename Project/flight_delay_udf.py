@outputSchema("res:chararray")                                                                                                                                                  
def get_max(data):                                                                                                                                                              
res = 'The maximum CARRIER_DELAY is 1975.0. ' + \                                                                                                                       
      'The details of the delay are as follows:\n'                                                                                                                      
        	for i in range(len(data)-1):                                                                                                                                            
             		res += data[i][0] + ': ' + str(data[i][1]) + ',\n'                                                                                                              
        	res += data[-1][0] + ': ' + str(data[-1][1]) + '.\n'                                                                                                                    
        	return res

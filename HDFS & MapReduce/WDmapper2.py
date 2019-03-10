#!/usr/bin/env python

'''
The script is used for mapping phase
To ignore the case difference,
we simply just convert each word into all-lowercase in the map phase 
'''
import sys
# regular expressions can increase the efficiency 
# and avoid too many lines of code 
import re 

# input from STDIN: reading one line in one loop 
for line in sys.stdin:
	print('%s\t%d' % ('#Line#', 1))
	# remove the front/end blanks of each line 
	line = line.strip()
	# split words by whitespaces
	words = re.split('\s', line)
	# word processing in one loop
	for word in words:
        # the output values are tab-delimited
        # the word count is 1 since each for loop only reads one word
		# remove all charaters other than alphanumeric in a word
		# by doing this we may 'change' some words such as turning I'm into Im
		# but it won't influence the result of world count
		# lower() will change all characters to lowercase
		word = re.sub('\W+', '', word).lower()
		if word:
			print('%s\t%s' % (word, 1))
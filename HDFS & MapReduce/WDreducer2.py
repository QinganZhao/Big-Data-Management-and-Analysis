#!/usr/bin/env python

'''
The script is for reducing phase
Same script as the previous one
'''
import sys

current_word = word = None 
current_count = line_count = word_count = unique_word = 0
words = []


# input comes from STDIN
for line in sys.stdin:
	line = line.strip()
	
	# parse the input we got from WDmapper.py
	key, val = line.split('\t', 1)
	# if the input is a line, we count line; otherwise we count word
	if key == '#Line#':
		line_count += 1
		continue
	word, count = key, val
	
	# total word number add 1
	word_count += 1
	
	# convert count (a tring) to int
	try:
		count = int(count)
	except ValueError:
		# if count was not a number, silently ignore the line
		continue
		
	# Hadoop sorts map output by key (here: word) before it is passed to the reducer
	if current_word == word:
		current_count += count
	else:
		# store the (word, count) pair in a list
		if current_word:
			unique_word += 1
			words.append((current_word, current_count))
		current_count = count
		current_word = word
		
# output the total number of lines
print('There are ' + str(line_count) + ' lines in the text.\n')

# output the top 100 most frequently words
word_100 = sorted(words, key=lambda x: x[1], reverse=True)[:100]
print('The 100 most frequently used words are:\n')
for word, count in word_100:
	print((word, count))
print('\n')

# output the total word count
print('There are ' + str(word_count) + ' words in the text.\n')

# output the number of unique words
print('If the case difference is ignored, there are '
      + str(unique_word) + ' unique words in the text')
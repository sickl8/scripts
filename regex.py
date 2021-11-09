#!/usr/bin/env python3

import sys
import re

regex_str = sys.argv[1]
regex = re.compile(regex_str, re.MULTILINE)
txt = sys.argv[2]

# print('regex = ' + regex)
# print('txt = ' + txt)
# print(regex.findall(txt))
for m in regex.findall(txt):
	print(m.replace('\n', ' '))
#!/usr/bin/env python3

import sys
import re
from sys import stdin


regex_str = sys.argv[1]
regex = re.compile(regex_str, re.MULTILINE)

txt = ""

if len(sys.argv) > 2 and sys.argv[2] != "-":
	txt = sys.argv[2]
else:
	for line in stdin:
		txt += line

boul = True

if len(sys.argv) > 3:
	if sys.argv[3] == "false" or sys.argv[3] == "f" or sys.argv[3] == "0":
		boul = False

rp = '\n'

if boul:
	rp = ' '
# print('regex = ' + regex)
# print('txt = ' + txt)
# print(regex.findall(txt))
for m in regex.findall(txt):
	# print(m)
	# print(type(m))
	if type(m) == tuple:
		print(m[0].replace('\n', rp))
	else:
		print(m.replace('\n', rp))
#!/usr/bin/env python3

import json
from pathlib import Path
import datetime
import sys


if (int(input()) == 1):
    home=str(input())
    file = open(home+'/.scripts/test_scripts/cmakevars.json')
    cmakevars = json.load(file)
    file.close()
    header_full_path=str(input())
    source_full_path=str(input())
    
    header=header_full_path.split('/')
    header_name=header[-1]
    header.pop(len(header)-1)
    header_path="/".join(header)
    
    source=source_full_path.split('/')
    source_name=source[-1]
    source.pop(len(source)-1)
    source_path="/".join(source)
    source=source_full_path.split('/')
    print(header_path, "name", header_name)
    print(source_path, "name", source_name)

    cmake_file_old_path=source_path+"/.old"
else:
    sys.exit('no errors')
include_path = header_path
old_cmake_file = cmake_file_old_path+'/'+datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")+'CMakeLists.txt'
cmake_file = source_path+'/CMakeLists.txt'

def get_cmake_definition(s_file):
    results = []
    for var in cmakevars:
        cur = cmakevars[var]
        if (cur in s_file):
            ret = '${'+var+'}'+s_file[len(cur):]
            results.append(ret)
    return results


def save_file(file, buffer):
    f = open(file, 'w')
    f.write(buffer)
    f.close()

def add_to_cmakelistfile(filepath, include_line):
    f = open(filepath, mode='r')
    buffer = f.read()
    f.close()
    lines = buffer.splitlines()
    if len(lines):
        Path(cmake_file_old_path).mkdir(parents=True, exist_ok=True)
        save_file(old_cmake_file, buffer)
        i = 0
        l_id = -1
        target = source_name.split('.')[0].replace('test_', '')
        target_found = False
        for line in lines:
            i += 1
            if target in line:
                target_found = True
            if target_found and 'INCLUDES' in line:
                l_id = i
            if target_found and ')' in line:
                target_found = False
        include_line = " "*40+include_line
        lines.insert(l_id, include_line)
    return '\n'.join(lines)

res = get_cmake_definition(include_path)
res = sorted(res, key=len)
new_buf = add_to_cmakelistfile(cmake_file, res[0])
save_file(cmake_file, new_buf)
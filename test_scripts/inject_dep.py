#!/usr/bin/env python3

import json
from pathlib import Path
import datetime
import sys

cmake_vars_json_path = '.scripts/test_scripts/cmakevars.json'

response = int(input())
if (response == 1):
    home = str(input())
    if "Error" in home:
        sys.exit()
    include_defintion = str(input())
    header_full_path = str(input())
    source_full_path = str(input())

    file = open(home+'/'+ cmake_vars_json_path)
    cmakevars = json.load(file)
    file.close()
    header_path = header_full_path.replace(include_defintion, '')

    source = source_full_path.split('/')
    source_name = source[-1]
    source.pop(len(source)-1)
    source_path = "/".join(source)
    source = source_full_path.split('/')
    cmake_file_old_path=source_path+"/.old"
else:
    sys.exit()
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
    try:
        f = open(file, 'w')
        f.write(buffer)
        f.close()
        return 1
    except IOError:
        sys.exit(f"Error: {file} Could not write to file:")

def add_to_cmakelistfile(filepath, include_line):
    try:
        f = open(filepath, mode='r')
        buffer = f.read()
        f.close()
    except IOError:
        sys.exit(f"Error: {filepath} Could not read file, or it does not exist.")
    lines = buffer.splitlines()
    if len(lines):
        Path(cmake_file_old_path).mkdir(parents=True, exist_ok=True)
        if save_file(old_cmake_file, buffer) != 1:
            return None
        line_id = -1
        target = source_name.split('.')[0].replace('test_', '')
        target_found = False
        include_found = False
        for index in range(len(lines)):
            if not target_found and target in lines[index]:
                target_found = True
                continue
            if target_found and target in lines[index]:
                return sys.exit(f"Error: {file} has multiple test definitions for {target}:{index}")
            if target_found and 'INCLUDES' in lines[index]:
                include_found = True
            if include_found and '$' not in lines[index + 1]:
                line_id = index + 1
                break
        if (line_id != -1):
            include_line = " "*40+include_line
            lines.insert(line_id, include_line)
        else:
            return None
    return '\n'.join(lines)

res = get_cmake_definition(include_path)
if len(res):
    res = sorted(res, key=len)
    new_buf = add_to_cmakelistfile(cmake_file, res[0])
    if new_buf is not None:
        save_file(cmake_file, new_buf)
    else:
        sys.exit(f"New output buffer is empty, Error: {cmake_file} template")
else:
    sys.exit(f"Check your CMakelists.txt template file.\nCould not find cmakelist 'INCLUDES' line on: {cmake_file}")
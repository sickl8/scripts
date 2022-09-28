from asyncore import read
from fileinput import close
import json
from pathlib import Path
import datetime

file = open('/home/anouar/.scripts/test_scripts/cmakevars.json')
cmakevars = json.load(file)
file.close()
full_path = str(input())
include_definition = str(input())
cmake_file = str(input())
include_path = full_path.replace('/'+include_definition, '')

cmake_file_old_path = cmake_file.replace('/'+'CMakeList.txt', '')+'/.old'
old_cmake_file = cmake_file_old_path+'/'+datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")+'CMakeList.txt'

print(cmake_file)

def get_cmake_definition(s_file):
    results = []
    for var in cmakevars:
        cur = cmakevars[var]
        if (cur in s_file):
            ret = '${'+var+'}'+s_file[len(cur):]
            results.append(ret)
    return results

def save_old(path, file, buffer):
    Path(path).mkdir(parents=True, exist_ok=True)
    f = open(file, 'w')
    f.write(buffer)
    f.close()

def add_to_cmakelistfile(filepath, include_line):
    f = open(filepath, mode='r')
    buffer = f.read()
    f.close()
    save_old(cmake_file_old_path, old_cmake_file,buffer)
    lines = buffer.splitlines()
    i = 0
    l_id = -1
    for line in lines:
        i += 1
        if 'INCLUDES' in line:
            l_id = i
    include_line = " "*40+include_line
    lines.insert(l_id, include_line)
    return lines

res = get_cmake_definition(include_path)
res = sorted(res, key=len)
new_lines = add_to_cmakelistfile('./tests/src/safe_network/CMakeLists.txt', res[0])
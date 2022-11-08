
if [ -z "$1" ]
then
    echo >&2 "$(basename -- $0): define the default build target with include (example test_<target>)"
else
    if [ $1 == "-h" ]
    then
    echo -e "Usage: $(basename -- $0) test_<target>
This script allows to add INCLUDE section headers to your test target on CMakeLists.txt

Options:
    -h,  Show help"
    else
    # find_dep:
    #   -parses output from the cmake build command of the target
    #   -searches for the filenames and path names needed and outputs them
    # inject_dep:
    #   -takes input from find_dep in case there was an error.
    #   -searches for the appropriate variable to add to the CMakeList file
    #   -adds the include path to the appropriate CMakelists.txt (if it exists and has the template ready, else error) 
    find_dep.sh $1 | inject_dep.py
    fi
fi
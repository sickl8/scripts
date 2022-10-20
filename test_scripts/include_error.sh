
if [ -z "$1" ]
then
    echo >&2 "$(basename -- $0): define the default build target with include (example test_target)"
else
    find_dep.sh $1 | inject_dep.py
fi
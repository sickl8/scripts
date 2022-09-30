
if [ -z "$1" ]
then
    echo >&2 "$(basename -- $0): define the default build target with include (example test_target)"
else
    cd $SAFETY_CONTROL_UNIT_HOME
    ret=$(/usr/bin/cmake --build /home/anouar/workspace/safety_control_unit/build --config Debug --target $1 -j 10 -- 2>&1 | regex.py '#include\s+[<"](\S+)[>"]' | awk 'NR==1')
    until [ -z $ret ]
    do
        ret=$(/usr/bin/cmake --build /home/anouar/workspace/safety_control_unit/build --config Debug --target $1 -j 10 -- 2>&1 | regex.py '#include\s+[<"](\S+)[>"]' | awk 'NR==1')
        find_dep.sh $1 | inject_dep.py
    done
fi
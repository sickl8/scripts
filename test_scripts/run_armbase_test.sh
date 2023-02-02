#!/usr/bin/expect

set TEST_NAME [lindex $argv 0]
spawn ./build-docker-armbase.sh -i
expect "armbase_fw3$ "
send -- "cd build_cobot_x86_debug/\r"
expect "build_cobot_x86_debug$ "
send -- "ctest -R $TEST_NAME\r"
expect "100%"
send -- "\x04"

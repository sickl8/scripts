#!/usr/bin/expect

set DEBUG 0
if { $argc == 0 } {
    puts "Usage: $argv0 <test_filter> (--debug)"

    puts "--debug: run test in debug mode "
    exit 1
}

#check for --debug flag
for {set i 0} {$i < $argc} {incr i} {
    if { [lindex $argv $i] == "--debug" } {
        set DEBUG 1;
    }
}

if { $DEBUG == 1 } {
    set timeout -1;
    set TEST_NAME [lindex $argv 0];
    spawn ./build-docker-armbase.sh -i;
    expect "machine-user@";
    send -- "gdbgui -r --args ./build_cobot_x86_debug/bin/armbaseUnitTest --gtest_filter=$TEST_NAME\r";
    expect "100%";
} else {
    set timeout -1;
    set TEST_NAME [lindex $argv 0];
    spawn ./build-docker-armbase.sh -i;
    expect "machine-user@";
    send -- "cd build_cobot_x86_debug/\r";
    expect "build_cobot_x86_debug$ ";
    send -- "ctest -R $TEST_NAME\r";
    expect "%";
    send -- "\x04";
}


if [ -d "build_cobot_x86_debug" ]
then
	mv build_cobot_x86_debug build_cobot_x86_debug_bkp
fi

if [ -d "build_cobot_x86_coverage" ]
then
	mv build_cobot_x86_coverage build_cobot_x86_debug
fi

./build-docker-armbase.sh --test --coverage --html
mv build_cobot_x86_debug build_cobot_x86_coverage

if [ -d "build_cobot_x86_debug_bkp" ]
then
	mv build_cobot_x86_debug_bkp build_cobot_x86_debug
fi

findhere.sh index.html
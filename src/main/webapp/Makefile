all:
	make -C lib/ -f Makefile all

test:
	make all
	phantomjs app/test/run_jasmine_test.coffee app/test/HeadlessSpecRunner.html

watch:
	make -C lib/ -f Makefile
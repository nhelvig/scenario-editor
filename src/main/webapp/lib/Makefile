watch:
	cp -r ../lib/vendor ../app/js/.
	coffee -o ../app/js -c ../lib/
	coffee -o ../app/js/collections -w collections
	#coffee -o ../app/js/extensions -w
	#coffee -o ../app/js/models -w models
	#coffee -o ../app/js/util -w util
	#coffee -o ../app/js/views -w views

all:
	coffee -o ../app/js -c .
	coffee -o ../app/js/collections -c collections
	coffee -o ../app/js/extensions -c extensions
	coffee -o ../app/js/models -c models
	coffee -o ../app/js/util -c util
	coffee -o ../app/js/views -c views
	coffee -o ../app/js/overrides -c overrides
	cp -r ../lib/vendor/. ../app/js/vendor/.
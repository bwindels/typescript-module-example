all:
	cd src/ && tsc main/main.ts --module commonjs --outDir ../build/ && cd ..
clean:
	rm -rf build/
run: all
	NODE_PATH=build/ node build/main/main.js
bundle: all
	NODE_PATH=build/ browserify build/main/main.js -o build/bundle.js
build-test:
	cd src/ && tsc ../test/*.test.ts --module commonjs --outDir ../build && cd ..
test: build-test
	NODE_PATH=build/ nodeunit build/test/*.test.js
all:
	cd src/ && tsc main/main.ts --module commonjs --outDir ../build/ && cd ..
clean:
	rm -rf build/
run:
	NODE_PATH=build/ node build/main/main.js
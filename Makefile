#configuration
ENTRY_MODULE=main/main
SRC_DIR = $(PWD)/src
BUILD_DIR = $(PWD)/build
BUNDLE_FILE = $(BUILD_DIR)/bundle.js
WEBSERVER_PORT = 60000
BROWSERIFY_FLAGS = -v --debug
#commands
TSC = $(PWD)/node_modules/typescript/bin/tsc
WATCHIFY = $(PWD)/node_modules/watchify/bin/cmd.js
WEBSERVER = $(PWD)/node_modules/asdf/bin/asdf
BROWSERIFY = $(PWD)/node_modules/browserify/bin/cmd.js
DAEMON_WATCHER = $(PWD)/node_modules/daemon-watch/daemon-watch.js
NODEUNIT = $(PWD)/node_modules/nodeunit/bin/nodeunit
#derived variables
JS_BUILD_DIR = $(BUILD_DIR)/src
ENTRY_TS=$(ENTRY_MODULE).ts
ENTRY_JS=$(ENTRY_MODULE).js
INITIAL_PWD=$(PWD)

build:
	@cd $(SRC_DIR) && $(TSC) $(ENTRY_TS) --module commonjs --outDir $(JS_BUILD_DIR) && cd $(INITIAL_PWD)
watch:
#first touch entry js file so watchify doesn't exit when it is not there yet
	@mkdir -p `dirname $(JS_BUILD_DIR)/$(ENTRY_JS)` && \
	touch $(JS_BUILD_DIR)/$(ENTRY_JS) && \
	$(DAEMON_WATCHER) \
	"$(TSC) --watch $(ENTRY_TS) --module commonjs --outDir $(JS_BUILD_DIR)" --cwd $(SRC_DIR) --name tsc \
	"NODE_PATH=$(JS_BUILD_DIR) $(WATCHIFY) $(JS_BUILD_DIR)/$(ENTRY_JS) -o $(BUNDLE_FILE) $(BROWSERIFY_FLAGS)" --name watchify \
	"$(WEBSERVER) --port $(WEBSERVER_PORT)" --name asdf
clean:
	@rm -rf build/
run: build
	NODE_PATH=$(JS_BUILD_DIR) node $(JS_BUILD_DIR)/$(ENTRY_JS)
bundle: build
	NODE_PATH=$(JS_BUILD_DIR) $(BROWSERIFY) $(JS_BUILD_DIR)/$(ENTRY_JS) -o $(BUNDLE_FILE) $(BROWSERIFY_FLAGS)
build-test:
	@cd src/ && $(TSC) ../test/*.test.ts --module commonjs --outDir ../build && cd ..
test: build-test
	@NODE_PATH=build/ $(NODEUNIT) build/test/*.test.js
setup:
	npm install --no-optional --loglevel error --development
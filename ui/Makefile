# Makefile for ui
# usage: make [DEFAULT_PORT=<num> run]
# make test: compares expected to actual output
# make cov:  runs tests and checks line coverage

SETTINGS        = settings.json
VERSION         ?= $(shell jq -r .version $(SETTINGS))
DEFAULT_PORT    ?= $(shell jq -r .port $(SETTINGS))
URL_OPENMCT     ?= $(shell jq -r .openmct $(SETTINGS))
URL_CERT        ?= $(addprefix ../, $(shell jq -r .cert $(SETTINGS)))
URL_PRIV        ?= $(addprefix ../, $(shell jq -r .priv $(SETTINGS)))

MAIN            = src/app.js
TEST_MAIN       = test/main.js
TEST_SRC        = test/test_asdf.js
TEST_FUNC       = test_fn/main.py
PY_CACHE        = test_fn/__pycache__

MKDIR           = mkdir -p
PYTHON          = python3
NODE            = node
NPM             = npm
PYCOV           = coverage

.PHONY: all build test cov

all: build

# install npm deps
build: .build-npm
	@echo "built npm dependencies"

.build-npm:
	@echo "installing express:"
	cd $(dir $(MAIN)); \
		$(NPM) install
	@echo "building openmct/dist/openmct.js"
	cd $(dir $(MAIN)); \
		git clone --depth=1 $(URL_OPENMCT); \
		pushd openmct; \
		$(NPM) install; \
		[ ! -d dist ] && $(NPM) run build:prod; \
		popd
	@touch .build-npm

run: .build-npm
	cd $(dir $(MAIN)); \
	$(NODE) $(notdir $(MAIN)) \
		--host "0.0.0.0" --port $(DEFAULT_PORT) \
		--cert "$(URL_CERT)" \
		--priv "$(URL_PRIV)"

# run tests and functional tests
test: $(TEST_MAIN) $(TEST_SRC) $(TEST_FUNC)
	@echo "testing:"
	#$(NODE) -m $(TEST_MOD)
	@echo "functional testing:"
	#$(PYTHON) $(TEST_FUNC)

# run coverage
cov:
	@echo "testing:"
	#$(NODE) -m $(TEST_MOD)
	@echo "functional testing:"
	#$(PYTHON) $(TEST_FUNC)
	@echo -e "\nchecking coverage:"
	#$(PYCOV) report

# remove objects and executable
clean:
	$(RM) -r $(PY_CACHE) #.coverage
	$(RM) -r $(dir $(MAIN))/package-lock.json $(dir $(MAIN))/node_modules
	$(RM) -r .build-npm

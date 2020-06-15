# Makefile for database
# usage: make [DEFAULT_PORT=<num> run]
# make test: compares expected to actual output
# make cov:  runs tests and checks line coverage

SETTINGS        = settings.json
VERSION         ?= $(shell jq -r .version $(SETTINGS))
DEFAULT_PORT    ?= $(shell jq -r .port $(SETTINGS))
URL_CERT        ?= $(addprefix ../, $(shell jq -r .cert $(SETTINGS)))
URL_PRIV        ?= $(addprefix ../, $(shell jq -r .priv $(SETTINGS)))

MAIN            = src/database.py
TEST_MAIN       = test/main.py
TEST_MOD        = $(subst /,.,$(patsubst %.py,%,$(TEST_MAIN)))
TEST_SRC        = test/test_asdf.py
TEST_FUNC       = test_fn/main.py
PY_CACHE        = $(addsuffix __pycache__, src/ test/ test_fn/)

MKDIR           = mkdir -p
PYTHON          = python3
PYCOV           = coverage

.PHONY: all test cov

all:

run:
	cd $(dir $(MAIN)); \
		FLASK_ENV=development $(PYTHON) $(notdir $(MAIN)) \
		--host 0.0.0.0 --port $(DEFAULT_PORT) \
		--cert "$(URL_CERT)" \
		--priv "$(URL_PRIV)"

# run tests and functional tests
test: $(TEST_MAIN) $(TEST_SRC) $(TEST_FUNC)
	@echo "testing:"
	$(PYTHON) -m $(TEST_MOD)
	@echo "functional testing:"
	$(PYTHON) $(TEST_FUNC)


# run coverage
__comma :=
__space := $(__comma) $(__comma)
__comma := ,
cov:
	@echo "testing:"
	$(PYCOV) run --omit="$(subst $(__space),$(__comma),$(TEST_SRC) $(TEST_MAIN))" -m $(TEST_MOD)
	@echo "functional testing:"
	$(PYTHON) $(TEST_FUNC)
	@echo -e "\nchecking coverage:"
	$(PYCOV) report

# remove objects and executable
clean:
	$(RM) -r $(PY_CACHE) .coverage

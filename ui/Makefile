# Makefile for ui
# usage: make [FLAGS=<flags>]
# make test: compares expected to actual output
# make cov:  runs tests and checks line coverage

FLAGS ?= -D VERSION=\"0.0.0\" -D DEFAULT_PORT=4443

MAIN            = src/ui.js
TEST_MAIN       = test/main.js
TEST_SRC        = test/test_asdf.js
TEST_FUNC       = test_fn/main.py
PY_CACHE        = test_fn/__pycache__

MKDIR           = mkdir -p
PYTHON          = python3
NODE            = node
PYCOV           = coverage

.PHONY: all test cov

all:

# run tests and functional tests
test: $(TEST_MAIN) $(TEST_SRC) $(TEST_FUNC)
	@echo "testing:"
	#$(NODE) -m $(TEST_MOD)
	@echo "functional testing:"
	$(PYTHON) $(TEST_FUNC)


# run coverage
cov:
	@echo "testing:"
	#$(PYCOV) run --omit="$(subst $(__space),$(__comma),$(TEST_SRC) $(TEST_MAIN))" -m $(TEST_MOD)
	@echo "functional testing:"
	$(PYTHON) $(TEST_FUNC)
	@echo -e "\nchecking coverage:"
	#$(PYCOV) report

# remove objects and executable
clean:
	$(RM) -r $(PY_CACHE) #.coverage

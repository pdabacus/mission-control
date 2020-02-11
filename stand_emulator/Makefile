# Makefile for a.out
# usage: make [FLAGS=<flags>]
# make test: compares expected to actual output
# make cov:  rebuilds project, runs tests and checks line coverage

#FLAGS=-D VERSION=\"1.0.0\" -D DEFAULT_PORT=6969

BIN             = bin
MAIN            = src/main.cpp
SOURCES         =
HEADERS         =
TARGET          = a.out

TEST_MAIN       = test/main.cpp
TEST_SOURCES    =
TEST_HEADERS    =
TARGET_TEST     = a.out-test

GCCOPTS         = -Wall -Wextra -pedantic -ansi -std=c99
GXXOPTS         = -Wall -Wextra -pedantic -ansi -std=c++11 -g
LDLIBS          =
CCOPTS          = $(GCCOPTS) $(CCFLAGS) $(FLAGS)
CXXOPTS         = $(GXXOPTS) $(CXXFLAGS) $(FLAGS)

OBJ             = $(patsubst %.cpp,$(BIN)/%.o,$(SOURCES))
TEST_OBJ        = $(patsubst %.cpp,$(BIN)/%.o,$(TEST_SOURCES))
MAIN_OBJ        = $(patsubst %.cpp,$(BIN)/%.o,$(MAIN))
TEST_MAIN_OBJ   = $(patsubst %.cpp,$(BIN)/%.o,$(TEST_MAIN))

TARGET_COV      = a.out-cov
GCOV            = gcov
MKDIR           = mkdir -p
COVOPTS         = -fprofile-arcs -ftest-coverage
GCOVOPTS        = -b -n
GCOVPRNT        = grep -A 4 "\.cpp" | grep -v "/usr/include" \
                | sed -E '/^No.*/d' | sed -E 's/(^Lin|^Bra|^Tak|^Cal)/    \1/'

COV_DA          = $(patsubst %.cpp,$(BIN)/%.gcda,$(SOURCES)) \
                $(patsubst %.cpp,$(BIN)/%.gcda,$(TEST_SOURCES)) \
                $(patsubst %.cpp,$(BIN)/%.gcda,$(TEST_MAIN))

COV_NO          = $(patsubst %.cpp,$(BIN)/%.gcno,$(SOURCES)) \
                $(patsubst %.cpp,$(BIN)/%.gcno,$(TEST_SOURCES)) \
                $(patsubst %.cpp,$(BIN)/%.gcno,$(TEST_MAIN)) \

all:            $(TARGET)

# compile .c source files to objects (.o)
$(BIN)/%.o: %.c $(HEADERS) $(TEST_HEADERS)
	@$(MKDIR) $(@D)
	$(CC) $(CCOPTS) -o $@ -c $<

# compile .cpp source files to objects (.o)
$(BIN)/%.o: %.cpp $(HEADERS) $(TEST_HEADERS)
	@$(MKDIR) $(@D)
	$(CXX) $(CXXOPTS) -o $@ -c $<

# link executable
$(TARGET): $(OBJ) $(MAIN_OBJ)
	$(CXX) $(CXXOPTS) -o $@ $^ $(LDLIBS)
	@echo "binary compiled: '$(TARGET)'"

# link test executable
$(TARGET_TEST): $(OBJ) $(TEST_OBJ) $(TEST_MAIN_OBJ)
	$(CXX) $(CXXOPTS) -o $@ $^ $(LDLIBS)
	@echo "binary compiled: '$(TARGET_TEST)'"

# run test executable
test: $(TARGET_TEST)
	@echo "testing:"
	./$(TARGET_TEST)

# compile .c source files to objects (.o) with line coverage on
$(BIN)/%.gcda: %.c
	@$(MKDIR) $(@D)
	$(CC) $(CCOPTS) $(COVOPTS) -o $(patsubst %.gcda,%.o,$@) -c $<

# compile .cpp source files to objects (.o) with line coverage on
$(BIN)/%.gcda: %.cpp
	@$(MKDIR) $(@D)
	$(CXX) $(CXXOPTS) $(COVOPTS) -o $(patsubst %.gcda,%.o,$@) -c $<

# link executable with line coverage on
$(TARGET_COV): $(COV_DA) $(COV_NO)
	$(CXX) $(CXXOPTS) $(COVOPTS) -o $@ $(OBJ) $(TEST_OBJ) $(TEST_MAIN_OBJ) $(LDLIBS)
	@echo "binary compiled: '$(TARGET_COV)'"

cov: $(TARGET_COV)
	@echo "testing:"
	./$(TARGET_COV)
	@echo -e "\nchecking coverage '$(TARGET_COV)':"
	@$(GCOV) $(GCOVOPTS) $(COV_DA) | $(GCOVPRNT)

# remove objects and executable
.PHONY: clean
clean:
				$(RM) $(TARGET) $(OBJ) $(MAIN_OBJ)
				$(RM) $(TARGET_TEST) $(TEST_OBJ) $(TEST_MAIN_OBJ)
				$(RM) $(TARGET_COV) $(COV_DA) $(COV_NO)
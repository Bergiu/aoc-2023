SRC_DIR := $(wildcard day*/part*.nim)
EXE_FILES := $(patsubst %.nim,%,$(SRC_DIR))
TEST_FILES := $(wildcard */test_*.nim)
TEST_RESULTS := $(patsubst %.nim,%,$(TEST_FILES))

.PHONY: all compile run test clean

all: compile run test

compile: $(EXE_FILES)

%: %.nim
	nim c $<

run: compile
	@if [ -z "$(filter $(MAKECMDGOALS), $(EXE_FILES))" ]; then \
		echo "Running all executable files..."; \
		for file in $(EXE_FILES); do \
			echo "Running $$file..."; \
			(cd $${file%/*} && ./$$(basename $$file)); \
		done \
	else \
		for file in $(filter $(MAKECMDGOALS), $(EXE_FILES)); do \
			echo "Running $$file..."; \
			(cd $${file%/*} && ./$$(basename $$file)); \
		done \
	fi

test: compile
	@echo "Running tests..."; \
	testament pattern "*/test_*.nim"

clean:
	@echo "Cleaning up..."
	@rm -f $(EXE_FILES) $(TEST_RESULTS)

clean-all: clean
	@rm -rf nimcache
	@rm -rf testresults

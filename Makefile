SRC_DIRS = ${shell find . -maxdepth 2 -name "main.ha" -exec bash -c 'readlink -f $$(dirname {})' \; | sort }
SRC_FILES = ${shell find . -name "*.ha" -exec readlink -f {} \; }
TARGET_DIRS = ${shell printf '%s\n' "${SRC_DIRS}" | sed 's/[^[:space:]]\{1,\}/&\/target/g' }
BUILD_FILES = ${shell printf '%s\n' "${TARGET_DIRS}" | sed 's/[^[:space:]]\{1,\}/&\/bin/g' }

.PHONY: run
run: ${BUILD_FILES}
	@for SRC_DIR in ${SRC_DIRS} ; do \
		cd $$SRC_DIR && ./target/bin; \
	done

.PHONY: build
build: ${BUILD_FILES}

${BUILD_FILES}: ${SRC_FILES} ${TARGET_DIRS}
	@for SRC_DIR in ${SRC_DIRS} ; do \
	    hare build -o $$SRC_DIR/target/bin $$SRC_DIR/main.ha ; \
	done

${TARGET_DIRS}:
	@mkdir $@

${SRC_FILES}:
	@touch %@
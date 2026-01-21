UNHINGEDC_BOOT := build/bootstrap
UNHINGEDC_STAGE1 := build/stage1
UNHINGEDC := build/unhingedc
TEST_BIN := build/tests

.PHONY: build test clean

build:
	@mkdir -p build
	cargo build --release --manifest-path bootstrap/Cargo.toml
	cp bootstrap/target/release/unhingedc $(UNHINGEDC_BOOT)
	$(UNHINGEDC_BOOT) compiler/src/main.uh -o $(UNHINGEDC_STAGE1)
	$(UNHINGEDC_STAGE1) compiler/src/main.uh $(UNHINGEDC)

test: build
	UNHINGEDC=$(UNHINGEDC) $(UNHINGEDC) tests/tests.uh $(TEST_BIN)
	$(TEST_BIN)

clean:
	rm -rf build output bootstrap/target
	rm -f runtime/*.o

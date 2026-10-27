UNHINGEDC_BOOT := build/bootstrap
UNHINGEDC_STAGE1 := build/stage1
UNHINGEDC := build/unhingedc
TEST_BIN := build/tests
TRITHC := build/trithc
TRITH_TESTS := build/trith-tests
.PHONY: build test clean trith trith-test trith-bench

build:
	@mkdir -p build
	cargo build --release --manifest-path bootstrap/Cargo.toml
	cp bootstrap/target/release/unhingedc $(UNHINGEDC_BOOT)
	$(UNHINGEDC_BOOT) compiler/src/main.uh -o $(UNHINGEDC_STAGE1)
	$(UNHINGEDC_STAGE1) compiler/src/main.uh $(UNHINGEDC)

test: build trith-test
	UNHINGEDC=$(UNHINGEDC) $(UNHINGEDC) tests/tests.uh $(TEST_BIN)
	$(TEST_BIN)

# Trith (v2): trithc is written in UNHINGED and compiled by the v1 compiler (spec §17, stage s1)
trith: build
	$(UNHINGEDC) trith/src/main.uh $(TRITHC)

trith-test: trith
	@mkdir -p output
	$(UNHINGEDC) trith/tests/run.uh $(TRITH_TESTS)
	TRITHC=$(TRITHC) $(TRITH_TESTS) | tee output/trith-tests.log
	@! grep -q '^FAIL' output/trith-tests.log

# benchmark gate (spec §17): each program within 1.5× of clang -O2 C
trith-bench: trith
	TRITHC=$(TRITHC) trith/bench/run.sh

clean:
	rm -rf build output bootstrap/target

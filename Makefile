UNHINGEDC_BOOT := build/bootstrap
UNHINGEDC_STAGE1 := build/stage1
UNHINGEDC := build/unhingedc
TEST_BIN := build/tests
TRITHC := build/trithc
TRITH_TESTS := build/trith-tests
.PHONY: build test clean trith trith-test trith-bench trith-memcheck s2 s2-regen s2-test s2-fuzz s3 s2-fixpoint

build:
	@mkdir -p build
	cargo build --release --manifest-path bootstrap/Cargo.toml
	cp bootstrap/target/release/unhingedc $(UNHINGEDC_BOOT)
	$(UNHINGEDC_BOOT) compiler/src/main.uh -o $(UNHINGEDC_STAGE1)
	$(UNHINGEDC_STAGE1) compiler/src/main.uh $(UNHINGEDC)

test: build trith-test s2-test s2-fixpoint
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

# valgrind over every program in trith/tests/run (needs valgrind)
trith-memcheck: trith
	TRITHC=$(TRITHC) trith/tests/memcheck.sh

# benchmark gate (spec §17): each program within 1.5× of clang -O2 C
trith-bench: trith
	TRITHC=$(TRITHC) trith/bench/run.sh

clean:
	rm -rf build output bootstrap/target

# s2: the compiler rewritten in Trith (spec §17), compiled by s1. The sources
# in trith/s2/src are authored in logical order with named moments; the
# committed trith/s2/s2c.trh is generated from them by `make s2-regen`.
S2_SRC := trith/s2/src/util.trhx trith/s2/src/chars.trhx trith/s2/src/lexer.trhx trith/s2/src/parser.trhx trith/s2/src/heap.trhx trith/s2/src/types.trhx trith/s2/src/check.trhx trith/s2/src/emit.trhx trith/s2/src/eval.trhx trith/s2/src/main.trhx
s2: trith
	$(TRITHC) trith/s2/s2c.trh -o build/s2c

s2-regen: trith
	python3 trith/s2/tools/trx.py $(S2_SRC) > build/s2c.logical.trh
	$(TRITHC) build/s2c.logical.trh --plough > trith/s2/s2c.trh

s2-test: s2
	TRITHC=$(TRITHC) S2C=build/s2c trith/s2/test.sh

# s3 is s2 compiled by s2; the fixpoint (spec §17) is that it emits exactly what
# s2 emits, for its own source and for every test
s3: s2
	build/s2c trith/s2/s2c.trh -o build/s3c

s2-fixpoint: s3
	@mkdir -p output
	build/s2c trith/s2/s2c.trh --emit-llvm > output/s2.ll
	build/s3c trith/s2/s2c.trh --emit-llvm > output/s3.ll
	cmp output/s2.ll output/s3.ll
	cmp build/s2c build/s3c
	@echo "fixpoint: s3 emits exactly what s2 emits, and is the same executable"
	TRITHC=$(TRITHC) S2C=build/s3c trith/s2/test.sh

s2-fuzz: s2
	python3 trith/s2/tools/fuzz.py build/s2c $(TRITHC) output/s2-fuzz 1 1000
	python3 trith/s2/tools/fuzzparse.py build/s2c $(TRITHC) output/s2-fuzzparse 1 500
	python3 trith/s2/tools/fuzzcheck.py build/s2c $(TRITHC) output/s2-fuzzcheck 1 300

UNHINGEDC_BOOT := build/bootstrap
UNHINGEDC_STAGE1 := build/stage1
UNHINGEDC := build/unhingedc
TEST_BIN := build/tests
TRITHC := build/trithc
TRITH_TESTS := build/trith-tests
.PHONY: build test clean trith trith-test trith-bench trith-memcheck s2 s2-regen s2-test s2-fuzz

build:
	@mkdir -p build
	cargo build --release --manifest-path bootstrap/Cargo.toml
	cp bootstrap/target/release/unhingedc $(UNHINGEDC_BOOT)
	$(UNHINGEDC_BOOT) compiler/src/main.uh -o $(UNHINGEDC_STAGE1)
	$(UNHINGEDC_STAGE1) compiler/src/main.uh $(UNHINGEDC)

test: build trith-test s2-test
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
# committed trith/s2/*.trh are generated from them by `make s2-regen`.
S2_LEX_SRC := trith/s2/src/util.trhx trith/s2/src/chars.trhx trith/s2/src/lexer.trhx trith/s2/src/lexmain.trhx
s2: trith
	$(TRITHC) trith/s2/s2lex.trh -o build/s2lex

s2-regen: trith
	python3 trith/s2/tools/trx.py $(S2_LEX_SRC) > build/s2lex.logical.trh
	$(TRITHC) build/s2lex.logical.trh --plough > trith/s2/s2lex.trh

s2-test: s2
	TRITHC=$(TRITHC) S2LEX=build/s2lex trith/s2/test.sh

s2-fuzz: s2
	python3 trith/s2/tools/fuzz.py build/s2lex $(TRITHC) output/s2-fuzz 1 1000

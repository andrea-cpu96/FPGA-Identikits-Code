# Verification record

## Current manuscript synchronization — 2026-10-30

All **105 / 105 standalone identikits** passed again in fresh individual
ModelSim libraries (VHDL-2008, 1 ps resolution). The updated
[simulation results](modelsim-results-2026-10-30.json) record the exact RTL
and testbench hashes used for this run.

The independent [source-sync audit](book-sync.json) covers all **105 identikits
in 40 groups** against manuscript commit
`362b1e31e24416ef47e7121361340b702393bcb6`. It checks current source listings,
chapter membership and ordering, identikit numbers and titles, manifest
hashes, README navigation, and testbench identification. No identikits were
missing and no RTL changes were needed. Usage notes were refreshed from the
current manuscript, and stale group names and testbench numbers were corrected.
Existing folder URLs were preserved; the current book numbers are in the
manifest and READMEs, not necessarily in legacy folder prefixes.

Reproduce the checks from this repository's root:

```text
python scripts/check_book_sync.py --book ../FPGA-Digital-Blocks-Identikit
python -m unittest discover -s tests -v
python scripts/run_tests.py
```

The source-sync check has seven regression tests, including missing entries,
RTL drift, stale numbering, and outdated navigation. It does not compare all
prose or replace simulation. Simulator tests still cover representative
configurations, not all possible parameters or physical implementation behavior.

## Historical baseline

Verified on 2026-10-11 with ModelSim Intel FPGA Starter Edition 2020.1,
VHDL-2008, 1 ps resolution: **100 / 100 standalone identikits passed**.

[Machine-readable results](modelsim-results.json) record each exact RTL and
testbench hash (UTF-8 text with LF line endings). The run compiled each pair in its own work library. The source
hashes match the manuscript snapshot at book commit `41c5547`.

Run `python scripts/run_tests.py` at the repository root to reproduce the tests.
The locally generated logs and results go to `build/`, which is ignored by Git.
A modified source's hash is reported by the runner. The checked-in record applies
only to the hashes listed here, not to subsequent modifications.

The checks exercise representative parameters, reference-model outputs, resets,
protocol behavior and relevant boundary cases; consult each README and testbench
for its actual scope. No exhaustive, formal, synthesis or hardware validation
claim is made. The GHDL runner option has not been validated locally.


## Digital Filters update — 2026-10-18

All 105 identikits pass in fresh individual ModelSim libraries; see
[filters-results.json](filters-results.json). Added moving average, signed FIR
and first-order IIR tests. Existing RTL and testbench files were retained;
book numbering was updated while keeping existing folder links stable.

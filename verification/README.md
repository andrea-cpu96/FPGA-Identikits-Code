# Verification record

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

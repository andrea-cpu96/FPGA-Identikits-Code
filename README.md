# FPGA Identikits â€” companion code

VHDL reference implementations and self-checking testbenches for **FPGA
Identikits: A Practical VHDL Reference for Digital Building Blocks**, by Andrea
Fato.

This repository contains **100 identikits in 38 groups**, following the book's
section numbering. Every identikit folder contains its own RTL, testbench and
README. The README explains the interface, local usage requirements, test
configurations and how to run the example. Each testbench runs independently;
no other identikit's RTL is needed.

## Start here

1. Choose a group below, then open an identikit's README.
2. Read its interface and usage requirements before adapting the RTL.
3. Run the supplied testbench, then add cases for your own parameters and
   surrounding protocol.

The code matches the book's reference templates. It is portable RTL intended
for adaptation, not a collection of device-specific pin assignments or complete
board projects. You supply clocks, constraints and integration appropriate to
your FPGA and toolchain.

## Run the tests

Use Python 3.9+ and ModelSim/Questa with `vlib`, `vcom` and `vsim` on PATH:

```text
python scripts/run_tests.py
python scripts/run_tests.py --identikit d-flip-flop
python scripts/run_tests.py --group 06-01-d-registers
```

Each identikit is compiled in a separate library under `build/`. A passing test
prints `PASS`; assertion failures, compile errors, missing completion and timeout
are failures. Logs and the machine-readable summary are in `build/`.

The runner also accepts `--simulator ghdl` for a GHDL installation supporting
VHDL-2008. The checked-in verification record was produced with ModelSim; the
GHDL route has not been validated in this release.

## Groups

| Book section | Identikit group | Blocks |
|---|---|---|
| 1.1 | [Multiplexing & Demultiplexing](01-01-multiplexing-demultiplexing/) | 4 |
| 1.2 | [Shared I/O](01-02-shared-i-o/) | 1 |
| 2.1 | [Code selection and representation](02-01-code-selection-and-representation/) | 4 |
| 3.1 | [Word equality and ordering](03-01-word-equality-and-ordering/) | 2 |
| 4.1 | [Representation, checking, and display](04-01-representation-checking-and-display/) | 6 |
| 5.1 | [Variable combinational shifting](05-01-variable-combinational-shifting/) | 3 |
| 6.1 | [D Registers](06-01-d-registers/) | 8 |
| 6.2 | [Latches](06-02-latches/) | 1 |
| 6.3 | [T / JK / SR](06-03-t-jk-sr/) | 3 |
| 6.4 | [Pipeline](06-04-pipeline/) | 1 |
| 7.1 | [Serial I/O](07-01-serial-i-o/) | 4 |
| 7.2 | [Parallel / Universal](07-02-parallel-universal/) | 3 |
| 7.3 | [Feedback](07-03-feedback/) | 4 |
| 7.4 | [Special](07-04-special/) | 2 |
| 8.1 | [Basic Counters](08-01-basic-counters/) | 3 |
| 8.2 | [Up / Down](08-02-up-down/) | 3 |
| 8.3 | [Encoded](08-03-encoded/) | 2 |
| 9.1 | [Intervals & Timeouts](09-01-intervals-timeouts/) | 3 |
| 9.2 | [Periodic Events & Waveforms](09-02-periodic-events-waveforms/) | 3 |
| 10.1 | [Moore](10-01-moore/) | 2 |
| 10.2 | [Mealy](10-02-mealy/) | 2 |
| 11.1 | [Unsigned word arithmetic](11-01-unsigned-word-arithmetic/) | 3 |
| 11.2 | [Signed word arithmetic](11-02-signed-word-arithmetic/) | 1 |
| 12.1 | [Products and accumulated products](12-01-products-and-accumulated-products/) | 3 |
| 13.1 | [Fixed scaling and iterative division](13-01-fixed-scaling-and-iterative-division/) | 2 |
| 14.1 | [Running sums, limits, and magnitudes](14-01-running-sums-limits-and-magnitudes/) | 3 |
| 15.1 | [Registered-read memory ports](15-01-registered-read-memory-ports/) | 3 |
| 15.2 | [Register files](15-02-register-files/) | 1 |
| 16.1 | [Inline contents and registered reads](16-01-inline-contents-and-registered-reads/) | 1 |
| 17.1 | [Keeping a stream in order](17-01-keeping-a-stream-in-order/) | 2 |
| 18.1 | [Turn a button press into one clean action](18-01-turn-a-button-press-into-one-clean-action/) | 2 |
| 19.1 | [Levels, events, and reset release](19-01-levels-events-and-reset-release/) | 3 |
| 19.2 | [Coherent word transfers](19-02-coherent-word-transfers/) | 1 |
| 20.1 | [Ready/valid buffering](20-01-ready-valid-buffering/) | 2 |
| 20.2 | [Arbitration](20-02-arbitration/) | 2 |
| 21.1 | [Sampled transitions](21-01-sampled-transitions/) | 3 |
| 22.1 | [Generated clocks and periodic enables](22-01-generated-clocks-and-periodic-enables/) | 3 |
| 23.1 | [Streaming frame checks](23-01-streaming-frame-checks/) | 1 |

## Verification and limits

All 100 standalone testbenches pass with ModelSim Intel FPGA Starter Edition
2020.1 (VHDL-2008), recorded on 2026-10-11. See
[the verification record](verification/README.md). Tests include mathematical
reference models, protocol scoreboards and directed boundary cases as appropriate
to the block. This is not exhaustive verification of all parameter combinations.

Functional simulation does not establish target-specific synthesis mapping,
timing closure, analog metastability reliability or board-level electrical
behavior. Read each block's requirements and the implementation guidance in the
book before integrating it. Intentional invalid-input tests may emit warnings;
failure assertions are never ignored.

## Book and origins

- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit)
- [Andrea Fato's online VHDL Cookbook](https://andrea-cpu96.github.io/vhdl-cookbook/),
  the earlier project from which the book developed.

`manifest.json` maps every folder to its book identikit and records its RTL hash.
The initial RTL snapshot corresponds to the book sources at commit `41c5547`.
The book repository's `scripts/export_companion.py` maintains the source mapping.

## Licensing

Copyright (c) 2026 Andrea Fato. This companion repository's VHDL, testbenches,
scripts and documentation are released under the [MIT License](LICENSE).
You may use and adapt them in educational, open-source and commercial projects,
including proprietary designs. Retain the copyright and permission notice in
copies or substantial portions of the software. The software is provided without
warranty; see the licence for the full terms.

This licence covers the companion repository. It does not license the book's
prose, illustrations, cover artwork or PDF editions.

# 4.1.1 — Parity generator / checker

XOR-reduces a data word to generate its even-parity bit and compares that bit with received parity. A mismatch reports corruption that changed an odd number of bits; the block neither locates nor corrects an error.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Know what parity detects.** Starting from a valid frame, any odd number of changed positions across the protected payload and its parity bit is detected. Any even number preserves the parity relation and is not detected. Parity gives neither the damaged position nor a correction value; use a stronger code when the system needs those properties.

**Protect the intended word.** The sender and receiver must protect the same bits. Decide whether headers and padding belong in `data`; supply the separate parity bit through `parity_in`. Otherwise, the receiver checks a different word.

**Sample the error flag with the word.** The `error` flag reports the current XOR relation after combinational settling. Input skew can create short pulses, so do not use it as a clock or asynchronous reset. Register it with the received word when a timing-qualified indication is required.

**Parity is not a CDC protocol.** A parity bit can expose some incoherent captures but cannot make an asynchronous bus safe. Transfer data and parity together with an appropriate handshake, FIFO, or source-synchronous scheme.

## Files

- [`parity_generator_checker.vhd`](parity_generator_checker.vhd): synthesizable reference template (VHDL-2008).
- [`tb_parity_generator_checker.vhd`](tb_parity_generator_checker.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit parity-generator-checker
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_parity_generator_checker`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_parity_generator_checker`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Pop parity.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity parity_generator_checker is
    generic (W : positive := 8);
    port (
        data       : in  std_logic_vector(W-1 downto 0);
        parity_in  : in  std_logic;
        parity_out : out std_logic;
        error      : out std_logic
    );
end entity parity_generator_checker;
```

## Source traceability

- Book identikit: **4.1.1**.
- Book source: `components/parity-generator-checker.tex`.
- RTL SHA-256 (UTF-8, LF): `84165e9ae62f088a6bd95e55d0ffac8d0ea8ac66b42bbf2c4051e253394afc79`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

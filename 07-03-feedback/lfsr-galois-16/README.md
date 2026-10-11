# 7.3.4 — 16-bit Galois LFSR

Generates a 65,535-state pseudorandom cycle by shifting right and conditionally XORing a tap mask when the outgoing bit is one. Feedback is distributed among several stages instead of being reduced through one external XOR tree.

Companion to *FPGA Identikits* by Andrea Fato, group **7.3 — Feedback**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**The mask encodes the recurrence.** `B400` is correct for these logical stages and this right shift. A left shift or a different mapping from indices to stages requires a re-derived mask and reference trace. Merely observing another state bit leaves the recurrence unchanged; document the new serial stream and its phase instead.

**Never use the zero seed.** Reset loads `0001`. A programmable seed interface must reject or replace zero; normal feedback cannot escape it.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Galois and Fibonacci states differ.** The two forms implement the same polynomial family but do not produce identical internal words edge by edge from the same visible seed. Verify each against its own recurrence.

**Distributed feedback can shorten XOR depth.** That may improve timing, but actual mapping depends on the target and synthesis tool. The sequence is still linear and is not suitable for cryptographic randomness.

## Files

- [`lfsr_galois_16.vhd`](lfsr_galois_16.vhd): synthesizable reference template (VHDL-2008).
- [`tb_lfsr_galois_16.vhd`](tb_lfsr_galois_16.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit lfsr-galois-16
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_lfsr_galois_16`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_lfsr_galois_16`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `fixed 16-bit recurrence`

Checks include:
- Maximal nonzero cycle.
- Period 65535.
- Recurrence.
- Reset seed.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity lfsr_galois_16 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(15 downto 0)
    );
end entity lfsr_galois_16;
```

## Source traceability

- Book identikit: **7.3.4**.
- Book source: `components/lfsr-galois-16.tex`.
- RTL SHA-256 (UTF-8, LF): `e91bcbb7143fc44589d65a441d44b1a16218e5c46c2aff98e8f6f77f9de23d67`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

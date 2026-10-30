# 14.1.2 — Saturating adder

Adds two unsigned words and clamps the output to the largest N-bit value when the exact sum is too large. This combinational block has no clock or memory: the output follows the current operands, not an earlier saturated result.

Companion to *FPGA Identikits* by Andrea Fato, group **14.1 — Running sums, limits, and magnitudes**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Widen before adding.** Zero-extend both operands to N+1 bits before addition. The extra result bit then reports unsigned overflow. If the addition is performed in N bits first, the carry is lost and a later resize cannot recover it.

**Do not infer a status flag from the result.** An all-ones output may be the exact sum or the limit substituted after overflow. Expose the internal carry separately if the consumer needs to distinguish them. This block clamps the current result only; it does not store a history of earlier overflows.

**Signed saturation needs different limits.** Saturating two's-complement addition needs signed-overflow detection and separate positive and negative bounds. An unsigned carry alone does not select the correct signed limit. Keep this template's operands and output unsigned throughout the surrounding datapath.

**Register the result when glitches matter.** The adder and output selection are combinational and can glitch while inputs change. Register the result when a stable cycle value is needed. Non-binary inputs follow `numeric_std` arithmetic; there is no custom warning or zero fallback.

## Files

- [`saturating_adder.vhd`](saturating_adder.vhd): synthesizable reference template (VHDL-2008).
- [`tb_saturating_adder.vhd`](tb_saturating_adder.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit saturating-adder
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_saturating_adder`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_saturating_adder`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Sat abs product.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity saturating_adder is
    generic (N : positive := 8);
    port (
        a, b : in std_logic_vector(N-1 downto 0);
        sum : out std_logic_vector(N-1 downto 0)
    );
end entity saturating_adder;
```

## Source traceability

- Book identikit: **14.1.2**.
- Book source: `components/saturating-adder.tex`.
- RTL SHA-256 (UTF-8, LF): `5f6eb7b3a34eaee820b498866e5106e9e4fc9cbb6f3c2139859720b783ecb91f`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 11.1.2 — Subtractor with borrow-out

Subtracts one unsigned word from another. The W-bit difference wraps modulo $2^W$ when a < b; a separate borrow output reports that underflow. The result changes combinationally and has no stored state.

Companion to *FPGA Identikits* by Andrea Fato, group **11.1 — Unsigned word arithmetic**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Extend before subtracting.** The leading zeros make a $(W+1)$-bit subtraction. The most-significant result bit then reveals unsigned underflow; subtracting only W bits would discard it. This block has no borrow-in input.

**Distinguish borrow from signed overflow.** Borrow is an unsigned relation. If the same operands are interpreted as signed, use a separate signed-overflow rule and sign extension.

**Keep result and status together.** The difference and borrow travel through paths with different delays, so they may briefly describe different input values during a transition. When a consumer needs the result of one transaction, capture both together after they have settled.

**Make invalid data visible.** Strict binary validation warns and drives zero for unknown or weak simulation inputs. Zero is also a valid result; only the warning distinguishes this fallback in simulation. This policy is not a substitute for a coherent clock-domain transfer.

## Files

- [`subtractor_with_borrow.vhd`](subtractor_with_borrow.vhd): synthesizable reference template (VHDL-2008).
- [`tb_subtractor_with_borrow.vhd`](tb_subtractor_with_borrow.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit subtractor-with-borrow
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_subtractor_with_borrow`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_subtractor_with_borrow`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Subtract.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity subtractor_with_borrow is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        diff   : out std_logic_vector(W-1 downto 0);
        borrow : out std_logic
    );
end entity subtractor_with_borrow;
```

## Source traceability

- Book identikit: **11.1.2**.
- Book source: `components/subtractor-with-borrow.tex`.
- RTL SHA-256 (UTF-8, LF): `cb0d4080eec27448f789547994715c7bf28a436862cfda20711ae9fbeff553a4`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

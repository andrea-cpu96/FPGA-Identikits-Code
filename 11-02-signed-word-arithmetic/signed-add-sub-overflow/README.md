# 11.2.1 — Signed add/subtract with overflow

Adds or subtracts two W-bit two's-complement words and returns the wrapped W-bit result. The ovf output is '1' when the exact answer lies outside the signed range $-2^{W-1}\ldots2^{W-1}-1$.

Companion to *FPGA Identikits* by Andrea Fato, group **11.2 — Signed word arithmetic**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep signed and unsigned status apart.** Carry and borrow come from bit W of the zero-extended sum or difference; signed overflow compares sign bits. Neither flag can be derived from the other, so a unit serving both interpretations needs both.

**The wrapped pattern is still the result.** On overflow, `result` keeps the modulo-$2^W$ pattern with the wrong sign. Saturate, widen the result, or act on `ovf` before downstream logic trusts the value.

**Watch the most negative value.** $-2^{W-1}$ has no positive counterpart in W bits, so $0-(-2^{W-1})$ overflows. Negation and absolute value built from this unit inherit that case.

**Register result and flag together.** The block is combinational; capture `result` and `ovf` on the same edge. Non-binary inputs warn and force both low, so `ovf='0'` alone does not prove a valid input; the fallback does not cure metastability.

## Files

- [`signed_add_sub.vhd`](signed_add_sub.vhd): synthesizable reference template (VHDL-2008).
- [`tb_signed_add_sub.vhd`](tb_signed_add_sub.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit signed-add-sub-overflow
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_signed_add_sub`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_signed_add_sub`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Signed overflow.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity signed_add_sub is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        op     : in  std_logic;
        result : out std_logic_vector(W-1 downto 0);
        ovf    : out std_logic
    );
end entity signed_add_sub;
```

## Source traceability

- Book identikit: **11.2.1**.
- Book source: `components/signed-add-sub-overflow.tex`.
- RTL SHA-256 (UTF-8, LF): `4af87d1807530c0bc67e8474d6a2740b82d6aac9551f8be6b77ab8415cf77d73`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

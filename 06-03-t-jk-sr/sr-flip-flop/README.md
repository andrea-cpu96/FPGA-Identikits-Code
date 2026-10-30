# 6.3.3 — SR flip-flop

Sets the stored bit on the rising edge when s is high and resets it when r is high. The combination s = r = '1' is invalid and must be avoided by the driving logic.

Companion to *FPGA Identikits* by Andrea Fato, group **6.3 — T / JK / SR**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reject simultaneous set and reset.** With `rst` inactive, this template holds when `s=r='1'`; other SR circuits need not behave that way. Active reset still clears the bit. The supplied RTL has no assertion, so prevent the forbidden combination and add a verification check that detects it.

**Constrain the sampled controls.** `s`, `r`, and synchronous `rst` must meet setup and hold at `clk`. Check the full source-to-register and clock-to-output-to-destination paths in static timing analysis, not only the mutual-exclusion logic.

**Shared set/reset controls affect every bit.** This SR rule controls one bit. Applying shared scalar set/reset controls to a wider register would set every bit to one or clear every bit to zero, with the same mutual-exclusion requirement. Independent per-bit control needs a different interface. For an arbitrary data word, a D register with explicit controls is usually clearer.

## Files

- [`sr_flip_flop.vhd`](sr_flip_flop.vhd): synthesizable reference template (VHDL-2008).
- [`tb_sr_flip_flop.vhd`](tb_sr_flip_flop.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit sr-flip-flop
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_sr_flip_flop`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_sr_flip_flop`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Register control.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity sr_flip_flop is
    port (
        clk : in  std_logic;
        s   : in  std_logic;
        r   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity sr_flip_flop;
```

## Source traceability

- Book identikit: **6.3.3**.
- Book source: `components/sr-flip-flop.tex`.
- RTL SHA-256 (UTF-8, LF): `88635ae9b4ab8196de39f195a1b7aede29f1f4e1f11708302c4e7cb31cc91f55`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

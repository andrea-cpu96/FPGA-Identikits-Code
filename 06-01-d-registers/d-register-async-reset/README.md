# 6.1.4 — D register — asynchronous reset

Captures a multi-bit word on every rising clock edge, but its reset is asynchronous: asserting rst clears the stored word immediately, independent of the clock.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reset crosses the clock boundary.** An asynchronous reset changes `q` between clock edges, so downstream logic must tolerate a clear at any time. Prefer a synchronous reset when the rest of the design samples only at the clock; use the async form when reset must act without waiting for a clock edge. The clear still has physical propagation delay, and the reset pulse must meet the device's minimum pulse-width requirement. When reset is inactive, captured `d` still must meet setup and hold at `clk`.

**Deassert is the hard part.** Asserting `rst` clears without waiting for a clock. Releasing it near a rising edge can violate recovery or removal timing and release bits inconsistently. Synchronize deassertion in the destination clock domain, then verify recovery/removal and reset distribution in the implemented design.

## Files

- [`d_register_async_reset.vhd`](d_register_async_reset.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_async_reset.vhd`](tb_d_register_async_reset.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-async-reset
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_async_reset`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_async_reset`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Async reset.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_register_async_reset is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_async_reset;
```

## Source traceability

- Book identikit: **6.1.4**.
- Book source: `components/d-register-async-reset.tex`.
- RTL SHA-256 (UTF-8, LF): `22a13833e5b9bcb6cd8a08e0328bfd13d33e0de43fc0c12c86ae231b9bf5969b`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

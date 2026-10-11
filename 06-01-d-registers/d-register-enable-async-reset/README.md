# 6.1.6 — D register with enable — asynchronous reset

Combines the clock-enable data path with an asynchronous reset: en gates the capture at the rising edge, while rst clears the stored word immediately, at any time.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Two independent controls.** The reset acts between edges, the enable at the edge. Reset overrides both hold and capture: `rst` clears a disabled register, and `en='0'` holds the word even after a reset pulse ends. Keep the two branches ordered, reset first, so the immediate clear always wins. When reset is inactive, `en` and any captured `d` must meet setup and hold at `clk`.

**Release must be synchronized.** Assertion may be asynchronous, but deasserting `rst` near a clock edge can violate recovery or removal timing and release different bits inconsistently. Synchronize the release in the destination clock domain; `en` does not protect against this risk.

## Files

- [`d_register_enable_async.vhd`](d_register_enable_async.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_enable_async.vhd`](tb_d_register_enable_async.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-enable-async-reset
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_enable_async`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_enable_async`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Async reset.
- Register control.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_register_enable_async is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_enable_async;
```

## Source traceability

- Book identikit: **6.1.6**.
- Book source: `components/d-register-enable-async-reset.tex`.
- RTL SHA-256 (UTF-8, LF): `7c88867938866dbec21340b0c6536096537dc5b5be3217c0c8c93b5c76129994`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

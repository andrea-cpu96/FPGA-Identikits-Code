# 6.1.8 — D register — async reset + sync set

Combines a synchronous set with an asynchronous reset. The reset wins at any moment; otherwise each rising edge either presets all ones or captures data, per the set control.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Three-way priority.** Clear, preset and data capture can be requested together, so the interface must state which wins: asynchronous reset first, then synchronous set, then normal capture. Document that order so the surrounding logic uses the same rule. With reset inactive, `set` and any captured `d` must meet setup and hold at `clk`.

**Reset release is a timing event.** Once `rst` falls, the next rising edge may preset or capture. An unsynchronized release can violate recovery or removal timing, so synchronize deassertion in the destination clock domain before relying on the synchronous set or data path.

## Files

- [`d_register_async_rst_sync_set.vhd`](d_register_async_rst_sync_set.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_async_rst_sync_set.vhd`](tb_d_register_async_rst_sync_set.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-async-reset-sync-set
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_async_rst_sync_set`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_async_rst_sync_set`; a failure assertion or timeout is a failure.
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
entity d_register_async_rst_sync_set is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        set : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_async_rst_sync_set;
```

## Source traceability

- Book identikit: **6.1.8**.
- Book source: `components/d-register-async-reset-sync-set.tex`.
- RTL SHA-256 (UTF-8, LF): `2e16bb7dc0a5c3b83d234feb49a87d153a67bbe12157b094552c2dbff6344975`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

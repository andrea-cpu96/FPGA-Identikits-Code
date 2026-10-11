# 6.1.3 — D register — synchronous reset

Captures a multi-bit word on every rising clock edge, exactly like the plain D register, but a synchronous, active-high reset clears the stored word to zero instead.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reset is sampled with the data.** Asserting or releasing `rst` changes `q` only at a rising edge; a reset pulse that fits entirely between edges is ignored. If `rst` is high on the same edge that new data arrives, reset wins and the word is cleared.

**Meet setup and hold.** Both `d` and the synchronous `rst` control must be stable around the active clock edge. Constrain the complete register-to-register path, including clock-to-output delay and the downstream register's setup requirement.

**Startup is not reset.** No initial value is declared. In simulation `q` stays `'U'` until the first edge; the power-up value in hardware is device-dependent. Drive the design through a reset sequence if a defined starting state is required.

## Files

- [`d_register_sync_reset.vhd`](d_register_sync_reset.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_sync_reset.vhd`](tb_d_register_sync_reset.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-sync-reset
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_sync_reset`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_sync_reset`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Expected output for the applied input combinations (see testbench assertions).

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_register_sync_reset is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_sync_reset;
```

## Source traceability

- Book identikit: **6.1.3**.
- Book source: `components/d-register-sync-reset.tex`.
- RTL SHA-256 (UTF-8, LF): `7ee55602f2b4e794917503de53bcf2cc27bdf92f9e4563499d3b8d55b87df3cb`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

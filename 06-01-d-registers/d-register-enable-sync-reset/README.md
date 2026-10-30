# 6.1.5 — D register with enable — synchronous reset

Captures a multi-bit word only on rising edges where the clock enable is high; while the enable is low the stored word simply holds. The reset is synchronous, active high, and has priority.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Enable is sampled at the edge.** `en` controls whether the register captures data; the clock continues running. The enable must be present and meet timing at the sampling edge, so a pulse entirely between edges can be missed. Use this clock-enable form rather than gating `clk` with ordinary logic.

**Constrain data and controls.** `d`, `en`, and synchronous `rst` must meet setup and hold at `clk`. The enabled path still needs normal register-to-register timing analysis; an inactive enable does not make a late data path safe for the next capture.

**Reset bypasses the enable.** `rst` clears `q` even when the enable is low. This is the chosen priority of this template, not a requirement that every enabled datapath register have reset. Keep the priority order reset $>$ enable $>$ data explicit in the code so synthesis implements the intended behavior.

## Files

- [`d_register_enable.vhd`](d_register_enable.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_enable.vhd`](tb_d_register_enable.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-enable-sync-reset
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_enable`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_enable`; a failure assertion or timeout is a failure.
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
entity d_register_enable is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_enable;
```

## Source traceability

- Book identikit: **6.1.5**.
- Book source: `components/d-register-enable-sync-reset.tex`.
- RTL SHA-256 (UTF-8, LF): `aaa2df844947f1247457b2b4966fee1fb72d0cafa239cef9e32830651bda92d9`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

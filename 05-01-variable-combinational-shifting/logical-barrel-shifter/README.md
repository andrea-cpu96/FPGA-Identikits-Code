# 5.1.3 — Logical barrel shifter

Shifts a word left or right by a selected amount in one combinational path. Vacated positions always receive zeros and discarded bits are lost; any amount of W or more therefore produces an all-zero result.

Companion to *FPGA Identikits* by Andrea Fato, group **5.1 — Variable combinational shifting**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Zero fill is not sign fill.** A logical right shift divides only an unsigned value by a power of two. For two's-complement data, use an arithmetic right shift; the left shift is the same bit operation for both.

**Discarded bits are silent.** Left shifts can overflow an unsigned value and right shifts truncate it; the block reports neither. Add overflow, sticky, or carry-out logic when the surrounding arithmetic needs it.

**Size the amount deliberately.** `AMT_W` sets which amounts the interface can express. If a source should never exceed W-1, check or clamp it upstream; this block treats the larger codes as a valid all-zero shift.

**Budget the routing network.** A run-time amount and direction infer multiplexer stages whose delay grows with W. Register or pipeline the result when needed, and establish coherent controls before shifting.

## Files

- [`logical_barrel_shifter.vhd`](logical_barrel_shifter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_logical_barrel_shifter.vhd`](tb_logical_barrel_shifter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit logical-barrel-shifter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_logical_barrel_shifter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_logical_barrel_shifter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,4`
- `5,4`
- `8,4`

Checks include:
- Logical shift.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity logical_barrel_shifter is
    generic (
        W     : positive := 8;
        AMT_W : positive := 4
    );
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  std_logic_vector(AMT_W-1 downto 0);
        dir : in  std_logic;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity logical_barrel_shifter;
```

## Source traceability

- Book identikit: **5.1.3**.
- Book source: `components/logical-barrel-shifter.tex`.
- RTL SHA-256 (UTF-8, LF): `69ad4d46eb4b8e53fbe886dd9c9eb07a36040e5b9f75796d41d564c27c6ab0d4`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

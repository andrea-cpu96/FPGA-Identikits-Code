# 7.2.2 — Universal shift register

Stores an N-bit word and performs one of four operations at each rising edge. A two-bit mode selects hold, either shift direction, or parallel load; separate serial inputs supply the new bit for each direction.

Companion to *FPGA Identikits* by Andrea Fato, group **7.2 — Parallel / Universal**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**One mode wins per edge.** The selector makes hold, right shift, left shift, and load mutually exclusive. Keep the code-to-operation mapping beside the interface: exchanging `"01"` and `"10"` reverses motion.

**Controls must meet timing.** `sel` and synchronous `rst` must meet setup and hold at `clk`. At the edge, the data input selected by the active mode (`d`, `si_l`, or `si_r`) must also meet timing. Synchronize or handshake off-domain controls and words.

**Startup is not reset.** Simulation starts at `'U'` and hardware power-up is device-dependent. Reset or a known load establishes the full word; one shift replaces only one stage per edge.

**Expect multiplexing before storage.** Every stage selects hold, either shift neighbor, or parallel data. Mapping and delay depend on width, reset, device, and tool; a dedicated shift primitive is not guaranteed.

## Files

- [`universal_shift_register.vhd`](universal_shift_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_universal_shift_register.vhd`](tb_universal_shift_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit universal-bidirectional-shift-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_universal_shift_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_universal_shift_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Load shift hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity universal_shift_register is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        sel      : in  std_logic_vector(1 downto 0);
        si_l     : in  std_logic;
        si_r     : in  std_logic;
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity universal_shift_register;
```

## Source traceability

- Book identikit: **7.2.2**.
- Book source: `components/universal-bidirectional-shift-register.tex`.
- RTL SHA-256 (UTF-8, LF): `879246eab087cbc3434f93facf17a916880bf95b99b74450117a2c9b539f0c54`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

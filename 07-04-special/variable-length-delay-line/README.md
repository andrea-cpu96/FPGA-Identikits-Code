# 7.4.1 — Variable-length delay line

Samples one input bit into an N-stage shift chain on every rising edge. After edge $m$ settles, tap $k$ contains sample $x[m-k]$; a binary selector routes one of those registered history stages to the output.

Companion to *FPGA Identikits* by Andrea Fato, group **7.4 — Rotation and Selectable Delay**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Transfer a multi-bit selector coherently.** A local `sel` must meet timing in its consuming domain. Across domains, use a handshake or equivalent coherent transfer: independent bit synchronizers can form unintended codes. Registering `dout` does not fix the crossing; it adds a stage.

**Constrain the sampled inputs.** `din` and synchronous `rst` must meet setup and hold requirements at `clk`. `sel` directly controls the mux, so its path must meet the timing of the register consuming `dout`.

**Define invalid selection.** Unused, unknown, or high-impedance selector codes produce zero; assertions distinguish the cases.

**Establish and qualify the history.** Without reset, the stored samples start unknown in simulation. Reset fills every tap with zero, and deeper taps keep that padding until enough new samples arrive. If those zeros must not be treated as acquired data, track externally how much valid history has accumulated.

**Reset can prevent shift-primitive mapping.** Dynamic tap selection can map to an addressable shift-register primitive on supported FPGAs. Requiring reset on every stage may prevent that mapping; target architecture, width, and synthesis support decide between primitives, flip-flops, or memory.

## Files

- [`variable_length_delay_line.vhd`](variable_length_delay_line.vhd): synthesizable reference template (VHDL-2008).
- [`tb_variable_length_delay_line.vhd`](tb_variable_length_delay_line.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit variable-length-delay-line
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_variable_length_delay_line`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_variable_length_delay_line`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,3`
- `5,3`
- `8,3`

Checks include:
- Tap history.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity variable_length_delay_line is
    generic (
        N         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 3
    );
    port (
        clk, rst, din : in  std_logic;
        sel  : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        dout : out std_logic
    );
end entity variable_length_delay_line;
```

## Source traceability

- Book identikit: **7.4.1**.
- Book source: `components/variable-length-delay-line.tex`.
- RTL SHA-256 (UTF-8, LF): `0e39492af6f272e624019beba64d2e38ccb25c83586929b97fc4bcfa18d79e6c`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

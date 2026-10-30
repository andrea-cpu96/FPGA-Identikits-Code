# 6.4.1 — Pipeline register (data + valid)

Moves data and its valid flag through N registered stages, one stage per rising edge. With continuous valid input it delivers one word per clock after filling. Use it to align paths; timing improvement requires registers placed around the datapath logic.

Companion to *FPGA Identikits* by Andrea Fato, group **6.4 — Pipeline**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Place registers around the logic.** Adding delay registers after a long combinational path does not shorten that path. To improve timing, divide the logic between stages or use supported retiming. This chain is useful for delaying data and its sidebands together, with up to N words in flight, but it cannot stall or apply backpressure.

**Constrain every stage.** Input-to-stage-0 and stage-to-stage paths must meet setup and hold at `clk`; extra stages do not replace clock/I/O constraints or static timing analysis.

**Delay data and valid together.** A valid flag must travel through the same stages as its data word so the receiver knows which output words to use. Reset clears the valid stages without clearing the data. Assert it before restarting the pipeline, otherwise an old word may still be marked valid.

## Files

- [`pipeline_register.vhd`](pipeline_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pipeline_register.vhd`](tb_pipeline_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit pipeline-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pipeline_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pipeline_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `8,1`
- `8,5`
- `8,8`

Checks include:
- Pipeline data.
- Pipeline valid.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity pipeline_register is
    generic (
        W : positive := 8;
        N : positive := 4
    );
    port (
        clk      : in  std_logic;
        din      : in  std_logic_vector(W-1 downto 0);
        din_vld  : in  std_logic;
        rst      : in  std_logic;
        dout     : out std_logic_vector(W-1 downto 0);
        dout_vld : out std_logic
    );
end entity pipeline_register;
```

## Source traceability

- Book identikit: **6.4.1**.
- Book source: `components/pipeline-register.tex`.
- RTL SHA-256 (UTF-8, LF): `beba759e630cb09b458eda0ef202012c5a8ebad388e88ed3f03a78640482f2e7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 12.1.2 — Pipelined multiplier

Captures two unsigned operands at every rising edge, then registers their full-width product at the following rising edge. Once filled, the pipeline delivers one result per clock without an enable or reset.

Companion to *FPGA Identikits* by Andrea Fato, group **12.1 — Products and accumulated products**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Signal assignments use old values.** The multiply reads the operand registers from before the edge, not the inputs being captured at that edge. There are two register banks around the multiplier; the internal latency from operand capture to result update is one clock period. Use that edge contract to align transactions without an off-by-one error.

**Qualify startup externally.** No initializer or reset is provided. The first result is unknown in simulation; a binary pair reaches the output after the second edge. Delay any valid flag or transaction tag by the same one clock period. There is no mechanism to stall this pipeline.

**Check resource mapping and timing.** Input and output registers can help DSP inference, but do not guarantee it. The complete multiply still lies between two register banks. Wide operands may require more pipeline stages or vendor IP to meet timing; inspect synthesis and timing reports.

**Keep samples coherent.** Both inputs must meet setup and hold at the same edge. These registers do not synchronize an asynchronous word pair. Arithmetic uses `numeric_std` handling of non-binary values, with no custom zero fallback; bad operands can propagate into a later result.

## Files

- [`pipelined_multiplier.vhd`](pipelined_multiplier.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pipelined_multiplier.vhd`](tb_pipelined_multiplier.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit pipelined-multiplier
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pipelined_multiplier`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pipelined_multiplier`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`

Checks include:
- Product pipeline.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity pipelined_multiplier is
    generic (N : positive := 8);
    port (
        clk : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        product : out
            std_logic_vector(2*N-1 downto 0)
    );
end entity pipelined_multiplier;
```

## Source traceability

- Book identikit: **12.1.2**.
- Book source: `components/pipelined-multiplier.tex`.
- RTL SHA-256 (UTF-8, LF): `34e26ebb63ad98e73beeeb2994f39de543395d3a7991ec30689ce1f80d7156b2`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

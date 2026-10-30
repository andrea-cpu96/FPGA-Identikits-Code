# 6.1.1 — D flip-flop

Captures one bit on each rising clock edge and holds it between edges. A synchronous, active-high reset clears the stored bit to zero.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reset semantics and priority.** Reset is sampled with the data. Asserting or releasing `rst` changes `q` only at a rising edge, so a pulse that occurs entirely between edges is ignored. If `rst` is high at the same edge that new data arrives, reset takes priority and the stored bit is cleared.

**Clock-domain assumptions.** Both `d` and synchronous `rst` must meet setup and hold at `clk`. Connecting an asynchronous signal to this block does not make it safe: a timing violation can leave the flip-flop metastable. Synchronize external data and distribute reset according to the requirements of the destination clock domain.

**Startup is not reset.** No initial value is declared. In simulation, `q` remains `'U'` until a rising edge captures data or an asserted reset. The power-up value in hardware is device-dependent unless it is defined explicitly and supported by the target technology.

**Check flip-flop and reset mapping.** This description should infer one flip-flop. Do not gate `clk` in ordinary logic to add an enable; use the dedicated clock-enable form of the register instead. A synchronous reset may be mapped through the data path on some devices, so check the synthesized result when reset fanout or timing is important.

## Files

- [`d_flip_flop.vhd`](d_flip_flop.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_flip_flop.vhd`](tb_d_flip_flop.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-flip-flop
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_flip_flop`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_flip_flop`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Capture.
- Hold.
- Reset and data must not act between edges.
- Reset priority.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_flip_flop is
    port (
        clk : in  std_logic;
        d   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity d_flip_flop;
```

## Source traceability

- Book identikit: **6.1.1**.
- Book source: `components/d-flip-flop.tex`.
- RTL SHA-256 (UTF-8, LF): `f3b96e2dd81babc25567c6a0a5d95c6ee5ff285fec9c87e7a1df1de2acfd73eb`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 6.1.2 — D register

Stores a multi-bit word without a reset control. With each rising clock edge, the stored word is updated from the data input; between edges it holds its previous value.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reset is a system choice.** This block has no reset port. The design must define when its output is valid, for example after a known input word is captured. Reset control state where needed; datapath registers need not all have a reset.

**Data must be stable.** `d` must meet setup and hold at the sampling edge. For a word crossing from another clock domain, use a coherent multi-bit CDC scheme, such as a handshake or asynchronous FIFO. Independent bit synchronizers do not guarantee word coherence.

## Files

- [`d_register.vhd`](d_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register.vhd`](tb_d_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Register capture.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_register is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register;
```

## Source traceability

- Book identikit: **6.1.2**.
- Book source: `components/d-register.tex`.
- RTL SHA-256 (UTF-8, LF): `41298619547b3a467aac42704e1099f98cda9d8389210a1cd7f71373fba63fc6`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 18.1.2 — Signed FIR filter

Multiplies the newest signed sample and its stored predecessors by fixed signed coefficients, then registers their sum. The coefficient vector sets the tap count at elaboration. The output retains the full product and accumulation precision; scaling remains explicit at the receiving interface.

Companion to *FPGA Identikits* by Andrea Fato, group **18.1 — Finite-window filters**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Define coefficient scaling.** Coefficients are stored integers within the signed CW-bit range. If they represent values divided by $2^Q$, the output carries Q additional fractional bits relative to the input. The default coefficients have DC gain four, not one.

**Preserve numerical range.** A accommodates T full-width signed products. Narrowing the output requires a separate choice of rounding and overflow behavior. Do not silently drop high bits or assume that every coefficient set is a low-pass filter.

**Budget the arithmetic path.** All products and additions occur between adjacent clock edges. Larger tap counts can need substantial logic or DSP resources and a longer clock period. A pipelined implementation changes latency and needs matching valid delays.

**Count accepted samples.** Enable gaps hold the history and output and clear valid. The block has no ready input. Provide synchronous binary controls and samples; reset wins over ce. Coefficients cannot be changed while running.

## Files

- [`signed_fir_filter.vhd`](signed_fir_filter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_signed_fir_filter.vhd`](tb_signed_fir_filter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit signed-fir-filter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_signed_fir_filter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_signed_fir_filter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,2,(0=>1)`
- `16,8,(0=>1,1=>2,2=>1)`
- `4,4,(0=>-8)`
- `4,4,(0=>0,1=>0,2=>0)`
- `4,4,(0=>1,1=>2,2=>1)`
- `8,4,(0=>-8,1=>7,2=>-3,3=>2,4=>1)`
- `8,8,(0=>1,1=>-2,2=>1,3=>0)`

Checks include:
- Accepted sample model, reset priority, numerical precision or output hold.
- Startup validity or disabled-cycle valid pulse.
- Synchronous outputs changed before clock edge.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity signed_fir_filter is
    generic (W : positive := 16;
             CW : positive range 1 to 16 := 8;
             C : integer_vector := (1, 2, 1));
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W+CW+ceil_log2(C'length)-1 downto 0);
          valid : out std_logic);
end entity signed_fir_filter;
```

## Source traceability

- Book identikit: **18.1.2**.
- Book source: `components/signed-fir-filter.tex`.
- RTL SHA-256 (UTF-8, LF): `5f2e003916c4237b0ea9662e37c6fa3ccadf59a486e4fac3ed4e7cadf88e704a`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

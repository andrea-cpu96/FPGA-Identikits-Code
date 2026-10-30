# 7.2.1 — PIPO register

Captures an entire N-bit word on a rising edge when load is high and holds it otherwise. Every bit enters and leaves in parallel, making this the loadable storage structure used inside serializers and universal registers.

Companion to *FPGA Identikits* by Andrea Fato, group **7.2 — Parallel / Universal**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Load is an edge-sampled enable.** `load` controls whether the register captures `d`; it is not a second clock. `d`, `load`, and synchronous `rst` must meet setup and hold requirements at `clk`. Do not build an ordinary logic gate into the clock path to reproduce this behavior.

**Startup is not reset.** No initial value is declared. Simulation begins with `'U'` bits and hardware power-up is device-dependent until a known reset or enabled load establishes the word.

**Parallel capture is not word synchronization.** Capturing all bits at one local edge does not guarantee a coherent word if the source is asynchronous: bits can be sampled from different updates or become metastable. Transfer such words through a suitable handshake, FIFO or other clock-domain-crossing protocol before using them.

**Expect a register bank.** This form normally infers N flip-flops with a shared load condition, mapped through clock enables or input multiplexers as the target permits. Reset priority and device resources affect the result, so inspect synthesis when timing, fanout, or area matters.

## Files

- [`pipo_register.vhd`](pipo_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pipo_register.vhd`](tb_pipo_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit pipo-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pipo_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pipo_register`; a failure assertion or timeout is a failure.
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
entity pipo_register is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        d    : in  std_logic_vector(N-1 downto 0);
        load : in  std_logic;
        q    : out std_logic_vector(N-1 downto 0)
    );
end entity pipo_register;
```

## Source traceability

- Book identikit: **7.2.1**.
- Book source: `components/pipo-register.tex`.
- RTL SHA-256 (UTF-8, LF): `96954a177b31852e44d36d090fcf7fbf438b7f51e066fc0daeb032797cde4bae`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

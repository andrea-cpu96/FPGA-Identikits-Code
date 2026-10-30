# 17.1.1 — Synchronous FIFO

Stores accepted words and returns them in first-in, first-out order. One rising edge can accept a write and a read, provided the pre-edge full and empty flags allow them. A synchronous reset discards the queued words.

Companion to *FPGA Identikits* by Andrea Fato, group **17.1 — Keeping a stream in order**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Count transfers, not requests.** Full rejects writes, so retain the offered word; empty rejects reads, and reset blocks both. Qualify registered `dout` with the previous edge's accepted read. The current empty flag describes queued words, not output validity.

**Reset invalidates data logically.** Reset returns pointers and count to zero, making old storage unreachable as queued data. It does not erase memory or clear dout. Sample reset before use if the target does not guarantee the declared control-state initialization.

**Use one clock domain for all transfers.** All requests and input data must meet the same clock's timing. This FIFO is not a synchronizer. Use binary controls; only literal `'1'` requests a transfer, with no custom invalid-value diagnostic.

**Check resource mapping.** Power-of-two pointers wrap naturally; the extra count bit distinguishes full from empty. Choose a depth that fits the integer range and device. The template does not reset storage, but actual RAM inference and timing still depend on the target and synthesis tool.

## Files

- [`synchronous_fifo.vhd`](synchronous_fifo.vhd): synthesizable reference template (VHDL-2008).
- [`tb_synchronous_fifo.vhd`](tb_synchronous_fifo.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit synchronous-fifo
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_synchronous_fifo`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_synchronous_fifo`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `16,1`
- `16,3`

Checks include:
- FIFO drain.
- FIFO flags.
- FIFO updated flags.
- Sync FIFO ordering.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity synchronous_fifo is
    generic (WIDTH : positive := 8;
             ADDR_W : positive := 4);
    port (
        clk, rst, wr, rd : in std_logic;
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0);
        full, empty : out std_logic
    );
end entity synchronous_fifo;
```

## Source traceability

- Book identikit: **17.1.1**.
- Book source: `components/synchronous-fifo.tex`.
- RTL SHA-256 (UTF-8, LF): `108744a8a556b21bb88950189a25656071c1b96577b2fc4fc4322ad0a19b6110`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

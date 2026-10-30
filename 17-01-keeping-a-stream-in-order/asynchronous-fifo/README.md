# 17.1.2 — Asynchronous FIFO

Accepts writes on wr_clk and reads on rd_clk. Binary pointers address the shared storage; registered Gray-coded pointers cross through two-stage synchronizers so each domain can decide when its own transfer is allowed.

Companion to *FPGA Identikits* by Andrea Fato, group **17.1 — Keeping a stream in order**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Require initialized startup.** The target must implement all declared control-register initial values, with traffic starting after configuration. There is no run-time flush. A reset variant must coordinate both domains; resetting one side alone loses queue state.

**Constrain the Gray crossings.** Mark and place synchronizers with the target flow; prevent retiming and shift-register extraction. Constrain source-Gray to first-stage delay/skew, typically within one source-clock period and following the target vendor's CDC guidance, so successive transitions cannot overlap.

**Keep flags local.** Use full in the write domain and empty in the read domain. Because these flags are combinational decodes, they can glitch; consume them only in local synchronous decisions, never as clocks or asynchronous controls. The two synchronization stages reduce metastability risk but do not eliminate it.

**Check RAM and CDC mapping.** The write process alone drives storage. Check dual-clock RAM inference, initialization, timing, and CDC (see the book's CDC appendix) reports; simulation cannot prove physical safety. Use binary local requests and a depth supported by the tool and device.

## Files

- [`asynchronous_fifo.vhd`](asynchronous_fifo.vhd): synthesizable reference template (VHDL-2008).
- [`tb_asynchronous_fifo.vhd`](tb_asynchronous_fifo.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit asynchronous-fifo
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_asynchronous_fifo`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_asynchronous_fifo`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `16,1`
- `16,3`

Checks include:
- Async drain.
- Async ordering.
- Async underflow.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity asynchronous_fifo is
    generic (WIDTH : positive := 8; ADDR_W : positive := 4);
    port (
        wr_clk, rd_clk, wr, rd : in std_logic;
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0);
        full, empty : out std_logic
    );
end entity asynchronous_fifo;
```

## Source traceability

- Book identikit: **17.1.2**.
- Book source: `components/asynchronous-fifo.tex`.
- RTL SHA-256 (UTF-8, LF): `1bc3b0450a26c5738cd86673788f0c2dd68ecd5da18c8d58c5b9774d46e5a077`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

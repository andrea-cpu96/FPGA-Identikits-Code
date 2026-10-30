# 15.1.2 — Simple dual-port RAM

Writes a word on the write clock and reads a separately addressed word on the read clock. The two ports may use a common clock or separate clocks. Only the write port changes memory; the read output updates at each read edge.

Companion to *FPGA Identikits* by Andrea Fato, group **15.1 — Registered-read memory ports**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Separate clocks do not make a CDC buffer.** Use ownership, a handshake, or FIFO control to prevent the reader from accessing a location being written. Synchronize the control protocol; sampling each data bit independently does not make a multi-bit word coherent.

**Do not trust simulated collision data.** Coincident read and write edges in the same simulation update can return old data because signal writes are deferred. Hardware mixed-port behavior depends on the primitive and mode. This template makes no usable result guarantee for a collision.

**Initialize through a defined protocol.** Neither the memory nor `dout` starts with defined contents, so write valid words before granting read access. If the reader uses another clock, notify it through a synchronized control protocol; completing the write alone does not tell the reader that the word is ready.

**Check inference and address limits.** Separate-clock RAM support is target-dependent. Verify the mapped RAM and timing requirements. Addresses must be binary and depth must fit the VHDL integer range and device capacity. Only literal `'1'` enables a write; invalid controls are not diagnosed.

## Files

- [`simple_dual_port_ram.vhd`](simple_dual_port_ram.vhd): synthesizable reference template (VHDL-2008).
- [`tb_simple_dual_port_ram.vhd`](tb_simple_dual_port_ram.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit simple-dual-port-ram
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_simple_dual_port_ram`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_simple_dual_port_ram`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `8,3`

Checks include:
- RAM read/write behavior.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity simple_dual_port_ram is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 8
    );
    port (
        wr_clk, rd_clk, we : in std_logic;
        waddr, raddr : in
            std_logic_vector(ADDR_W-1 downto 0);
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity simple_dual_port_ram;
```

## Source traceability

- Book identikit: **15.1.2**.
- Book source: `components/simple-dual-port-ram.tex`.
- RTL SHA-256 (UTF-8, LF): `03b7bdda0228bb2ebe40e89ad7267ef1b44894fbd4341edc66c22843c47b82f7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

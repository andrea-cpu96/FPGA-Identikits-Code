# 15.1.3 — True dual-port RAM

Provides two separately addressed ports, each able to read and write. Both use the same rising edge in this reference implementation. Each output returns its addressed word's old contents; writes take effect after the edge.

Companion to *FPGA Identikits* by Andrea Fato, group **15.1 — Registered-read memory ports**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep one driver for storage.** Two clocked processes assigning one RAM signal create multiple drivers in VHDL simulation. This common-clock form places both writes in one process. True dual-port describes port capability; it does not require independent clocks.

**Exclude cross-port collisions.** Both ports always read, so even one writer conflicts with the other port reading the same address. The assertion detects this in simulation; it does not arbitrate or protect hardware. Prevent such requests in surrounding control.

**Check the target's RAM template.** Inference and same-port read-first support are tool- and device-dependent. For independent clocks, use a vendor-approved dual-clock template or IP with defined collision restrictions; do not split this RAM signal into two writing processes.

**Initialize and constrain both ports.** Write each word before reading valid data. Supply binary addresses and controls that meet clock timing. Depth must fit the VHDL integer range and the device. There is no custom invalid-input fallback, and unknown startup contents are not zeros.

## Files

- [`true_dual_port_ram.vhd`](true_dual_port_ram.vhd): synthesizable reference template (VHDL-2008).
- [`tb_true_dual_port_ram.vhd`](tb_true_dual_port_ram.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit true-dual-port-ram
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_true_dual_port_ram`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_true_dual_port_ram`; a failure assertion or timeout is a failure.
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
entity true_dual_port_ram is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 8
    );
    port (
        clk, we_a, we_b : in std_logic;
        addr_a, addr_b : in
            std_logic_vector(ADDR_W-1 downto 0);
        din_a, din_b : in
            std_logic_vector(WIDTH-1 downto 0);
        dout_a, dout_b : out
            std_logic_vector(WIDTH-1 downto 0)
    );
end entity true_dual_port_ram;
```

## Source traceability

- Book identikit: **15.1.3**.
- Book source: `components/true-dual-port-ram.tex`.
- RTL SHA-256 (UTF-8, LF): `f788ec9aac2e612d64e6fdf7931abde36a940a31ab24d0406c202dd63d0ae564`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

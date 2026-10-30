# 15.1.1 — Single-port RAM

Stores words behind one shared read/write address. Every rising edge reads the selected word into an output register. If write enable is high, that same edge also replaces the word; the output receives its previous contents.

Companion to *FPGA Identikits* by Andrea Fato, group **15.1 — Registered-read memory ports**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Unwritten words are not zero.** No reset or initialization is supplied. Simulation starts with unknown memory and output values. Write each location before relying on its contents; the output of that first write still exposes the unknown old word. Hardware power-up depends on the target and configuration.

**Preserve the memory inference pattern.** A registered read can map to block RAM, but capacity, port mode, and tool support determine the result. Resetting every array element can prevent RAM inference. Initialize through writes or use a supported initialization facility when required.

**Use binary addresses within capacity limits.** All binary address codes are legal for this power-of-two depth. Choose `ADDR_W` so the depth fits the VHDL integer range and the target resources. Non-binary addresses are invalid; numeric conversion warnings or coercions are not a protection mechanism.

**Verify read-during-write mode.** A write returns the old contents of the addressed word: this is read-first behavior. Confirm that synthesis preserves it rather than selecting write-first or no-change mode. The port also reads on every rising edge, independently of `we`, so the address must meet timing even when no write is requested.

## Files

- [`single_port_ram.vhd`](single_port_ram.vhd): synthesizable reference template (VHDL-2008).
- [`tb_single_port_ram.vhd`](tb_single_port_ram.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit single-port-ram
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_single_port_ram`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_single_port_ram`; a failure assertion or timeout is a failure.
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
entity single_port_ram is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 8
    );
    port (
        clk, we : in std_logic;
        addr : in std_logic_vector(ADDR_W-1 downto 0);
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity single_port_ram;
```

## Source traceability

- Book identikit: **15.1.1**.
- Book source: `components/single-port-ram.tex`.
- RTL SHA-256 (UTF-8, LF): `9c16994c452327a1e6fc7845fbe9ddfe00c742074ddead195ba49d5bccaae200`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 15.2.1 — Register file: one write, two read ports

Stores $2^{ADDR_W}$ words. One port writes a word at a rising clock edge; two independent read ports show their addressed words continuously, without a clock. A same-address read during a write returns the old word until the edge.

Companion to *FPGA Identikits* by Andrea Fato, group **15.2 — Register files**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Know which memory you get.** Combinational reads rule out block RAM. Small banks map to distributed RAM or to flip-flops and multiplexers; a second read port usually duplicates distributed RAM. Check the synthesis report as width or depth grows.

**Check read timing during a write.** At a same-address write edge, a receiving register still captures the old word. The read port changes to the new word only after the write and read-path delays. If the receiver needs the incoming write data on that very edge, add a write-through bypass.

**Budget the read path.** Address-to-data delay adds to the consumer's combinational path, and outputs may glitch while an address settles. Sample them on the clock, or register addresses or outputs when timing is tight.

**Initialize through the write port.** Nothing is reset, so contents start undefined. Write each register before use; a reset variant usually prevents distributed-RAM inference. Only literal `'1'` enables a write.

## Files

- [`register_file_1w2r.vhd`](register_file_1w2r.vhd): synthesizable reference template (VHDL-2008).
- [`tb_register_file_1w2r.vhd`](tb_register_file_1w2r.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit register-file-1w2r
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_register_file_1w2r`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_register_file_1w2r`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `8,3`

Checks include:
- Register file/ROM.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity register_file_1w2r is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 4
    );
    port (
        clk, we : in std_logic;
        waddr, raddr_a, raddr_b : in
            std_logic_vector(ADDR_W-1 downto 0);
        wdata : in std_logic_vector(WIDTH-1 downto 0);
        rdata_a, rdata_b : out
            std_logic_vector(WIDTH-1 downto 0)
    );
end entity register_file_1w2r;
```

## Source traceability

- Book identikit: **15.2.1**.
- Book source: `components/register-file-1w2r.tex`.
- RTL SHA-256 (UTF-8, LF): `73b7ad27376b6091035fbf20d06cab5096d367ce00412c768bd166fed952c1a4`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

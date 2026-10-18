# 20.2.1 — CDC request/acknowledge mailbox

Accepts a word in the source domain, holds it stable, and signals a toggle request. The destination loads the held word, presents it with dst_valid, and returns an acknowledgement once it is consumed. Only one word is in flight at a time.

Companion to *FPGA Identikits* by Andrea Fato, group **19.2 — Coherent word transfers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Constrain the held-data path.** Time `data_reg` to `dst_data`: R1--R3 gives two destination periods before setup, uncertainty, and margin. A one-period bound is an example to verify. Section C.6 covers constraints and exception precedence.

**Reset both domains together.** Each reset discards a word in flight. Resetting one side alone can lose or invent a transfer. With both clocks running, keep resets overlapping until each domain has sampled its reset.

**Treat each side as ready/valid.** A transfer occurs at an edge where valid and ready are both high. `src_ready` may read high during `rst_src`, when nothing is accepted; hold the producer in reset too.

**Mark the resolving stages.** Only `req_sync` and `ack_sync` resolve metastability; give them synchronizer attributes and timed stage-to-stage paths. Use an asynchronous FIFO for streams.

## Files

- [`cdc_mailbox.vhd`](cdc_mailbox.vhd): synthesizable reference template (VHDL-2008).
- [`tb_cdc_mailbox.vhd`](tb_cdc_mailbox.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit cdc-mailbox
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_cdc_mailbox`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_cdc_mailbox`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `16`

Checks include:
- Mailbox drain.
- Mailbox ordering.
- Mailbox stall hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity cdc_mailbox is
    generic (WIDTH : positive := 8);
    port (
        clk_src, rst_src, src_valid : in  std_logic;
        src_data  : in  std_logic_vector(WIDTH-1 downto 0);
        src_ready : out std_logic;
        clk_dst, rst_dst, dst_ready : in  std_logic;
        dst_valid : out std_logic;
        dst_data  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity cdc_mailbox;
```

## Source traceability

- Book identikit: **20.2.1**.
- Book source: `components/cdc-mailbox.tex`.
- RTL SHA-256 (UTF-8, LF): `bb35728bb78806d76bbe9289abdf23b3e86422dfe35eb3570a8383ac8da910c7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

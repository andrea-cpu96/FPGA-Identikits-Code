# 2.1.4 — Priority encoder

Examines eight request bits and returns the index of the highest asserted bit. Bit seven has the highest priority. A separate valid output distinguishes no request from a legitimate request on bit zero.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Priority comes from scan direction.** Iterating from `d(7)` toward `d(0)` and exiting on the first assertion defines the policy. Changing the scan direction or omitting `exit` can silently reverse the priority or make the last match win.

**Always use the valid flag.** Index zero represents both `d(0)` and the chosen fallback; only `valid` distinguishes them.

**Wide priority chains cost delay.** A linear priority encoder may form a long combinational path. For large request sets, consider a tree, a hierarchical encoder, or a registered arbitration stage after checking the target technology and timing report.

**Fixed priority can starve lower requests.** This block identifies the highest-priority request but does not track whether it has been served. A persistent high-priority request can therefore starve lower requests. If service must be shared fairly, use a stateful arbiter with a handshake and rotating priority.

**Validity is combinational.** The `valid` flag indicates whether the settled request pattern contains a request; it does not establish safe timing. Synchronize or handshake requests that cross clock domains, and capture `y` and `valid` together so the index stays paired with its validity.

## Files

- [`priority_encoder_8_to_3.vhd`](priority_encoder_8_to_3.vhd): synthesizable reference template (VHDL-2008).
- [`tb_priority_encoder_8_to_3.vhd`](tb_priority_encoder_8_to_3.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit priority-encoder
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_priority_encoder_8_to_3`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_priority_encoder_8_to_3`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Priority encoder.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity priority_encoder_8_to_3 is
    port (
        d     : in  std_logic_vector(7 downto 0);
        y     : out std_logic_vector(2 downto 0);
        valid : out std_logic
    );
end entity priority_encoder_8_to_3;
```

## Source traceability

- Book identikit: **2.1.4**.
- Book source: `components/priority-encoder.tex`.
- RTL SHA-256 (UTF-8, LF): `0568030ddfc25f70f93189812fbf0984aea4c2127525f785a395553b813e4dda`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

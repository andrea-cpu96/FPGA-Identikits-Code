# 2.1.2 — 3:8 decoder with enable

Adds an active-high enable to the basic decoder. While disabled, every output is low. While enabled, a literal three-bit binary code asserts exactly one of the eight outputs.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Express the control precedence.** Clearing `y` first makes the disabled state the default. The indexed assignment occurs only after both the enable and select have passed their literal-binary checks, so no branch can leave an old output value behind.

**Do not confuse enable with synchronization.** An asynchronous `en` or `sel` still requires a suitable CDC (see the book's CDC appendix) protocol before it controls synchronous destinations.

**Enabled decoding can create hazards.** Select skew can momentarily activate the wrong output, and enable transitions can truncate or create pulses. Hold both controls stable over the destination capture interval, or register the decode in the receiving clock domain.

**Assertions describe simulation behavior.** The assertion detects and reports invalid values; the all-low fallback only defines their simulated output. Neither guarantees the electrical result of a metastable input.

## Files

- [`decoder_3_to_8_enable.vhd`](decoder_3_to_8_enable.vhd): synthesizable reference template (VHDL-2008).
- [`tb_decoder_3_to_8_enable.vhd`](tb_decoder_3_to_8_enable.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit decoder-3-to-8-enable
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_decoder_3_to_8_enable`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_decoder_3_to_8_enable`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Expected output for the applied input combinations (see testbench assertions).

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity decoder_3_to_8_enable is
    port (
        sel : in  std_logic_vector(2 downto 0);
        en  : in  std_logic;
        y   : out std_logic_vector(7 downto 0)
    );
end entity decoder_3_to_8_enable;
```

## Source traceability

- Book identikit: **2.1.2**.
- Book source: `components/decoder-3-to-8-enable.tex`.
- RTL SHA-256 (UTF-8, LF): `dc98a7b115caa1b7dd82978fecb453ea4cbcde0677b4cf84acbaf1b657f1ff6d`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

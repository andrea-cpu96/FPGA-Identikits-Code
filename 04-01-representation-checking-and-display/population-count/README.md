# 4.1.5 — Population count

Counts the asserted bits of a W-bit word. The result is an unsigned number from zero to W, not a parity bit or the position of the first asserted bit. Every output bit is combinational and follows the settled input word.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Allow the full count.** A `W`-bit input has a population count from 0 through `W`, requiring $\lceil\log_2(`W`+1)\rceil$ output bits, as provided by `count_width(W)`. For `W=8`, three bits can index the input positions but four are needed to represent count 8. Keep the count unsigned for comparisons and arithmetic.

**Invalid simulation values.** An `X`, `Z`, or other non-binary bit is not a zero. The template warns and drives a defined zero for the entire word so an unknown cannot silently reduce the apparent count.

**Budget the reduction path.** The reference adds the input bits one at a time. As W grows, the resources and combinational delay can grow too, so check the mapped result. A balanced adder tree or pipelined reduction may suit a wide word or tight clock period better.

**Do not treat a transient count as a pulse.** Several input bits can change at different times and produce intermediate counts. Register the settled result before it controls sequential decisions requiring a stable value.

## Files

- [`population_count.vhd`](population_count.vhd): synthesizable reference template (VHDL-2008).
- [`tb_population_count.vhd`](tb_population_count.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit population-count
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_population_count`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_population_count`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Pop parity.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity population_count is
    generic (W : positive := 8);
    port (
        data_in   : in  std_logic_vector(W-1 downto 0);
        count_out : out unsigned(count_width(W)-1 downto 0)
    );
end entity population_count;
```

## Source traceability

- Book identikit: **4.1.5**.
- Book source: `components/population-count.tex`.
- RTL SHA-256 (UTF-8, LF): `88b9b3cb467a58eaa5f272712d09245d2ef04d38c8eccbfc56411b71106304f9`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

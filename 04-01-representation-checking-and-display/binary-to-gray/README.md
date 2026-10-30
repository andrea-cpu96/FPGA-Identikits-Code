# 4.1.2 — Binary to Gray

Maps a binary word to reflected Gray code by XORing it with a one-bit right-shifted copy. Adjacent binary values have Gray representations that differ in one bit, provided the settled values are observed in sequence.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Register before a clock crossing.** Several bits of a binary counter can change around one edge. A purely combinational converter can therefore glitch before its Gray output settles. Register the Gray value in the source domain before synchronizing its bits into another domain.

**Gray code is not synchronization.** Its adjacency limits ambiguity between successive count values, but every crossing bit still needs an appropriate synchronizer and the implementation needs a bus-skew constraint consistent with the source update interval.

**Preserve the source sequence.** The one-bit-change property applies when the source visits adjacent values. A slower receiver may repeat an observation or skip source values, so successive synchronized samples need not differ by exactly one bit. Judge them against the protocol's allowed progress.

**Define invalid simulation behavior.** The template reports non-binary input and produces zero, giving simulation a defined result. This does not describe how metastable hardware will behave. If downstream logic must distinguish a valid encoded zero from invalid input, add a validity indication.

## Files

- [`binary_to_gray.vhd`](binary_to_gray.vhd): synthesizable reference template (VHDL-2008).
- [`tb_binary_to_gray.vhd`](tb_binary_to_gray.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit binary-to-gray
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_binary_to_gray`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_binary_to_gray`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Gray.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity binary_to_gray is
    generic (W : positive := 4);
    port (
        binary_in : in  std_logic_vector(W-1 downto 0);
        gray_out  : out std_logic_vector(W-1 downto 0)
    );
end entity binary_to_gray;
```

## Source traceability

- Book identikit: **4.1.2**.
- Book source: `components/binary-to-gray.tex`.
- RTL SHA-256 (UTF-8, LF): `fe1f9e1bf975886e41e2e78a201082a440400afa17f81e392ef2e2426f365bb7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

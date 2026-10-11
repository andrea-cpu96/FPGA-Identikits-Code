# 2.1.4 — One-hot to binary

Converts an eight-bit one-hot vector into the three-bit index of its asserted bit. A valid output confirms that the input contains exactly one literal '1' and no unknown or weak values.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Do not silently accept multi-hot data.** A simple loop that repeatedly assigns the index makes the last asserted bit win, accidentally turning the block into a priority encoder. Validate the exact-one property when the interface promises one-hot data.

**Keep producer and consumer ordering aligned.** Bit zero maps to binary zero and bit seven maps to binary seven. Reversing either vector changes that meaning without causing a type error.

**Validity logic has a cost.** Detecting zero-hot and multi-hot inputs adds logic beyond the encoder. If a local invariant already guarantees one-hot operation, an assertion-only check may be sufficient; retain a valid signal when downstream logic must recover from violations in hardware.

**One-hot does not imply CDC safety.** Several bits can be observed during an asynchronous transition. Transfer the code with an appropriate handshake or synchronization scheme before encoding it. The combinational `valid` output describes only the settled binary pattern; it does not certify timing or a glitch-free transition. Capture `bin` and `valid` together.

## Files

- [`one_hot_to_binary_8_to_3.vhd`](one_hot_to_binary_8_to_3.vhd): synthesizable reference template (VHDL-2008).
- [`tb_one_hot_to_binary_8_to_3.vhd`](tb_one_hot_to_binary_8_to_3.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit one-hot-to-binary
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_one_hot_to_binary_8_to_3`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_one_hot_to_binary_8_to_3`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Onehot valid.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity one_hot_to_binary_8_to_3 is
    port (
        onehot : in  std_logic_vector(7 downto 0);
        bin    : out std_logic_vector(2 downto 0);
        valid  : out std_logic
    );
end entity one_hot_to_binary_8_to_3;
```

## Source traceability

- Book identikit: **2.1.4**.
- Book source: `components/one-hot-to-binary.tex`.
- RTL SHA-256 (UTF-8, LF): `71d300cb82301e0b3dbc2161c3efcf83898e2387949a2feffddf3cbcb183ecd6`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

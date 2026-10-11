# 4.1.3 — Gray to binary

Reconstructs a binary word from reflected Gray code. The most significant bit passes through, while each lower binary bit is the prefix XOR of the Gray bits from the most significant position down to that position.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Decode after synchronization.** In a CDC (see the book's CDC appendix) counter scheme, synchronize the registered Gray bits before conversion. Decoding the asynchronous source directly recreates a multi-bit combinational bus at the crossing and defeats the purpose of limiting ambiguity.

**A word cannot prove a valid transition.** A destination may repeat an observation or skip source values, so successive synchronized samples can legitimately differ by more than one Gray bit. A temporal monitor needs a previous value plus protocol and rate bounds; an unconditional one-bit-change assertion at the receiver is wrong.

**Budget the prefix path.** Lower output bits depend on progressively more Gray bits. Synthesis can balance or restructure the XOR network, but a wide decoder can still become a timing path. Register or pipeline the binary result when the receiving latency contract permits it.

**Do not use transient output as an event.** Even a one-bit Gray input transition can propagate through several decoded binary bits at different times. Use the settled or registered binary word for arithmetic and control; do not derive clocks or asynchronous pulses from raw decoded bits.

## Files

- [`gray_to_binary.vhd`](gray_to_binary.vhd): synthesizable reference template (VHDL-2008).
- [`tb_gray_to_binary.vhd`](tb_gray_to_binary.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit gray-to-binary
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_gray_to_binary`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_gray_to_binary`; a failure assertion or timeout is a failure.
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
entity gray_to_binary is
    generic (W : positive := 4);
    port (
        gray_in    : in  std_logic_vector(W-1 downto 0);
        binary_out : out std_logic_vector(W-1 downto 0)
    );
end entity gray_to_binary;
```

## Source traceability

- Book identikit: **4.1.3**.
- Book source: `components/gray-to-binary.tex`.
- RTL SHA-256 (UTF-8, LF): `23cda1f390ba225e9fc49cef9cc36f02bf1cf533084d665c5bffa7c7fb37f49e`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

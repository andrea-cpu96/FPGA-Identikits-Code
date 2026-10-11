# 7.4.2 — Rotate-right register

Loads an N-bit word, then moves every stored bit one position toward bit 0 on each enabled rising edge. The outgoing least-significant bit wraps into bit N-1, so no information is discarded or replaced.

Companion to *FPGA Identikits* by Andrea Fato, group **7.4 — Special**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Rotation is not a logical shift.** No zero or sign bit enters the word. Every rotation is a permutation, so the number of ones and zeros is preserved and N enabled rotations restore the original arrangement.

**Rotation cannot establish known data.** With no declaration-time initial value, simulation begins unknown and rotation preserves it. A sampled reset or known parallel load must establish the word; resetting to zero and rotating forever leaves the permanent zero state.

**Constrain the sampled inputs.** `rst`, `load`, and `en` must meet setup and hold at `clk`; when `load='1'`, `d` must also meet timing at that edge.

**Priority is part of the protocol.** Reset wins first, then load, then enable. If `load` and `en` are both high at an edge, the new word is loaded and is not rotated until a later enabled edge.

**Expect recirculation multiplexing.** Load, hold, and wraparound require selection logic before the storage stages. The result commonly maps to flip-flops rather than a simple serial shift primitive; inspect timing and resource reports for wide or high-speed instances.

## Files

- [`rotate_right_register.vhd`](rotate_right_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_rotate_right_register.vhd`](tb_rotate_right_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit rotate-right-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_rotate_right_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_rotate_right_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Load shift hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity rotate_right_register is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        d    : in  std_logic_vector(N-1 downto 0);
        load : in  std_logic;
        en   : in  std_logic;
        q    : out std_logic_vector(N-1 downto 0)
    );
end entity rotate_right_register;
```

## Source traceability

- Book identikit: **7.4.2**.
- Book source: `components/rotate-right-register.tex`.
- RTL SHA-256 (UTF-8, LF): `a8ee8f35f97859b5bfea691f984dbe8f520b240603cfea0331d75b00b908d3b0`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 8.2.1 — Up/down counter

Increments when dir is high and decrements when it is low. Both directions use N-bit unsigned arithmetic and wrap at the numeric boundaries.

Companion to *FPGA Identikits* by Andrea Fato, group **8.2 — Up / Down**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Synchronize the direction request.** If `dir` comes from another clock domain, a transition near the edge can select the wrong operation or violate setup/hold time. Synchronize a stable control before use.

**Constrain sampled controls.** `dir` and synchronous `rst` must meet setup and hold requirements at `clk`.

**Wrap occurs in both directions.** Maximum plus one becomes zero, and zero minus one becomes maximum. Use saturation when boundary hold is the required behavior.

**Direction changes the next edge only.** It does not undo the current count or preload another value. Protocols that reverse at an endpoint must define whether the endpoint is repeated.

**Unknown control is not a direction.** When reset is inactive and direction is evaluated, the template warns and holds if `dir` is neither binary value.

## Files

- [`up_down_counter.vhd`](up_down_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_up_down_counter.vhd`](tb_up_down_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit up-down-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_up_down_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_up_down_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Counter.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity up_down_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        dir : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity up_down_counter;
```

## Source traceability

- Book identikit: **8.2.1**.
- Book source: `components/up-down-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `89ba94a1c254c695e3c9e579466cb76772588f07fe24478a4fafb7b2acaca860`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

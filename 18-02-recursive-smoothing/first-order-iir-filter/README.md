# 18.2.1 — First-order IIR low-pass filter

Moves a stored estimate toward each accepted signed sample by a fraction $2^{-K}$ of their difference. Earlier samples fade gradually rather than leaving a fixed window. Fractional state bits preserve small updates that would disappear in integer-only arithmetic.

Companion to *FPGA Identikits* by Andrea Fato, group **18.2 — Recursive smoothing**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Distinguish word and fractional widths.** W sets the input and output range; F preserves fractional state. Both right shifts round downward. A small positive difference can stop changing the state before it reaches the target, leaving an internal-state error below $2^{K-F}$ input units. The integer output is rounded down again and can remain one unit below a constant input.

**Set the response in sample time.** Larger K means slower smoothing. An irregular sample enable changes the response measured in seconds. Keep the accepted sample rate regular when a predictable frequency response matters.

**Extend before subtracting.** The difference uses W+F+1 bits, so opposite full-scale values cannot overflow it. The update stays between the old state and the target, allowing W+F stored bits without saturation when reset and inputs obey the contract.

**Check startup and pauses.** Zero is the initial estimate, not a measured value. Every accepted sample is valid immediately; there is no settling flag. Disabled edges hold the estimate and output but clear valid. Use synchronous binary controls and data.

## Files

- [`first_order_iir_filter.vhd`](first_order_iir_filter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_first_order_iir_filter.vhd`](tb_first_order_iir_filter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit first-order-iir-filter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_first_order_iir_filter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_first_order_iir_filter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1,1`
- `16,3,8`
- `4,1,4`
- `4,16,16`
- `4,3,24`
- `8,3,8`
- `8,8,8`

Checks include:
- Accepted sample model, reset priority, numerical precision or output hold.
- Startup validity or disabled-cycle valid pulse.
- Synchronous outputs changed before clock edge.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity first_order_iir_filter is
    generic (W : positive := 16;
             K : positive range 1 to 16 := 3;
             F : positive range 1 to 24 := 8);
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W-1 downto 0);
          valid : out std_logic);
end entity first_order_iir_filter;
```

## Source traceability

- Book identikit: **18.2.1**.
- Book source: `components/first-order-iir-filter.tex`.
- RTL SHA-256 (UTF-8, LF): `802af7209dc083629f83c84682e58d372ff963de009035f80f049a40ec6d8950`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

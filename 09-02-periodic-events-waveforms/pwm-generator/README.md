# 9.2.3 — PWM generator

Divides time into periods of PERIOD clock cycles. A registered output is high for the first $\min(duty,PERIOD)$ cycles of each period and low for the rest. A new duty value takes effect only at the start of the next period.

Companion to *FPGA Identikits* by Andrea Fato, group **9.2 — Periodic Events & Waveforms**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Commit duty at the boundary.** Sampling duty only at a period boundary prevents mid-period changes from truncating or adding pulses. The new value can therefore wait up to `PERIOD` cycles before taking effect.

**Support zero and full duty.** Zero gives a constant low with no runt pulse; any code $\geq$ `PERIOD` gives a constant high. `PERIOD` $<2^N$ lets the N-bit duty input represent full duty, and the concurrent assertion rejects $`PERIOD`\geq 2^N$.

**Constrain the sampled inputs.** Synchronous `rst` must meet setup and hold at `clk`. Because `duty` is sampled only at the period boundary, it must meet setup and hold at that boundary edge.

**Trade resolution for frequency.** The output repeats at $f_{clk}/`PERIOD`$ with a duty step of $1/`PERIOD`$. At 100\,MHz, `PERIOD=255` gives about 392\,kHz with 8-bit resolution.

**Drive duty from the same clock domain.** Transfer an off-domain duty word coherently, for example with a handshake; synchronizing its bits independently can commit a mixed value.

**Add power-stage protection externally.** The output is glitch-free, but dead time and fault shutdown are separate requirements.

## Files

- [`pwm_generator.vhd`](pwm_generator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pwm_generator.vhd`](tb_pwm_generator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit pwm-generator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pwm_generator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pwm_generator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `3,3`
- `3,7`

Checks include:
- PWM duty/boundary.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity pwm_generator is
    generic (
        N      : positive range 1 to 30 := 8;
        PERIOD : positive := 255
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        duty : in  std_logic_vector(N-1 downto 0);
        pwm  : out std_logic
    );
end entity pwm_generator;
```

## Source traceability

- Book identikit: **9.2.3**.
- Book source: `components/pwm-generator.tex`.
- RTL SHA-256 (UTF-8, LF): `5b755d94ee3ca21498894f5553b90923c327930b07291c6fedf161ac6a9ae196`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

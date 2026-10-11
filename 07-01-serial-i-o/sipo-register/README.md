# 7.1.3 — SIPO register

Captures one bit per rising edge and shifts the stored word toward higher indices. The complete N-bit state is available in parallel, with the newest bit at position 0 and the oldest retained bit at position N-1.

Companion to *FPGA Identikits* by Andrea Fato, group **7.1 — Serial I/O**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Define bit order before wiring.** The first received bit ends at the highest index after N captures. The default PISO sends LSB first, so a direct PISO-to-SIPO link reverses the word; use the opposite SIPO direction or change one block's serial order for transparent reconstruction.

**Startup is not reset.** With no declared initial value, simulation starts at `'U'` and hardware power-up is device-dependent. The parallel word becomes fully known after reset or after N known serial captures.

**Capture a coherent word.** Downstream logic should use `q` only when a companion valid or count indicates completion. Otherwise it observes a mixture of adjacent words during assembly.

**Check implementation mapping.** Dedicated shift-register resources and reset support vary by device and tool; inspect the synthesized result. An asynchronous source still needs protocol-appropriate sampling or synchronization.

## Files

- [`sipo_register.vhd`](sipo_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_sipo_register.vhd`](tb_sipo_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit sipo-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_sipo_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_sipo_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Serial history.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity sipo_register is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        si  : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity sipo_register;
```

## Source traceability

- Book identikit: **7.1.3**.
- Book source: `components/sipo-register.tex`.
- RTL SHA-256 (UTF-8, LF): `3fbf4e8804cf3524acc6561f1e05e863f6881a2c55f5dabf33e7376cf82730c6`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

# 16.1.1 — ROM with inline initialization

Stores eight fixed 8-bit words in the design. Each rising clock edge selects one word using the current address and loads it into the output register. Address changes between edges do not change the output.

Companion to *FPGA Identikits* by Andrea Fato, group **16.1 — Inline contents and registered reads**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Table initialization is not output reset.** The constant has defined contents, but `dout` has no initializer or reset. Simulation starts with `'U'` on the output until the first rising edge reads a valid address. Hardware register startup is target-dependent; qualify the first result.

**Cover every location.** The `others` association initializes the remaining table entries, here addresses 6 and 7. It is not a fallback for an invalid address. If dimensions change, update the array, address range, word width, and contents consistently.

**Do not promise a block ROM.** A constant table plus an output register may map to block memory, distributed resources, or ordinary logic. This 64-bit example is small enough that dedicated block memory may be wasteful. Inspect synthesis reports instead of inferring the resource from RTL syntax.

**Supply a valid synchronous address.** Address bits must be binary and meet setup and hold requirements. Numeric conversion warnings or coercions for invalid values do not make a defined error interface. Registering the read does not synchronize an asynchronous multi-bit address.

## Files

- [`rom_inline_initialization.vhd`](rom_inline_initialization.vhd): synthesizable reference template (VHDL-2008).
- [`tb_rom_inline_initialization.vhd`](tb_rom_inline_initialization.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit rom-inline-initialization
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_rom_inline_initialization`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_rom_inline_initialization`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Register file/ROM.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity rom_inline_initialization is
    port (
        clk : in std_logic;
        addr : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(7 downto 0)
    );
end entity rom_inline_initialization;
```

## Source traceability

- Book identikit: **16.1.1**.
- Book source: `components/rom-inline-initialization.tex`.
- RTL SHA-256 (UTF-8, LF): `5e72e9e70772d75641ef6b57d7f299e80d783f7dcf2b317c0454b53f9d61ef3e`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

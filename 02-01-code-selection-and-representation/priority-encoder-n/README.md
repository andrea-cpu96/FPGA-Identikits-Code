# 2.1.5 — N-input priority encoder

Returns the index of the highest asserted request among N inputs. The VHDL generic sets the number of requests, and the index width follows automatically. A valid flag distinguishes request zero from an empty request vector.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep the index and flag together.** The index alone cannot distinguish request zero from no request. With `N=1`, the index is one bit wide and always zero; `valid` follows the binary request input.

**Configure the interface once.** Set `N` when instantiating the block and derive the connected index width with the same helper. Non-power-of-two request counts need no padding inputs.

**Selection does not guarantee service.** A persistent high-priority request can prevent lower requests from winning. Surrounding logic must manage acknowledgements; use rotating priority if every requester needs a fair opportunity.

**Check timing as N grows.** The priority logic can become a long combinational path. Consider a hierarchical or pipelined implementation if timing fails. Synchronize or handshake asynchronous requests before selection, then capture the index and flag together.

## Files

- [`priority_encoder_n.vhd`](priority_encoder_n.vhd): synthesizable reference template (VHDL-2008).
- [`tb_priority_encoder_n.vhd`](tb_priority_encoder_n.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit priority-encoder-n
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_priority_encoder_n`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_priority_encoder_n`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `16`
- `2`
- `3`
- `5`
- `8`

Checks include:
- Encoder recovery after nonliteral input.
- Priority encoder binary pattern, highest priority or no request.
- Priority encoder must reject entire nonliteral request word.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity priority_encoder_n is
    generic (N : positive range 1 to 1073741824 := 8);
    port (
        d     : in  std_logic_vector(N-1 downto 0);
        y     : out std_logic_vector(index_width(N)-1 downto 0);
        valid : out std_logic
    );
end entity priority_encoder_n;
```

## Source traceability

- Book identikit: **2.1.5**.
- Book source: `components/priority-encoder-n.tex`.
- RTL SHA-256 (UTF-8, LF): `f8728b879da085c8c998abae7ef216fafab11eba92b215c00077c4c1b90d3808`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

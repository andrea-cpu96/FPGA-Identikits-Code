# 21.2.1 — Fixed-priority arbiter

Grants a shared resource to one of N requesters. When idle, or when the current holder signals done, it registers a one-hot grant for the lowest-index active request. The grant is held, whatever the requests do, until service ends.

Companion to *FPGA Identikits* by Andrea Fato, group **21.2 — Arbitration**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Starvation is part of the contract.** The lowest active index is always served next. Lower indices that keep requesting can hold off index N$-$1 forever; use the round-robin arbiter when every requester needs a bound.

**End every grant with `done`.** Dropping `req` does not release an active grant: the arbiter waits for `done` and ignores requests while the grant is held. The holder must signal completion to unlock the resource. It should also lower `req` by that edge unless it wants another turn.

**Consume grants synchronously.** Meet clock timing for `req` and `done`. Registered grant bits can have physical skew at handover; they do not guarantee asynchronous bus turnaround. Add separate dead-time logic when drivers require it.

**Check priority-chain delay.** The priority chain grows with N and feeds the grant register. For large N, use a tree or look-ahead encoder, or split the arbiter into stages.

## Files

- [`fixed_priority_arbiter.vhd`](fixed_priority_arbiter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_fixed_priority_arbiter.vhd`](tb_fixed_priority_arbiter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit fixed-priority-arbiter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_fixed_priority_arbiter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_fixed_priority_arbiter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `4`

Checks include:
- Arbitration.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity fixed_priority_arbiter is
    generic (N : positive := 4);
    port (
        clk, rst : in  std_logic;
        req      : in  std_logic_vector(N-1 downto 0);
        done     : in  std_logic;
        grant    : out std_logic_vector(N-1 downto 0)
    );
end entity fixed_priority_arbiter;
```

## Source traceability

- Book identikit: **21.2.1**.
- Book source: `components/fixed-priority-arbiter.tex`.
- RTL SHA-256 (UTF-8, LF): `77d4d5edca347b4ffea779e9386740a7d203ce5db36a70e6dcc54aa38a546161`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).

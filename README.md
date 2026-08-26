# MIPS Pipeline Processor

Verilog implementation of a MIPS subset with forwarding, hazard detection, and two memory variants:

- **5-stage pipeline** — IF, ID, EX, MEM, WB.
- **6-stage pipeline** — the MEM stage is split into MEM1 and MEM2 so a word store or load takes two cycles (high 16 bits, then low 16 bits).

Both cores share the same datapath, control, and pipeline-register modules, and both are covered by self-checking testbenches that pass under Icarus Verilog.

## Instruction set

| Type   | Instructions        | Notes                                       |
|--------|---------------------|---------------------------------------------|
| R-type | `add`, `sub`, `slt` | `funct` 0x20 / 0x22 / 0x2A                  |
| I-type | `lw`, `sw`, `beq`   | Standard MIPS encodings                     |
| I-type | `slti`              | Opcode `001010`, as used in the course ISA  |

`$zero` is hard-wired to 0, and writes to it are discarded. An all-zero instruction word decodes to a NOP, so fetching past the end of a program is harmless.

Load and store offsets are **word indices**, not byte offsets — the course ISA does not scale them. `lw $1, 1($0)` reads data word 1.

## Pipeline

```
IF -> ID -> EX -> MEM -> WB          (5-stage)
IF -> ID -> EX -> MEM1 -> MEM2 -> WB (6-stage)
```

Branches are compared in ID and resolved there, so a taken branch costs one flushed instruction instead of three.

### Hazard handling

| Hazard | Resolution |
|--------|------------|
| ALU operand produced by MEM, MEM2 or WB | Forwarded into EX |
| Branch operand produced by MEM or WB | Forwarded into the ID comparator |
| Load-use | One stall, then forwarded from the last memory stage |
| Branch operand still in EX | One stall — there is no EX-to-ID path |
| Branch operand is a load still in a memory stage | Stall until the data reaches WB |
| Taken branch | IF/ID is flushed |

Two subtleties the design has to get right, both covered by `tb/tb_hazards.v`:

- A branch whose operand is being computed in EX cannot be forwarded, so it **must** stall. Without that stall the comparator silently reads a stale register.
- While a branch is stalled its operands are stale, so its comparison is meaningless. The branch decision is therefore gated with the stall signal; otherwise a stale "equal" can flush IF/ID and drop an instruction.

## Repository layout

```
rtl/
  common/          ALU, ALU control, muxes, adder, sign-extend, shifter
  control/         control unit, forwarding unit, hazard detection unit
  datapath/        PC, register file, instruction ROM
  pipeline/        IF/ID, ID/EX, EX/MEM, MEM1/MEM2, MEM/WB
  five_stage/      1-cycle data memory + 5-stage top
  six_stage/       2-cycle data memory + 6-stage top
tb/                self-checking testbenches
programs/          ROM images (.hex) with readable listings (.s)
docs/              original course report
sim/               generated VCD / VVP files (gitignored)
```

Programs are data, not RTL. `InstructionMemory` loads a `.hex` image with `$readmemh`, and each testbench selects one:

```verilog
MipsPipeline #(.PROGRAM("programs/hazards.hex"), .PROGRAM_WORDS(17)) dut (...);
```

`PROGRAM_WORDS` must equal the number of instructions in the image. Initial register and data-memory values are set by the testbench, so the RTL contains no program-specific constants.

## Simulate

Requires [Icarus Verilog](https://steveicarus.github.io/iverilog/).

```bash
make test      # all three testbenches
make sim5      # 5-stage Fibonacci
make hazards   # 5-stage hazard coverage
make sim6      # 6-stage two-cycle memory
make clean
```

Run from the repository root: the `.hex` paths are resolved relative to the working directory. Waveforms land in `sim/*.vcd`.

Expected output:

```
PASS: 5-stage pipeline produced the expected Fibonacci state.
PASS: forwarding, load-use stall and branch hazards all behaved.
PASS: 6-stage pipeline completed the two-cycle store/load sequence.
```

## What the tests check

**`tb_five_stage`** runs `programs/fibonacci.s` with `f(0)=0`, `f(1)=1` in memory and `$30 = $31 = 1`:

| Register | Value |
|----------|-------|
| `$1`–`$5` | 1, 1, 2, 3, 5 |
| `$10`    | 1 (`slti $5, 6`) |
| `$30`    | 5 (loop index) |

The closing `beq` is taken, so the final `sw` must never reach memory.

**`tb_hazards`** runs `programs/hazards.s`, which chains forwarded ALU results, a forwarded store operand, a load-use stall, and two taken branches. Registers that only a wrongly-executed path would write (`$14`, `$15`, `$18`, `$19`) are checked to still be 0, so a branch that falls through cannot pass unnoticed.

**`tb_six_stage`** runs `programs/two_cycle_memory.s`: a two-cycle store followed by a two-cycle load of the same word, then a load-use dependency forwarded out of MEM2. It ends with `$10=8`, `$11=5`, `$12=8`, `$13=11`, `mem[0]=8`.

## Tools

- Icarus Verilog 12 (simulation)
- GTKWave (optional, for the VCD files)

# Hazard torture test for the 5-stage pipeline.
#
# The testbench preloads $8 = 5 and $9 = 3; every other register starts at 0.
# Registers written only on a wrongly-executed path ($14, $15, $18, $19) are
# checked to still be 0, so a mispredicted branch cannot pass unnoticed.

    add $1, $8, $9        # $1 = 8
    add $2, $1, $9        # $2 = 11   EX/MEM -> EX forwarding
    add $3, $2, $1        # $3 = 19   EX/MEM and MEM/WB forwarding
    sw  $3, 0($0)         # mem[0] = 19, store data forwarded
    lw  $4, 0($0)         # $4 = 19
    add $5, $4, $9        # $5 = 22   load-use: one stall, then forward
    add $6, $5, $0        # $6 = 22
    beq $6, $5, 2         # taken: $6 is still in EX, so the branch must stall
    add $14, $9, $9       # must NOT execute
    add $15, $8, $9       # must NOT execute
    add $7, $8, $8        # $7 = 10   branch target
    sw  $7, 1($0)         # mem[1] = 10

# While the next branch is stalled it reads stale zeros for both operands, so
# its comparator says "equal" a cycle early. That must not redirect the PC or
# flush the instruction waiting in IF/ID.
    add $16, $0, $0       # $16 = 0
    beq $16, $17, 2       # taken ($17 is 0)
    add $18, $9, $9       # must NOT execute
    add $19, $9, $9       # must NOT execute
    add $20, $8, $8       # $20 = 10  branch target

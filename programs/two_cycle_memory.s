# Two-cycle data-memory program for the 6-stage pipeline.
#
# The testbench preloads $8 = 5 and $9 = 3.

    add $10, $8,  $9      # $10 = 8
    sw  $10, 0($0)        # mem[0] = 8   high half in MEM1, low half in MEM2
    lw  $12, 0($0)        # $12  = 8     reads both halves back
    add $13, $12, $9      # $13  = 11    load-use, forwarded out of MEM2
    sub $11, $10, $9      # $11  = 5

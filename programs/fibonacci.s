# Fibonacci up to f(5), for the 5-stage pipeline.
#
# Load/store offsets are word indices: the course ISA does not scale them.
# The testbench preloads $30 = 1 (loop index), $31 = 1 (constant),
# and data memory with f(0) = 0, f(1) = 1.

    lw   $0,  0($0)       # no-op, $zero is hard-wired
    lw   $1,  1($0)       # $1  = f(1) = 1
    add  $30, $31, $30    # i++
    add  $2,  $0,  $1     # $2  = 1
    add  $3,  $1,  $2     # $3  = 2
    add  $30, $31, $30    # i++
    add  $4,  $3,  $2     # $4  = 3
    add  $30, $31, $30    # i++
    add  $5,  $4,  $3     # $5  = 5
    add  $30, $31, $30    # i++   (i == 5)
    slti $10, $5,  6      # $10 = 1
    beq  $30, $5,  2      # taken: skips the store
    sw   $1,  0($1)       # not executed

`timescale 1ns / 1ps

// Drives the 5-stage core with a program that hits every hazard class:
// EX/MEM and MEM/WB forwarding, a forwarded store operand, a load-use stall,
// and two taken branches whose operands are not yet available in ID.
module tb_hazards;
    reg clock;
    reg reset;
    integer errors;

    MipsPipeline #(.PROGRAM("programs/hazards.hex"), .PROGRAM_WORDS(17)) dut (
        .clock(clock),
        .reset(reset)
    );

    always #100 clock = ~clock;

    task check;
        input [8*24:1] name;
        input [31:0]   actual;
        input [31:0]   expected;
        begin
            if (actual === expected) begin
                $display("  ok   %0s = %0d", name, actual);
            end else begin
                $display("  FAIL %0s = %0d (expected %0d)", name, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/hazards.vcd");
        $dumpvars(0, tb_hazards);

        errors = 0;
        clock  = 1'b0;
        reset  = 1'b1;
        #550;
        reset  = 1'b0;

        dut.regFile.registers[8] = 32'd5;
        dut.regFile.registers[9] = 32'd3;

        #10000;

        $display("");
        $display("=== 5-stage: hazard coverage ===");
        check("$1  forward",   dut.regFile.registers[1],  32'd8);
        check("$2  forward",   dut.regFile.registers[2],  32'd11);
        check("$3  forward",   dut.regFile.registers[3],  32'd19);
        check("mem[0] store",  dut.dataMemory.memory[0],  32'd19);
        check("$4  load",      dut.regFile.registers[4],  32'd19);
        check("$5  load-use",  dut.regFile.registers[5],  32'd22);
        check("$6",            dut.regFile.registers[6],  32'd22);
        check("$7  target",    dut.regFile.registers[7],  32'd10);
        check("mem[1] store",  dut.dataMemory.memory[1],  32'd10);
        // Non-zero here would mean the first branch fell through.
        check("$14 skipped",   dut.regFile.registers[14], 32'd0);
        check("$15 skipped",   dut.regFile.registers[15], 32'd0);
        check("$20 target",    dut.regFile.registers[20], 32'd10);
        // Non-zero here would mean the stalled branch was dropped or fell through.
        check("$18 skipped",   dut.regFile.registers[18], 32'd0);
        check("$19 skipped",   dut.regFile.registers[19], 32'd0);

        $display("");
        if (errors == 0)
            $display("PASS: forwarding, load-use stall and branch hazards all behaved.");
        else
            $display("FAIL: %0d check(s) failed.", errors);
        $finish;
    end
endmodule

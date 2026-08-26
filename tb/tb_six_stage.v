`timescale 1ns / 1ps

module tb_six_stage;
    reg clock;
    reg reset;
    integer errors;

    MipsPipeline #(.PROGRAM("programs/two_cycle_memory.hex"), .PROGRAM_WORDS(5)) dut (
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
        $dumpfile("sim/six_stage.vcd");
        $dumpvars(0, tb_six_stage);

        errors = 0;
        clock  = 1'b0;
        reset  = 1'b1;
        #550;
        reset  = 1'b0;

        dut.regFile.registers[8] = 32'd5;
        dut.regFile.registers[9] = 32'd3;

        #10000;

        $display("");
        $display("=== 6-stage: two-cycle data memory ===");
        check("$10 add",      dut.regFile.registers[10], 32'd8);
        check("mem[0] store", dut.dataMemory.memory[0],  32'd8);
        check("$12 load",     dut.regFile.registers[12], 32'd8);
        check("$13 load-use", dut.regFile.registers[13], 32'd11);
        check("$11 sub",      dut.regFile.registers[11], 32'd5);

        $display("");
        if (errors == 0)
            $display("PASS: 6-stage pipeline completed the two-cycle store/load sequence.");
        else
            $display("FAIL: %0d check(s) failed.", errors);
        $finish;
    end
endmodule

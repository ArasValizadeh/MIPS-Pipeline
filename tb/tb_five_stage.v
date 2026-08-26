`timescale 1ns / 1ps

module tb_five_stage;
    reg clock;
    reg reset;
    integer errors;

    MipsPipeline #(.PROGRAM("programs/fibonacci.hex"), .PROGRAM_WORDS(13)) dut (
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
        $dumpfile("sim/five_stage.vcd");
        $dumpvars(0, tb_five_stage);

        errors = 0;
        clock  = 1'b0;
        reset  = 1'b1;
        #550;
        reset  = 1'b0;

        // Architectural state the program expects.
        dut.regFile.registers[30]  = 32'd1; // loop index i
        dut.regFile.registers[31]  = 32'd1; // constant 1
        dut.dataMemory.memory[0]   = 32'd0; // f(0)
        dut.dataMemory.memory[1]   = 32'd1; // f(1)

        #10000;

        $display("");
        $display("=== 5-stage: Fibonacci ===");
        check("$1  f(1)",   dut.regFile.registers[1],  32'd1);
        check("$2  f(2)",   dut.regFile.registers[2],  32'd1);
        check("$3  f(3)",   dut.regFile.registers[3],  32'd2);
        check("$4  f(4)",   dut.regFile.registers[4],  32'd3);
        check("$5  f(5)",   dut.regFile.registers[5],  32'd5);
        check("$10 slti",   dut.regFile.registers[10], 32'd1);
        check("$30 i",      dut.regFile.registers[30], 32'd5);
        // The branch is taken, so the store must never reach memory.
        check("mem[1]",     dut.dataMemory.memory[1],  32'd1);

        $display("");
        if (errors == 0)
            $display("PASS: 5-stage pipeline produced the expected Fibonacci state.");
        else
            $display("FAIL: %0d check(s) failed.", errors);
        $finish;
    end
endmodule

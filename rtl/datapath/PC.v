`timescale 1ns / 1ps

module PC (
    input  wire        clock,
    input  wire [31:0] nextPC,
    output reg  [31:0] outPC,
    input  wire        reset,
    input  wire        holdPC
);
    initial outPC = 32'b0;

    always @(posedge clock or posedge reset) begin
        if (reset)
            outPC <= 32'b0;
        else if (!holdPC)
            outPC <= nextPC;
    end
endmodule

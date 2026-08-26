`timescale 1ns / 1ps

module ALUControl (
    input  wire [3:0] ALUOp,
    input  wire [5:0] funct,
    output reg  [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            4'b0000: ALUControl = 4'b0000; // lw / sw  -> add
            4'b0001: ALUControl = 4'b0001; // beq      -> sub
            4'b0101: ALUControl = 4'b1000; // slti     -> slt
            4'b0010: begin                 // R-type
                case (funct)
                    6'b100000: ALUControl = 4'b0000; // add
                    6'b100010: ALUControl = 4'b0001; // sub
                    6'b101010: ALUControl = 4'b1000; // slt
                    default:   ALUControl = 4'b0000;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end
endmodule

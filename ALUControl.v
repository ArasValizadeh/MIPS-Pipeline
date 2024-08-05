module ALUControl(
    input [3:0] ALUOp,
    input [5:0] funct,
	output reg [3:0] ALUControl
);
always @(*)begin
        case (ALUOp)
            4'b0000: begin
				ALUControl = 4'b0000;
			end
            4'b0001: begin 
				ALUControl = 4'b0001;
			end
            4'b0101: begin 
				ALUControl = 4'b1000;
			end
            4'b0010: begin
                case (funct)
                    6'b100000: begin 
						ALUControl = 4'b0000;
					end
                    6'b100010: begin 
						ALUControl = 4'b0001; 
					end
                    6'b101010: begin 
						ALUControl = 4'b1000;
					end
                    default: ALUControl = 4'bxxxx;
                endcase
            end
            default: ALUControl = 4'bxxxx;
        endcase
    end
endmodule

module InstructionMemory(
	input clock,
	input [31:0] pc ,
	output reg [31:0] readData
);
reg [31:0] instructionMemory [0:1060];
initial begin
	instructionMemory[0] = 32'h8C000000 ; //lw 
	instructionMemory[4] = 32'h8C010001 ; //lw 
	instructionMemory[8] = 32'h03FEF020 ; // i++
	instructionMemory[12] = 32'h00011020 ; // add 2
	instructionMemory[16] = 32'h00221820 ; // add 3 
	instructionMemory[20] = 32'h03FEF020 ; // i++
	instructionMemory[24] = 32'h00622020; // add 4
	instructionMemory[28] = 32'h03FEF020 ; // i++
	instructionMemory[32] = 32'h00832820; // add 5
	instructionMemory[36] = 32'h03FEF020 ; // i++
	instructionMemory[40] = 32'h28AA0006 ; //lsti
	// 0010 1000 1010 1010 0000 0000 0000 0110
	instructionMemory[44] = 32'h13C50002 ; // beq
	instructionMemory[48] = 32'hAC210000 ; // sw
	// 1010 1100 0010 0001 0000 0000 0000 0000
end
always @ (pc)begin	
	readData <= instructionMemory[pc];
end				
endmodule	


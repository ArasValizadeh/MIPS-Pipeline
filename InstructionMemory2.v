module InstructionMemory(
	input clk,
	input [31:0] pc,
	output reg [31:0] readdata
);
reg [31:0] instructionMemory [0:1023];

initial begin
		instructionMemory[0] = 32'h01095020 ;
		instructionMemory[1] = 32'hAC0A0000 ;
		instructionMemory[2] = 32'h01495822 ;
		instructionMemory[3] = 32'h1168FFFC ;  
		instructionMemory[4] = 32'hAC0A0000 ;
end


always @ (pc)begin	 
	readdata <= instructionMemory[pc>>2];
end			
		
endmodule	

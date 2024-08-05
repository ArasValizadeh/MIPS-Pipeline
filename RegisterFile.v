module RegisterFile(
	input clock,
	input [4:0] readRegister1, 
	input [4:0] readRegister2, 
	input [4:0] RegisterAddress, 
	input [31:0] WriteData,
	input writeSignal, 
	output reg [31:0] ReadData1, 
	output reg [31:0] ReadData2, 
	input reset
);
    reg [31:0] registers[0:31];
	always @(posedge reset) begin
		registers[0] <= 32'h00000000;
		registers[1] <= 32'h00000000;
		// saving i 
		registers[30] <= 32'h00000001;
		// saving constant 1
		registers[31] <= 32'h00000001 ;
	end
	always @(readRegister1, readRegister2) begin
		ReadData1 <= registers[readRegister1];
  		ReadData2 <= registers[readRegister2];
	end
	always @(negedge clock) begin
  		if (writeSignal == 1)begin
			registers[RegisterAddress] <= WriteData;
      	end
  	end
	always @(clock) begin
		$display("register 0 : %d" , registers[0]);
		$display("register 1 : %d " , registers[1]);
		$display("register 2 : %d " , registers[2]);
		$display("register 3 : %d " , registers[3]);
		$display("register 4 : %d " , registers[4]);
		$display("register 5 : %d " , registers[5]);
		$display("i : %d " , registers[30]);	
		$display("register 10 (lst) : %d ", registers[10]);
		#1500;	
	end
endmodule

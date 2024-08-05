module EX_MemReg (
  input clock,
  input registerWrite,
  input memoryToRegister,
  input memoryWrite,
  input memoryRead,
  input [31:0] ALUresult,
  input [31:0] writeData,
  input [4:0] writeRegister,
  output reg registerWriteOut,
  output reg memoryToRegisterOut,
  output reg memoryWriteOut,
	output reg memoryReadOut,
  output reg [31:0] ALUresultOut,
  output reg [31:0] writeDataOut,
  output reg [4:0] writeRegisterOut
);
always@(posedge clock)begin
      writeDataOut <= writeData;
      memoryToRegisterOut <= memoryToRegister;
      writeRegisterOut <= writeRegister;    
      registerWriteOut <= registerWrite;
      memoryWriteOut <= memoryWrite;
      memoryReadOut <= memoryRead;
      ALUresultOut <= ALUresult;
end
endmodule
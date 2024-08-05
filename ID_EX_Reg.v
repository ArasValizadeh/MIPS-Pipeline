module ID_EX_reg (
  input wire clock , 
  input wire registerWrite,
  input wire memoryToRegister,
  input wire memoryWrite,
  input wire memoryRead,
  input wire ALUSrc,
  input wire[3:0] ALUOp,
  input wire registerDestination,
  input wire [31:0] PCplus4 ,
  input wire [31:0] data1Input ,
  input wire [31:0] data2Input,
  input wire [31:0] signExtendResultInput ,
  input wire[14:0] registerAddressInput ,
  output reg [31:0] PCplus4out ,
  output reg [31:0] data1Output ,
  output reg [31:0] data2Output ,
  output reg [31:0] signExtendResultOutput ,
  output reg [4:0]rsOut ,
  output reg [4:0]rtOut ,
  output reg [4:0]rdOut,
  output reg registerWriteOutput,
  output reg memoryToRegisterOutput,
  output reg memoryWriteOutput,
  output reg memoryReadOutput,
  output reg ALUSrcOut,
  output reg [3:0]ALUOpOut,
  output reg registerDestinationOut
);
  always @(posedge clock)
    begin
      PCplus4out <= PCplus4;
      data1Output <= data1Input;
      data2Output <= data2Input;
      signExtendResultOutput <= signExtendResultInput;
      rsOut <= registerAddressInput[14:10];
      rtOut <= registerAddressInput[9:5];
      rdOut <= registerAddressInput[4:0];
      registerWriteOutput <= registerWrite;
      memoryToRegisterOutput <= memoryToRegister;
      memoryWriteOutput <= memoryWrite;
      memoryReadOutput <= memoryRead;
      ALUSrcOut <= ALUSrc;
      ALUOpOut <= ALUOp;
      registerDestinationOut <= registerDestination;
    end
endmodule

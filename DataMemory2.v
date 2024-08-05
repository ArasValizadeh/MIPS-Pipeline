module DataMemory (
  input memoryWrite1,
  input memoryWrite2,
  input memoryRead1,
  input memoryRead2,
  input [31:0] address1,
  input [31:0] address2,
  input [15:0] writeData1,
  input [15:0] writeData2,
  input clock,
  output reg [15:0] readData1,
  output reg [15:0] readData2
);
  reg[31:0] memory [0:31];
  always@(negedge clock) begin
      $display("memory: %d", memory[address2]);
      if(memoryWrite1==1)begin
        memory[address1][31:16]<=writeData1;
      end
      if(memoryWrite2==1)begin
        memory[address2][15:0]<=writeData2;
      end
  end
  always@(address1 or address2 or memoryRead1 or memoryRead2)begin
      if(memoryRead1==1)begin
        readData1=memory[address1][31:16]; 
      end
      if(memoryRead2==1)begin
        readData2=memory[address2][15:0];
      end
  end
endmodule

module DataMemory (
  input clock,
  input memoryWrite,
  input memoryRead,
  input [31:0] address,
  input [31:0] writeData,
  output reg [31:0]readData
);
reg[31:0] memory [0:1023];
initial begin
// f(0)
memory[0] = 32'h00000000;
// f(1)
memory[1] = 32'h00000001;
end
always@(negedge clock) begin
    $display("address : %d",address);
    $display("writeData : %d",writeData);
    if(memoryWrite==1) begin 
        memory[address]<=writeData;
    end
    #1000
    $display("memory 1 : %d",memory[1]);
end
always@(address or memoryRead)begin
    if(memoryRead==1) begin 
        readData=memory[address]; 
    end
end
endmodule

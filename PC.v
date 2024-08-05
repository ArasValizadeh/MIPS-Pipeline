module PC (
  input clock , 
  input wire [31:0] nextPC ,
  output reg [31:0] outPC ,
  input reset ,
  input holdPC
);
always@(posedge reset) begin
  outPC <= 32'hFFFFFFFC;
end
always @(posedge clock)begin
  //to support stalls from hazard detection unit
	if (holdPC==0) begin
    outPC <= nextPC;
	end
end
endmodule

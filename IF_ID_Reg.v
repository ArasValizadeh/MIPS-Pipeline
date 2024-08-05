module IF_ID_reg(
  input clk ,
  input wire[31:0] PCplus4 ,
  input wire[31:0] instrIn ,
  output reg [31:0] instrOut ,
  input hold,
  output reg[31:0] PCplus4Out,
  input IF_flush
);
  always @(posedge clk)
    begin
      if (hold==1'b0) begin   
      PCplus4Out<=PCplus4;
      instrOut <= instrIn;   
      end
      else if (IF_flush==1'b1) begin
          PCplus4Out<=PCplus4; 
          instrOut<=32'b0;
      end
    end
endmodule

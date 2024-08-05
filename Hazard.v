module HazardDetectionUnit(
  input ID_ExMemRead,
  input EX_MemMemRead,
  input [4:0] ID_Ex_Rt,
  input [31:0] IF_ID_Instr,
  output reg holdPC,
  output reg holdIF_ID,
  output reg muxSelector
);
  initial begin
	holdPC <= 0;
	holdIF_ID <= 0;
	muxSelector <= 0;
	end
  always@(ID_ExMemRead or ID_Ex_Rt or IF_ID_Instr) begin
      if (ID_ExMemRead && (holdPC == 1'b0) && (holdIF_ID == 1'b0)) begin
          if(ID_Ex_Rt==IF_ID_Instr[25:21] || ID_Ex_Rt==IF_ID_Instr[20:15] )begin
              holdPC<=1;
              holdIF_ID<=1;
              muxSelector<=1;
          end
      end
        // beq opcode 
      else if((IF_ID_Instr [31:26]==6'b000100) && (holdPC == 1'b0) && (holdIF_ID == 1'b0)) begin
          holdPC<=1;
          holdIF_ID<=1;
          muxSelector<=1;
      end
      else begin
          holdPC<=0;
          holdIF_ID<=0;
          muxSelector<=0;     
      end    
    end
endmodule
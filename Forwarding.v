module ForwardingUnit (
  input EX_MemRegwrite,
  input [4:0] EX_MemWriteReg,
  input Mem_WbRegwrite,
  input [4:0] Mem_WbWriteReg,
  input [4:0] ID_Ex_Rs,
  input [4:0] ID_Ex_Rt,
  output reg [1:0] upperMux_sel,
  output reg [1:0] lowerMux_sel,
  output reg [1:0] comparatorMux1Selector,
  output reg [1:0] comparatorMux2Selector
);
  always@(EX_MemRegwrite or EX_MemWriteReg or Mem_WbRegwrite or Mem_WbWriteReg or ID_Ex_Rs or ID_Ex_Rt)begin
    //forwarding from ALU to ALU & from ALU to ID stage
      if(EX_MemRegwrite && EX_MemWriteReg)  begin
          if (EX_MemWriteReg==ID_Ex_Rs)begin
            upperMux_sel<=2'b10;
            comparatorMux1Selector<=2'b01;
          end
          else //no forwarding
          begin
          upperMux_sel<=2'b00;
          comparatorMux1Selector<=2'b00;
          end  
          if(EX_MemWriteReg==ID_Ex_Rt)begin
            lowerMux_sel<=2'b10;
            comparatorMux2Selector<=2'b01;
          end
          else //no forwarding
          begin
          lowerMux_sel<=2'b00;
          comparatorMux2Selector<=2'b00;
          end
      end
      else if (Mem_WbRegwrite && Mem_WbWriteReg)   //forwarding from Memorystage to ALU & from Memorystage to ID stage
        begin
          if ((Mem_WbWriteReg==ID_Ex_Rs) && (EX_MemWriteReg!=ID_Ex_Rs))
            begin
            upperMux_sel<=2'b01;
            comparatorMux1Selector<=2'b10;
            end
          else //no forwarding
          begin
          upperMux_sel<=2'b00;
          comparatorMux1Selector<=2'b00;
          end 
          if((Mem_WbWriteReg==ID_Ex_Rt) && (EX_MemWriteReg==ID_Ex_Rt) )
          begin
            lowerMux_sel<=2'b01;
            comparatorMux2Selector<=2'b10;
          end
          else //no forwarding
          begin
          lowerMux_sel<=2'b00;
          comparatorMux2Selector<=2'b00;
          end
        end
      else begin
         //No forwarding             
          upperMux_sel<=2'b00;
          lowerMux_sel<=2'b00;
          comparatorMux1Selector<=2'b00;
          comparatorMux2Selector<=2'b00;
          
       end
        
  end
endmodule

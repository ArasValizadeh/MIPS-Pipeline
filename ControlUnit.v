module ControlUnit (
  input [5:0] opCode ,
  output reg registerDestination,
  output reg branch,
  output reg memoryRead,
  output reg memoryToRegister,
  output reg [3:0] ALUop,
  output reg memoryWrite,
  output reg AluSrc,
  output reg registerWrite,
  input reset
); 
  always @(posedge reset)begin
   registerDestination <= 1'b0;
   branch <= 1'b0;
   memoryRead <= 1'b0;
   memoryToRegister <= 1'b0;
   ALUop <= 4'b0000;
   memoryWrite <= 1'b0;
   AluSrc <= 1'b0;
   registerWrite <= 1'b0;
  end
  always@(opCode) begin
      case (opCode)
        6'b000000:    // Rtype       
          begin
          registerDestination<=1 ;
          branch<=0 ;
          memoryRead<=0 ;
          memoryToRegister<=0 ;
          memoryWrite<=0 ;
          AluSrc<=0 ;
          registerWrite<=1 ;
          ALUop<=4'b0010 ;
          end
        6'b001010: //slti
        begin
          registerDestination<=0 ;
          branch<=0 ;
          memoryRead<=0 ;
          memoryToRegister<=0 ;
          memoryWrite<=0 ;
          AluSrc<=1 ;
          registerWrite<=1 ;
          ALUop<=4'b0101 ;
        end
        6'b100011:  begin // lw
          registerDestination<=0 ;
          branch<=0 ;
          memoryRead<=1 ;
          memoryToRegister<=1 ;
          memoryWrite<=0 ;
          AluSrc<=1 ;
          registerWrite<=1 ;
          ALUop<=4'b0000 ;
          end
        6'b101011:  begin   //sw      
        $display("Stroe detected");
          branch<=0 ;
          memoryRead<=0 ;
          memoryToRegister<=0 ;
          memoryWrite<=1 ;
          AluSrc<=1 ;
          registerWrite<=0 ;
          ALUop<=4'b0000 ;
          end
        6'b000100:     //beq      
          begin
          branch<= 1;
          memoryRead<=0 ;
          memoryToRegister<=0 ;
          memoryWrite<=0 ;
          AluSrc<=0 ;
          registerWrite<=0 ;
          ALUop<=4'b0001 ;
          end
      endcase
  end 
endmodule

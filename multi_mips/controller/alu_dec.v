module ALUDec 
(
  input [5:0] funct,
  input [1:0] aluop,
  output reg [2:0] alucontrol
);
   always @ (*) begin
/*	  $display("funct=%b, aluop=%b", funct, aluop);*/

      case (aluop)
      2'b00: alucontrol = 3'b010; // add
      2'b01: alucontrol = 3'b110; // sub
      default:
        case(funct) // RTYPE
          6'b100000: alucontrol = 3'b010; // ADD
          6'b100010: alucontrol = 3'b110; // SUB
          6'b100100: alucontrol = 3'b000; // AND
          6'b100101: alucontrol = 3'b001; // OR
          6'b101010: alucontrol = 3'b111; // SLT
          default begin
 			alucontrol  = 3'bxxx; 
/*			$display("aludec error. unknown input funct: '%b'", funct); // ???*/
		  end
       endcase
     endcase
  end
endmodule
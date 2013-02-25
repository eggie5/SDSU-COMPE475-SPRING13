module Controller  
(
 input [5:0] op, funct,
 input zero,
 output memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump,
 output [2:0] alucontrol
);

  wire [1:0] aluop;
  wire branch;

  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);
  aludec ad (funct, aluop, alucontrol);
  
  assign pcsrc = branch & zero;

endmodule

module maindec
(
 input [5:0] op,
 output memtoreg, memwrite, branch, alusrc, regdst,
 output regwrite, jump,
 output [1:0] aluop
);

  reg [8:0] controls;
  
  assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop} = controls;
  
  always @ (*)
    case(op)
      6'b000000: controls = 9'b110000010; //Rtyp
      6'b100011: controls = 9'b101001000; //LW
      6'b101011: controls = 9'b001010000; //SW
      6'b000100: controls = 9'b000100001; //BEQ
      6'b001000: controls = 9'b101000000; //ADDI
      6'b000010: controls = 9'b000000100; //J
      default:   controls = 9'bxxxxxxxxx; //???
    endcase
endmodule

module aludec 
(
  input [5:0] funct,
  input [1:0] aluop,
  output reg [2:0] alucontrol
);
   always @ (*)
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
          default: alucontrol  = 3'bxxx; // ???
       endcase
     endcase
endmodule

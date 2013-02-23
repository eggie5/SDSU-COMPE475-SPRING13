
module controller  (input [5:0] op, funct,
          input zero,
output memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump,
output [2:0] alucontrol);
wire [1:0] aluop;
wire branch;
  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);
  aludec ad (funct, aluop, alucontrol);
  assign pcsrc = branch & zero;
endmodule

module maindec(input [5:0] op,
     output memtoreg, memwrite, branch, alusrc, regdst,      output regwrite, jump,
     output [1:0] aluop);
reg [8:0] controls;
  assign {regwrite, regdst, alusrc,branch, memwrite,
          memtoreg, jump, aluop} = controls;
  always @ (*)
    case(op)
      6íb000000: controls = 9íb110000010; //Rtyp
      6íb100011: controls = 9íb101001000; //LW
      6íb101011: controls = 9íb001010000; //SW
      6íb000100: controls = 9íb000100001; //BEQ
      6íb001000: controls = 9íb101000000; //ADDI
      6íb000010: controls = 9íb000000100; //J
      default:  controls = 9íbxxxxxxxxx; //???
    endcase
endmodule

module aludec (input [5:0] funct,
     input [1:0] aluop,
     output reg [2:0] alucontrol);
   always @ (*)
      case (aluop)
      2b00: alucontrol = 3íb010; // add
      2b01: alucontrol = 3íb110; // sub
      default:
        case(funct) // RTYPE
          6íb100000: alucontrol = 3íb010; // ADD
          6íb100010: alucontrol = 3íb110; // SUB
          6íb100100: alucontrol = 3íb000; // AND
          6íb100101: alucontrol = 3íb001; // OR
          6íb101010: alucontrol = 3íb111; // SLT
          default: alucontrol  = 3íbxxx; // ???
       endcase
     endcase
endmodule

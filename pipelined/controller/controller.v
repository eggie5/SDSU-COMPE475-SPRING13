module Controller  
(
 input clk,
 input [5:0] op, funct,
 input zero,
 output MemtoRegW,
 output MemWriteM, 
 output PCSrcM, ALUSrcE, RegDstE, RegWriteW, jump,
 output [2:0] ALUControlE
);

  wire [1:0] aluop;
  wire branch;

  wire memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump;
  wire [2:0] alucontrol;

  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);
  aludec ad (funct, aluop, alucontrol);
  
  assign PCSrcM = BranchM & zero;


  //delay all the outputs from maindec below
  wire MemtoRegE, MemtoRegM, MemtoRegW;
  wire RegWriteE, RegWriteM, RegWriteW;
  wire MemWriteE, MemWriteM;
  wire BranchE, BranchM;
  wire ALUSrcE;
  wire RegDstE;
  wire [2:0] ALUControlE;

  DFF #(1) memtoreg_D (clk, 0, 1'b1, memtoreg, MemtoRegE);
  DFF #(1) memtoreg_E (clk, 0, 1'b1, MemtoRegE, MemtoRegM);
  DFF #(1) memtoreg_M (clk, 0, 1'b1, MemtoRegM, MemtoRegW);

  DFF #(1) regwrite_D (clk, 0, 1'b1, regwrite, RegWriteE);
  DFF #(1) regwrite_E (clk, 0, 1'b1, RegWriteE, RegWriteM);
  DFF #(1) regwrite_M (clk, 0, 1'b1, RegWriteM, RegWriteW);

  DFF #(1) memwrite_D (clk, 0, 1'b1, memwrite, MemWriteE);
  DFF #(1) memwrite_E (clk, 0, 1'b1, MemWriteE, MemWriteM);

  DFF #(1) branch_D (clk, 0, 1'b1, branch, BranchE);
  DFF #(1) branch_E (clk, 0, 1'b1, BranchE, BranchM);

  DFF #(1) alusrc_D (clk, 0, 1'b1, alusrc, ALUSrcE);

  DFF #(1) regdst_D (clk, 0, 1'b1, regdst, RegDstE);

  DFF #(3) alucontrol_D (clk, 0, 1'b1, alucontrol, ALUControlE);
  //end delay code

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
   always @ (*) begin	
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

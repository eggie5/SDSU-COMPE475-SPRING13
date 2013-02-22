module Instr_Decode(
	Instruction, Opcode, R1, R2, R3, Immediate, Jump, Funct
    );

input [31:0] Instruction;
output [5:0] Opcode;
output [4:0] R1;
output [4:0] R2;
output [4:0] R3;
output [15:0] Immediate;
output [25:0] Jump;
output [5:0] Funct;

assign Opcode = Instruction [31:26];
assign R1 = Instruction[25:21];
assign R2 = Instruction[20:16];
assign R3 = Instruction[15:11];
assign Immediate = Instruction[15:0];
assign Jump = Instruction[25:0];
assign Funct = Instruction[5:0];





endmodule
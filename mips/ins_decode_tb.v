`include "ins_decode.v"
module Instr_Decode_tb();

reg [31:0] Instruction;
wire [5:0] Opcode;
wire [4:0] R1;
wire [4:0] R2;
wire [4:0] R3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;

Instr_Decode decoder (Instruction, Opcode, R1, R2, R3, Immediate, Jump, Funct);


initial begin
	Instruction = 0;
	
	$display("time\tins\t\t\t\t\tOpcode\tR1\tR2\tR3\tImm\t\t\tJump\t\t\t\tFunct"); 
	$monitor("%g\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, Instruction, Opcode, R1, R2, R3, Immediate, Jump, Funct);
	
	#1; Instruction=32'b1001_1101_0100_1001_1111_1111_1001_1100;
end


endmodule
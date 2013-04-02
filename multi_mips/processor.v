module Processor(input clk);

wire [5:0] Opcode;
wire [5:0] Funct; //output from DP and input to controller

DataPath dp (clk, MemToReg, RegDst, IorD, PCSrc, PCEn, ALUSrcA, ALUSrcB, 
	IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl, //end of inputs
	Opcode, Funct //outputs
	);


Controller controller (clk, Opcode, Funct, //end of inputs
	MemToReg, RegDst, IorD, PCSrc, PCEn, ALUSrcA, ALUSrcB, 
	IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl
	);

endmodule
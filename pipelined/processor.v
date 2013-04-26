`include "datapath/datapath.v"
`include "controller/controller.v"

module Processor(input clk, input reset);

//controller
wire MemToReg;
wire MemWrite, PCSrc, ALUSrcA, RegDst, RegWrite, Jump;
wire [2:0] ALUControl;
wire zero;
wire [5:0] Opcode, Funct;

Controller controller (clk, Opcode, Funct, zero, //end of inputs
	MemToReg, MemWrite, PCSrc, ALUSrcA, RegDst, RegWrite, Jump, ALUControl
	);

//datapath
DataPath dp (clk, reset, MemToReg, RegDst, PCSrc, ALUSrcA, MemWrite, RegWrite, ALUControl, 
	Opcode, Funct, zero //outputs
	);

   	 

endmodule
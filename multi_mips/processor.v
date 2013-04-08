`include "datapath/datapath.v"
`include "controller/controller.v"

module Processor(input clk, input reset);

//controller
wire MemToReg, RegDst, IorD;
wire [1:0] PCSrc;
wire ALUSrcA, zero;
wire IRWrite;
wire MemWrite, PCWrite, Branch, RegWrite;
wire [1:0] ALUSrcB;
wire [2:0] ALUControl;
wire [5:0] Opcode, Funct;


Controller controller (clk, reset, Opcode, Funct, zero, //end of inputs
	MemToReg, RegDst, IorD, PCSrc, ALUSrcA, ALUSrcB, 
	IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl
	);	//PCEn

//datapath
DataPath dp (clk, reset,
	MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUSrcB, ALUControl, 
	Opcode, Funct);


endmodule
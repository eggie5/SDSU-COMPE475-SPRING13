`include "datapath/datapath.v"
`include "controller/controller.v"
`include "hazard_unit/hazard_unit.v"

module Processor(input clk, input reset);

//controller
wire MemToReg;
wire MemWrite, PCSrc, ALUSrcA, RegDst, RegWrite_W, Jump;
wire [2:0] ALUControl;
wire zero;
wire [5:0] Opcode, Funct;
wire [1:0] ForwardAE, ForwardB;
wire [5:0] WriteRegE, WriteReg_M, WriteReg_W;

Controller controller (clk, Opcode, Funct, zero, //end of inputs
	MemToReg, MemWrite, PCSrc, ALUSrcA, RegDst, RegWrite_W, Jump, ALUControl,
	BranchD, RegWriteE, RegWrite_M, MemToReg_E // new outputs for hazard
	);

//datapath
DataPath dp (clk, reset, MemToReg, RegDst, PCSrc, ALUSrcA, MemWrite, RegWrite_W, Jump, ALUControl, 
	StallF, StallD, FlushE, ForwardAD, ForwardBD, //new inputs for haz
	ForwardAE, ForwardBE,
	Opcode, Funct, zero, //outputs
	RS_D, RT_D, RS_EX, RT_EX, //new outputs stuff for haz unit
	WriteRegE, WriteReg_M, WriteReg_W);

HazardUnit hu (
	RS_EX,
	RT_EX,
	RS_D,
	RT_D,
	WriteReg_M,
	WriteReg_W,
	RegWrite_M,
	RegWrite_W,
	MemToReg_E,
	BranchD,
	ForwardAE,
	ForwardBE,
	ForwardAD, ForwardBD,
	StallF, 
	StallD, 
	FlushE);	 

endmodule
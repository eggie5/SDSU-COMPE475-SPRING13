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
wire [4:0] RS_D;
wire [4:0] RT_D;
wire [4:0] RS_EX;
wire [4:0] RT_EX;
wire [1:0] ForwardBE;
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
	WriteRegE,
	WriteReg_M,
	WriteReg_W,
	RegWriteE,
	RegWrite_M,
	RegWrite_W,
	MemToReg_E,
	MemToReg,
	BranchD,
	ForwardAE,
	ForwardBE,
	ForwardAD, ForwardBD,
	StallF, 
	StallD, 
	FlushE);	 

endmodule
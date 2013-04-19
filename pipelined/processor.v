`include "datapath/datapath.v"
`include "controller/controller.v"

module Processor(input clk, input reset);

//controller
wire MemToReg, RegDst;
wire PCSrc;
wire ALUSrcA, zero;
wire MemWrite, PCWrite, Branch, RegWrite;
wire  ALUSrcB;
wire [2:0] ALUControl;
wire [5:0] Opcode, Funct;

Controller controller (clk, Opcode, Funct, zero, //end of inputs
	MemToReg, MemWrite,PCSrc, ALUSrcA, RegDst,RegWrite, Jump, ALUControl
	);

//datapath
DataPath dp (clk, reset, MemToReg, RegDst, PCSrc, ALUSrcA, MemWrite, PCWrite, Branch, RegWrite, ALUSrcB, ALUControl, Opcode, Funct);

   	         

endmodule
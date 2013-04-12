`include "datapath/alu.v"
`include "datapath/dff.v"
`include "datapath/decoder.v"
`include "datapath/mux21.v"
`include "datapath/mux31.v"
`include "datapath/mux41.v"
`include "datapath/memory.v"
`include "datapath/reg.v"
`include "datapath/sign_ext.v"

module DataPath(
input clk, reset,
input MemToReg, RegDst, IorD, 
input [1:0] PCSrc, 
input ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite,
input [1:0] ALUSrcB, 
input [2:0] ALUControl,
output [5:0] Opcode, Funct //send to controller
);

parameter addWidth = 6, dataWidth=32;

//pc
wire PCEn;
wire [addWidth-1:0] Adr;

//memory
wire [dataWidth-1:0] mem_out;
wire [dataWidth-1:0] instruction;
wire [dataWidth-1:0] Data;


//decode instrution
wire [5:0] Opcode;
wire [addWidth-2:0] A1;
wire [addWidth-2:0] A2;
wire [addWidth-2:0] A3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;

//reg
wire [dataWidth-1:0] RD1;
wire [dataWidth-1:0] RD2;
wire [dataWidth-1:0] A;
wire [dataWidth-1:0] B;
wire [dataWidth-1:0] WD3_mux_out;

//alu
wire [dataWidth-1:0] ALUOut; // after reg
wire alu_zero;

//sign extender
wire [dataWidth-1:0] SignImm;

//PC -- the width of these should be addWidth
ProgramCounter #(PCW) pc (clk, pc_clr, PCSrc, SignImm, pc_out); //PCSrc is from controller

//Mem
Memory #(addWidth, dataWidth) mem (clk, MemWrite, Adr, B, mem_out);

//fetch reg
DFF #(dataWidth) fetch_reg (clk, 0, IRWrite, mem_out, instruction);

//Decoder
Decoder decoder (instruction, Opcode, A1, A2, A3, Immediate, Jump, Funct);
 

//Register File
Register #(addWidth-1, dataWidth) reg_file (clk, RegWrite, A1, A2, a3_mux_out, WD3_mux_out, RD1, RD2);
 
//SEX
SignExtender sext(Immediate, SignImm);

//ALU
ALU alu (ALUControl, srcA_mux_out, srcB_mux_out, ALUResult, alu_zero);
 

assign PCEn = alu_zero & Branch; // goes to pc



endmodule
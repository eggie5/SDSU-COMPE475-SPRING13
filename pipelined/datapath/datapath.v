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
input MemToReg, RegDstE, 
input [1:0] PCSrc, 
input ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWriteW,
input [1:0] ALUSrcE, 
input [2:0] ALUControlE,
output [5:0] Opcode, Funct //send to controller
);

parameter addWidth = 6, dataWidth=32;

//pc
wire PCEn;
wire [addWidth-1:0] Adr;

//memory
wire [dataWidth-1:0] mem_out;
wire [dataWidth-1:0] instruction;
wire [dataWidth-1:0] InstrD;
wire [dataWidth-1:0] Data;
wire [dataWidth-1:0] WriteDataM;


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
wire [dataWidth-1:0] SrcAE;
wire [dataWidth-1:0] B;
wire [dataWidth-1:0] WD3_mux_out;

//alu
wire [dataWidth-1:0] ALUOutM; // after reg
wire [dataWidth-1:0] SrcBE;
wire alu_zero;
wire ZeroM;

//sign extender
wire [dataWidth-1:0] SignImm;
wire [dataWidth-1:0] SignImmE;

//PC -- the width of these should be addWidth
ProgramCounter #(PCW) pc (clk, pc_clr, PCSrc, SignImmE, pc_out); //PCSrc is from controller

//Mem
Memory #(addWidth, dataWidth) mem (clk, 0, pc_out, 1'bx, mem_out);

//fetch reg
DFF #(dataWidth) decode_reg (clk, 0, 1, mem_out, InstrD);

//Decoder
Decoder decoder (InstrD, Opcode, A1, A2, A3, Immediate, Jump, Funct);

//Register File
Register #(addWidth-1, dataWidth) reg_file (clk, RegWriteW, A1, A2, a3_mux_out, WD3_mux_out, RD1, RD2);
DFF #(dataWidth) execute_reg_rd1 (clk, 0, 1, RD1, SrcAE);
DFF #(dataWidth) execute_reg_rd2 (clk, 0, 1, RD2, B);
DFF #(dataWidth) execute_reg_rte (clk, 0, 1, A2, RtE);
DFF #(dataWidth) execute_reg_rde (clk, 0, 1, A3, RdE);
MUX21 #(addWidth-1) a3_mux (RtE, RdE, RegDstE, WriteRegE);

//SEX
SignExtender sext(Immediate, SignImm);
DFF #(dataWidth) decode_dff_sex (clk, 0, 1, SignImm, SignImmE);

//ALU
MUX21 #(dataWidth) srcB_mux (B, SignImmE, ALUSrcE, SrcBE) ; 
ALU alu (ALUControlE, SrcAE, SrcBE, ALUResult, alu_zero);
DFF #(dataWidth) mem_reg_zero (clk, 0, 1, alu_zero, ZeroM);
DFF #(dataWidth) mem_reg_alu (clk, 0, 1, ALUResult, ALUOutM);
DFF #(dataWidth) mem_reg_write_data (clk, 0, 1, B, WriteDataM);
DFF #(dataWidth) mem_reg_write_reg (clk, 0, 1, WriteRegE, WriteRegM);
 
//memory
Memory #(addWidth, dataWidth) mem (clk, MemWriteM, ALUOutM, WriteDataM, mem_out);
DFF #(dataWidth) write_reg_memout (clk, 0, 1, mem_out, ReadDataW);
DFF #(dataWidth) write_reg_aluout (clk, 0, 1, ALUOutM, ALUOutW);

MUX21 #(dataWidth) mem_out_mux (ALUOutW, ReadDataW, MemToRegW, ResultW) ; 


assign PCEn = alu_zero & Branch; // goes to pc



endmodule
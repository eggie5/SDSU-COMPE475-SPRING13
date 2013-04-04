`include "alu.v"
`include "dff.v"
`include "decoder.v"
`include "mux21.v"
`include "mux41.v"
`include "memory.v"
`include "reg.v"
`include "sign_ext.v"

module datapath(
input clk, 
input MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite,
input [1:0] ALUSrcB, 
input [2:0] ALUControl,
output [5:0] Opcode, Funct //send to controller
);

parameter addWidth = 6, dataWidth=32;

//pc
wire PCEn;
wire [addWidth-1:0] pc_reg_out;
wire [addWidth-1:0] Adr;

//memory
wire [dataWidth-1:0] mem_out;
wire [dataWidth-1:0] instruction;
wire [dataWidth-1:0] Data;


//decode instrution
wire [5:0] Opcode;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] A3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;

//reg
wire [dataWidth-1:0] RD1;
wire [dataWidth-1:0] RD2;
wire [dataWidth-1:0] A;
wire [dataWidth-1:0] B;
wire [dataWidth-1:0] WD3_mux_out;
wire [dataWidth-1:0] a3_mux_out;

//alu
wire [dataWidth-1:0] srcA_mux_out;
wire [dataWidth-1:0] srcB_mux_out;
wire [dataWidth-1:0] ALUResult;
wire [dataWidth-1:0] ALUOut; // after reg
wire [dataWidth-1:0] alu_mux_out; //handles 6 (addresses) and 32 (data) so must default up to 32 bits
wire alu_zero;

//PC
DFF #(addWidth) pc(clk, PCEn, alu_mux_out, pc_reg_out);
MUX21 #(dataWidth) pc_mux(pc_reg_out, ALUOut, IorD, Adr);

//Mem
Memory #(addWidth, dataWidth) mem (clk, MemWrite, Adr, B, mem_out);
DFF #(dataWidth) dff1 (clk, IRWrite, mem_out, instruction);
Decoder decoder (instruction, Opcode, A1, A2, A3, Immediate, Jump, Funct);
DFF #(dataWidth) dff2 (clk, 1, mem_out, Data); //this is reg after mem, leads to reg file

//Register File
MUX21 #(dataWidth) a3_mux(A2, A3, RegDst, a3_mux_out);
MUX21 #(dataWidth) wd3_mux(ALUOut, Data, MemToReg, WD3_mux_out);
Register #(addWidth, dataWidth) reg_file(clk, RegWrite, A1, A2, a3_mux_out, WD3_mux_out, RD1, RD2);
//encapsuplate these DFF's into the reg module???? and the above muxs too???
DFF #(dataWidth) dff_a (clk, 1, RD1, A);
DFF #(dataWidth) dff_b (clk, 1, RD2, B);

SignExtender sext(Immediate, SignImm);

//ALU
MUX21 #(dataWidth) srcA_mux(pc_reg_out, A, ALUSrcA, srcA_mux_out); // waht is the width on this one? 
MUX41 #(dataWidth) srcB_mux(B, 1, SignImm, SignImm<<2, ALUSrcB, srcB_mux_out) ;
ALU alu(ALUControl, srcA_mux_out, srcB_mux_out, ALUResult, alu_zero);
DFF #(dataWidth) dff_alu_result(clk, 1, ALUResult, ALUOut);
MUX21 #(dataWidth) alu_mux(ALUResult, ALUOut, PCSrc, alu_mux_out);

assign PCEn = ((alu_zero & Branch) | PCWrite); // goes to pc



endmodule
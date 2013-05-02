`include "datapath/alu.v"
`include "datapath/dff.v"
`include "datapath/pcdff.v"
`include "datapath/decoder.v"
`include "datapath/mux21.v"
`include "datapath/mux31.v"
`include "datapath/pcmux.v"
`include "datapath/memory.v"
`include "datapath/imem.v"
`include "datapath/reg.v"
`include "datapath/reg2.v"
`include "datapath/sign_ext.v"
`include "datapath/comparator.v"

module DataPath(
input clk, reset,
input MemToReg, RegDstE, 
input PCSrc, 
input ALUSrcB, MemWrite, RegWriteW, JumpC,
input [2:0] ALUControlE,
input StallF, StallD, FlushE, ForwardAD, ForwardBD,
input [1:0] ForwardAE, ForwardBE,
output [5:0] Opcode, Funct,
output branch_boolean, //send to controller
output [addWidth-2:0] A1, A2, RsE, RtE, 
output [addWidth-1:0] WriteRegE, WriteRegM, WriteRegW
);

parameter addWidth = 6, dataWidth=32;

//pc
wire PCEn;
wire [addWidth-1:0] Adr;
wire [addWidth-1:0] PCF;
wire [addWidth-1:0] pc_mux_out;
wire[addWidth-1:0] jump_mux_out;
wire [addWidth-1:0] PCPlus1F;
wire [addWidth-1:0] PCPlus1D;
wire [addWidth-1:0] PCPlus1E;
wire [addWidth-1:0] PCBranchM;
wire [addWidth-1:0] PCBranchD;
wire [addWidth-1:0] _PCBranchM; //temp var

//memory
wire [dataWidth-1:0] mem_out;
wire [dataWidth-1:0] ReadDataW;
wire [dataWidth-1:0] instruction;
wire [dataWidth-1:0] InstrD;
wire [dataWidth-1:0] Data;
wire [dataWidth-1:0] WriteDataM;


//decode instrution
wire [5:0] Opcode;
//wire [addWidth-2:0] A1;
//wire [addWidth-2:0] A2;
wire [addWidth-2:0] RdE;
wire [addWidth-2:0] RtE;
wire [addWidth-2:0] A3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;

//reg
wire [dataWidth-1:0] RD1;
wire [dataWidth-1:0] RD2;
wire [dataWidth-1:0] compa_mux_out;
wire [dataWidth-1:0] compb_mux_out;
wire [dataWidth-1:0] SrcAE;
wire [dataWidth-1:0] SrcAMux_out;
wire [dataWidth-1:0] src_b_hax_mux_out;
wire [dataWidth-1:0] B;
wire [dataWidth-1:0] ResultW;
/*wire [addWidth-1:0] WriteRegE;
wire [addWidth-1:0] WriteRegM;
wire [addWidth-1:0] WriteRegW;*/


//alu
wire [dataWidth-1:0] ALUResult; // after reg
wire [dataWidth-1:0] ALUOutM; // after reg
wire [dataWidth-1:0] ALUOutW; // after reg
wire [dataWidth-1:0] SrcBE;
wire alu_zero;

//sign extender
wire [dataWidth-1:0] SignImm;
wire [dataWidth-1:0] SignImmE;

//PC -- the width of these should be addWidth
PCDFF #(addWidth) pc_reg (clk, reset, JumpC|PCSrc, StallF, jump_mux_out, PCF);
assign PCPlus1F = PCF + 1;

PCMUX #(addWidth) pc_mux (PCPlus1F, PCBranchD, PCSrc, pc_mux_out);
PCMUX #(dataWidth) jump_mux (pc_mux_out, {PCPlus1F[31:26], Jump}, JumpC, jump_mux_out);

//Mem
IMemory #(addWidth, dataWidth) instruction_mem (PCF, instruction);


//DECODE REGION
DFF #(dataWidth) decode_reg_ins (clk, 0, StallD, instruction, InstrD);
DFF #(addWidth)  decode_reg_pc  (clk, 0, StallD, PCPlus1F, PCPlus1D); // i might need to reset this along w/ PCreg..

//Decoder
Decoder decoder (InstrD, Opcode, A1, A2, A3, Immediate, Jump, Funct);

//Register File
/*Register #(addWidth-1, dataWidth) reg_file (clk, RegWriteW, A1, A2, WriteRegW, ResultW, RD1, RD2);*/
reg_file #(addWidth-1, dataWidth) reg_file (RD1, RD2, A1, A2, WriteRegW, ResultW, clk, RegWriteW); //why -1 on the param? too short?
DFF #(dataWidth) execute_reg_rd1 (clk, FlushE, 1'b1, RD1, SrcAE);
DFF #(dataWidth) execute_reg_rd2 (clk, FlushE, 1'b1, RD2, B);
DFF #(dataWidth) execute_reg_rse (clk, FlushE, 1'b1, A1, RsE);
DFF #(dataWidth) execute_reg_rte (clk, FlushE, 1'b1, A2, RtE);
DFF #(dataWidth) execute_reg_rde (clk, FlushE, 1'b1, A3, RdE);
/*DFF #(dataWidth) execute_reg_PC (clk,  0, 1'b1, PCPlus1D, PCPlus1E);*/

//comparator for control hazards
MUX21 compa_mux (RD1, ALUOutM, ForwardAD, compa_mux_out);
MUX21 compb_mux (RD2, ALUOutM, ForwardBD, compb_mux_out);
wire branch_boolean;
compar #(addWidth-1) comp(compa_mux_out, compb_mux_out, branch_boolean);

//SEX
SignExtender sext(Immediate, SignImm);
DFF #(dataWidth) execute_reg_sex (clk, FlushE, 1'b1, SignImm, SignImmE);
//Branch adder
assign PCBranchD=SignImm + PCPlus1D; //pass this to reg below

//EXECUTE REGION
//ALU
MUX21 #(addWidth-1) a3_mux (RtE, RdE, RegDstE, WriteRegE);

MUX31 #(dataWidth) srca_haz_mux (SrcAE, ResultW, ALUOutM, ForwardAE, SrcAMux_out); //this to ALU A
MUX31 #(dataWidth) srcb_haz_mux (B, ResultW, ALUOutM, ForwardBE, src_b_hax_mux_out); //this to srcB mux
MUX21 #(dataWidth) srcB_mux (src_b_hax_mux_out, SignImmE, ALUSrcB, SrcBE) ;  //this goes to ALU B
ALU alu (ALUControlE, SrcAMux_out, SrcBE, ALUResult, alu_zero);

//MEMWRITE REGION
DFF #(dataWidth) mem_reg_zero (clk, 0, 1'b1, alu_zero, ZeroM);
DFF #(dataWidth) mem_reg_alu (clk, 0, 1'b1, ALUResult, ALUOutM);
DFF #(dataWidth) mem_reg_write_data (clk, 0, 1'b1, B, WriteDataM);
DFF #(dataWidth) mem_reg_write_reg (clk, 0, 1'b1, WriteRegE, WriteRegM);
/*DFF #(addWidth) mem_reg_pc (clk, 0, 1'b1, _PCBranchM, PCBranchM);*/

//memory
Memory #(addWidth, dataWidth) mem (clk, MemWrite, ALUOutM, WriteDataM, mem_out);

//WRITEBACK REGION
DFF #(dataWidth) write_reg_memout (clk, 0, 1'b1, mem_out, ReadDataW);
DFF #(dataWidth) write_reg_aluout (clk, 0, 1'b1, ALUOutM, ALUOutW);
DFF #(dataWidth) write_reg_writeregW (clk, 0, 1'b1, WriteRegM, WriteRegW);

MUX21 #(dataWidth) mem_out_mux (ALUOutW, ReadDataW, MemToReg, ResultW); 




endmodule
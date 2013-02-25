`include "alu.v"
/*`include "controller.v"*/
`include "template.v"
`include "pc.v"
`include "dmem.v"
`include "ins_decode.v"
`include "ism.v"
`include "reg.v"
`include "sign.v"
`include "mux21.v"

module processor();
reg clk;

//pc
parameter PCW=6;
reg pc_clr;
reg pc_mux_sel;
reg [PCW-1:0] pc_branch;
wire [PCW-1:0] pc_out;

wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] alu_out;
wire [31:0] dmem_out;


/*parameter addWidth=32, dataWidth=16;*/
parameter addWidth=6, dataWidth=32;

reg [addWidth-1:0] addr;
wire [dataWidth-1:0] ins;

//controller outputs
wire MemToReg;
wire MemWrite;
wire Branch;
wire [2:0] ALUControl;
wire ALUSrc;
wire RegDest;
wire RegWrite;

//alu input mux
wire [dataWidth-1:0] ALU_SrcB;
wire alu_zero_out;

//lw or sd mux output
wire [31:0] result;

//writeReg mux -- this chooses [20:16] or [15:11] of instruction based on RegDst from controll
wire [4:0] WriteReg;

//sign-extender outputs
wire [31:0] SignImm;

//instruction decoder output
wire [5:0] Opcode;
wire [4:0] R1;
wire [4:0] R2;
wire [4:0] R3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;


ProgramCounter #(PCW) pc (clk, pc_clr, pc_mux_sel, pc_branch, pc_out);
InstructionSet #(addWidth, dataWidth) instruction_set (pc_out, ins); //input: pc, output: instruction

//decode instrution for convience
Instr_Decode decoder (ins, Opcode, R1, R2, R3, Immediate, Jump, Funct);

//takes op and function from instruction
Controller mock_controller (Opcode, Funct, alu_zero_out, MemToReg, MemWrite, PCSrc, ALUSrc, RegDest, RegWrite, Jump, ALUControl); 

MUX21 #(5) who_goes_to_A3_of_reg (R2, R3, RegDest, WriteReg);
RegisterFile register_file (clk, RegWrite, R1, R2, WriteReg, result, RD1, RD2); //A3 comes from mux on above line! RegWrite from controller

SignExtender extenderbender (Immediate, SignImm);
MUX21 alu_src_B_mux (RD2, SignImm, ALUSrc, ALU_SrcB); //decides what input ALU port B gets
ALU myalu(ALUControl, RD1, ALU_SrcB, alu_out, alu_zero_out);


DataMemory #(addWidth, dataWidth) dmem (clk, MemWrite, alu_out, RD2, dmem_out); //MemWrite from controller

MUX21 alu_result_mux (dmem_out, alu_out, MemToReg, result); //0 for lw or sd inst. or 1 for R type ins. like ADD, etc

always #1 clk=~clk;

initial begin
	clk=0;
	pc_clr=0;
	pc_mux_sel=0;
	pc_branch=0;
	$display("time\tCLK\tpc_out\t\tins\t\t\t\tALUSrc\tSrcA\tSrcB\tALUResult\tMemWrite MemToReg Result"); //Left 
	$monitor("%g\t%b\t%d\t%b\t%b%d%d%d\t\t%d\t%d\t%b", $time, clk, pc_out, ins, ALUSrc, RD1, ALU_SrcB, alu_out, MemWrite, MemToReg, result);
	@(posedge clk) pc_clr=1;
	@(posedge clk) pc_clr=0;
	@(posedge clk)
	@(posedge clk)
	@(posedge clk)
	@(posedge clk)
		@(posedge clk)
			@(posedge clk)
	
	$finish;
end


endmodule

//iverilog -o processor processor.v && ./processor

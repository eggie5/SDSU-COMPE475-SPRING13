//this is the top-level module
module processor

reg clk, 
wire [5:0] pc_in; //this should be input from the controller (or TB)
wire [5:0] pc_out;
wire [5:0] pc_next;
wire [31:0] ins; //this is the current instruction for the CPU

reg [31:0] RD1;
reg [31:0] RD2;
reg [31:0] alu_out;
reg [31:0] dmem_out;


parameter addWidth=32, dataWidth=16;

reg clk, we, en;
reg [addWidth-1:0] addr;
reg [dataWidth-1:0] di;
wire [dataWidth-1:0] instruction_addr;

//controller outputs
reg MemToReg,
reg MemWrite,
reg Branch,
reg [2:0] ALUControl,
reg ALUSrc,
reg RegDest,
reg RegWrite

//alu input mux
wire ALU_SrcB;

//lw or sd mux output
wire [31:0] result;

//sign-extender outputs
wire [31:0] SignImm;


ProgramCounter pc (clk, pc_in, pc_out);
InstructionSet #(addWidth, dataWidth) instruction_set (pc_out, di, ins); //input: pc, output: instruction
Controller mock_controller (ins[31:26], ins[5:0], MemToReg, MemWrite, Branch, ALUControl, ALUSrc, RegDest, RegWrite);//takes op and function from instruction
RegisterFile register_file (clk, ins[25:21], ins[20:16], ins[15:11], WD3?, RD1, RD2); //FIX: the A3 input bit width is not constant

SignExtender extenderbender (ins[15:0], SignImm);
MUX21 alu_src_B_mux (RD1, SignImm, ALUSrc, ALU_SrcB); //decides what input ALU port B gets
ALU myalu(ALUControl, RD1, ALU_SrcB, alu_out);

DataMemory #(addWidth, dataWidth) dmem (clk, we, en, alu_out, RD2, dmem_out);

MUX21 alu_result_mux (alu_out, RD2, MemToReg, result); //0 for lw or sd inst. or 1 for R type ins. like ADD, etc

initial begin

end



always #1 clk=~clk;

endmodule

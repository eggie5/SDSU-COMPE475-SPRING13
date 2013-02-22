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

//writeReg mux -- this chooses [20:16] or [15:11] of instruction based on RegDst from controll
wire [4:0] WriteReg;

//sign-extender outputs
wire [31:0] SignImm;

//instruction decoder output
reg [5:0] Opcode;
reg [4:0] R1;
reg [4:0] R2;
reg [4:0] R3;
reg [15:0] Immediate;
reg [25:0] Jump;
reg [5:0] Funct;



ProgramCounter pc (clk, pc_in, pc_out);
InstructionSet #(addWidth, dataWidth) instruction_set (pc_out, di, ins); //input: pc, output: instruction

//decode instrution for convience
Instr_Decode decoder (ins, Opcode, R1, R2, R3, Immediate, Jump, Funct);

Controller mock_controller (Opcode, Funct, MemToReg, MemWrite, Branch, ALUControl, ALUSrc, RegDest, RegWrite);//takes op and function from instruction

MUX21 who_goes_to_A3_of_reg (R2, R3, RegDest, WriteReg);
RegisterFile register_file (clk, R1, R2, WriteReg, RegWrite, RD1, RD2); //A3 comes from mux on above line! RegWrite from controller

SignExtender extenderbender (Immediate, SignImm);
MUX21 alu_src_B_mux (RD2, SignImm, ALUSrc, ALU_SrcB); //decides what input ALU port B gets
ALU myalu(ALUControl, RD1, ALU_SrcB, alu_out);

DataMemory #(addWidth, dataWidth) dmem (clk, MemWrite, en, alu_out, RD2, dmem_out); //MemWrite from controller

MUX21 alu_result_mux (alu_out, dmem_out, MemToReg, result); //0 for lw or sd inst. or 1 for R type ins. like ADD, etc

initial begin

end



always #1 clk=~clk;

endmodule

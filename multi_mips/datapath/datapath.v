module datapath(
input clk, 
input MemToReg, RegDst, IorD, PCSrc, PCEn, ALUSrcA, [1:0] ALUSrcB, IRWrite, MemWrite, PCWrite, Branch, RegWrite,
input [2:0] ALUControl,
output [5:0] Opcode, Funct //send to controller
);

parameter addWidth = 6, dataWidth=32;

//pc
reg pc_clr;
wire [PCW-1:0] pc_out;

//memory
reg [dataWidth-1:0] mem_out;
reg [dataWidth-1:0] instruction;


//decode instrution
wire [5:0] Opcode;
wire [4:0] R1;
wire [4:0] R2;
wire [4:0] R3;
wire [15:0] Immediate;
wire [25:0] Jump;
wire [5:0] Funct;



PC #(addWidth) pc(clk, pc_clr, PCEn, pc_out);
Memory #(addWidth, dataWidth) mem (clk, MemWrite?, pc_out, mem_out);
DFF #(dataWidth) dff1 (clk, IRWrite, mem_out, instruction);

Instr_Decode decoder (instruction, Opcode, R1, R2, R3, Immediate, Jump, Funct);
Register reg(clk, RegWrite, R1, R2, R3,....muxes...);



ALU alu();
SignExtend sext();

endmodule
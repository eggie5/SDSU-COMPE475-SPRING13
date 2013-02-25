module Controller
(input [5:0] op,
input [5:0] func,
output MemToReg,
output MemWrite,
output Branch,
output [2:0] ALUControl,
output ALUSrc,
output RegDest,
output RegWrite
);

	//hardcode some test values
	assign ALUControl = 3'b010; //' //for lw instruction
	assign ALUSrc = 1; // get ALU soure B from sign extender
	assign MemToReg = 0; //skip data mem, i.e. this is lw or sw OP
	assign MemWrite = 0;//this is a lw instruction
	
	//TODO: add the PCSource and logic here


endmodule
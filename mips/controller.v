module Controller
(input [6:0] op, //or 5:0 ??
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


endmodule
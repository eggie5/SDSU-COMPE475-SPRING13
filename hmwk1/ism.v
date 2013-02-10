//I am the instruction memory
//a typical memory module that will
//be bootstraped from a dtatfile with
//actual instructions at runtime

// The instruction register is a special-purpose register that holds the instruction code 
// while it's being decoded and executed.



//Synchronous RAM, always read, read-first mode

//module ramRF


module InstructionSet
#(parameter addWidth=6, dataWidth=16)
(input clk, we, en,
input [addWidth-1:0] addr_in, //this is address from PC
input [dataWidth-1:0] di,
output reg [dataWidth-1:0] out_instruction); //instruction


//this should be a 16 (column) x 64 (row) memory array 1024 B = 1 KB
//0000000000000001
//0000000000000001
//64
//0000000000000001

reg [dataWidth-1:0] instructions [2**addWidth-1:0]; //this is the actual program instructions

always@(posedge clk) begin
	if(en) begin
		if(we) instructions[addr_in] <= di; //this should select a row and write di to it
		
		out_instruction <= instructions[addr_in]; // do doesn't get new din in this clock cycle
	end
end

endmodule

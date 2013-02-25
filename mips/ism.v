//I am the instruction memory
//a typical memory module that will
//be bootstraped from a dtatfile with
//actual instructions at runtime

// The instruction register is a special-purpose register that holds the instruction code 
// while it's being decoded and executed.

module InstructionSet
#(parameter addWidth=6, dataWidth=32)
(input [addWidth-1:0] addr_in, //this is address from PC
 output [dataWidth-1:0] out_instruction
); 

//add test program to instuction memory
//this would be done by compiler tool chain (loader)
initial $readmemb("sw_program", instructions);


//this should be a 32 (column) x 64 (row) memory array 1024 B = 1 KB
//0000000000000000000000000000001
//0000000000000000000000000000001
//64
//0000000000000000000000000000001

	reg [dataWidth-1:0] instructions [2**addWidth-1:0]; //this is the actual program instructions

	assign out_instruction = instructions[addr_in]; //async read


endmodule

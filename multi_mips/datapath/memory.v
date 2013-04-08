module Memory
#(parameter addWidth=6, dataWidth=32)
(
input clk, we,
input [addWidth-1:0] addr, //address for read/write operation
input [dataWidth-1:0] in, //input data
output [dataWidth-1:0] out //output insturction or generic data
); 

//add test program to instuction memory
//this would be done by compiler tool chain (loader)
`ifdef PROGRAM_1
	initial $readmemb("sw_program", RAM);
`endif
`ifdef HMWK5
	initial begin
	$display("loading program for HMWK 5");
	$readmemb("datapath/memfile.dat", RAM);
	end
`endif



//this should be a 32 (column) x 64 (row) memory array 1024 B = 1 KB
//0000000000000000000000000000001
//0000000000000000000000000000001
//64
//0000000000000000000000000000001

	reg [dataWidth-1:0] RAM [2**addWidth-1:0]; //this is the actual program instructions

	assign out = RAM[addr]; //async read

	always@(posedge clk) begin
		if(we) RAM[addr] <= in; //this should select a row and write di to it
	end


endmodule

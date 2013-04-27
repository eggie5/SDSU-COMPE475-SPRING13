module Register
#(parameter addWidth=5, dataWidth=32)
(
input clk, 
input we3, //from controller
input [addWidth-1:0] A1,
input [addWidth-1:0] A2,
input [addWidth-1:0] A3,
input [dataWidth-1:0] WD3,
output [dataWidth-1:0] RD1,
output [dataWidth-1:0] RD2
);

// THIS HAS TO BE WRITE FIRST
//people are having trouble w/ this

reg [dataWidth-1:0] registers [2**addWidth-1:0];

initial $readmemb("datapath/reg.mem", registers);


		//these the 2 instructions operands, i.e. A & B in C=A+B
		//THERE ARE ERRORS HERE -- 
		//OR USE IF STATEMENTS LIKE BEARD GUY
		//write first on postedge -- actually he just said no neg edge
		//write first / read next and read combinationally
		//3 diff ways of doing write first in 470 lectures
		//report due on the 8th of may
		//
/*		assign RD1 = registers[A1]; //A
		assign RD2 = registers[A2]; //B

	// synchronous writes; handles $zero register
	always @(posedge clk) begin
		if(we3)
			registers[A3] <= WD3;
	end
*/
//new

assign RD1 = ((A1==A3) ? WD3 : registers[A1]);
assign RD2 = ((A2==A3) ? WD3 : registers[A2]); 


always @(posedge clk) begin
	if(we3) registers[A3] <= WD3; //actual write
end



endmodule
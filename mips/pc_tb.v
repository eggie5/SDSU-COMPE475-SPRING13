`include "pc.v"

module ProgramCounter_tb();
parameter W=32;
reg clk;
reg clr;
reg mux_sel;
reg [W-1:0] branch;
wire [W-1:0] out;

ProgramCounter #(W) pc (clk, clr, mux_sel, branch, out);

initial begin 
	
	$display("time\tCLK\tclr\t mux_sel\t branch\t out");
	$monitor("%g\t%b\t%d\t%b\t%b\t%b", $time, clk, clr, mux_sel, branch, out);
	
	clk=0; //initialze clock
	clr=0; //initial reset
	mux_sel=0;
	branch=0;
	
	@(posedge clk) clr=1; //clear pc
	@(posedge clk) clr=0; //unclear
	@(posedge clk)
	@(posedge clk)
	@(posedge clk)
	@(posedge clk) mux_sel=1; branch=127;
	@(posedge clk) 
	
	$finish; 
end

always #1 clk=~clk;

endmodule
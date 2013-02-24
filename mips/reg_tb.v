`include "reg.v"

module RegisterFile_tb();

parameter addWidth=32, dataWidth=5;
reg clk; 
reg we3; //from controller
reg [4:0] A1;
reg [4:0] A2;
reg [4:0] A3; //this comes from 21mux of R2 and R3 of instruction
reg [31:0] WD3;
wire [31:0] RD1;
wire [31:0] RD2;

RegisterFile #(addWidth, dataWidth) register (clk, we3, A1, A2, A3, WD3, RD1, RD2);

integer index;

initial begin
	//initial values
	clk=0;
	we3=0;
	A1=0;
	A2=0;
	A3=0;
	WD3=0;
	
	$display("time\tCLK\twe3\tA1\tA2\tA3\tWD3\tRD1\tRD2");
	$monitor("%g\t%b\t%d\t%d\t%d\t%d", $time, clk, we3, A1, A2, A3, WD3, RD1, RD2);
	//read the first and last element
	@(posedge clk) A1=5'b00000; A2=5'b11111;
	//Add $s3 and $s8 to $s25
	//$s3==3
	//$s8==8
	//$s25 should == 11
	@(posedge clk) A1=3; A2=8; A3=25; we3=1; WD3=11;//we3 is the output form the ALU
	@(posedge clk) A1=25; //now 25 should have 11 in it!
	@(posedge clk)
	@(posedge clk)
	@(posedge clk) 
	@(posedge clk)
		
	//how can I do a memory dump to verify to TA??

	$finish;
end

always #1 clk=~clk;

endmodule
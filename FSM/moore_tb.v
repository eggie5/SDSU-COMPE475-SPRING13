`include "moore.v"
module mooreFSM_tb();
reg clk;
reg RESET;
reg din;
wire pe;

mooreFSM moore (clk, RESET, din, pe);

initial begin
	//initialize values
	clk=0;
	din=0;
	
	@(posedge clk) RESET=1;
	@(posedge clk) RESET=0; din=0;
	@(posedge clk) din=1; // should turn high
	@(posedge clk) din=0; 
	@(posedge clk) din=1; //posedge!
	@(posedge clk) din=1; //not high but state 1
	@(posedge clk)
	@(posedge clk)
	
	$finish;

end

always #1 clk=~clk;


initial begin
    $dumpfile("moore_dump.vcd");
    $dumpvars(0,mooreFSM_tb);
end

endmodule
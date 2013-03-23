`include "moore.v"
module FSM_tb();
reg clk;
reg RESET;
reg din;
wire pe;

FSM moore (clk, RESET, din, pe);

initial begin
	//initialize values
	clk=0;
	din=0;
	
	@(posedge clk) RESET=1;
	@(posedge clk) RESET=0; din=0;
	@(posedge clk) din=0;
	@(posedge clk) din=1;
	@(posedge clk) din=0;
	@(posedge clk) din=1; //posedge!
	@(posedge clk)
	@(posedge clk)
	
	$finish;

end

always #1 clk=~clk;


initial begin
    $dumpfile("moore_dump.vcd");
    $dumpvars(0,FSM_tb);
end

endmodule
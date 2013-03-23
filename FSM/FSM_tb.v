`include "moore.v"
`include "mealy.v"
module FSM_tb();
reg clk;
reg RESET;
reg din;
wire moore_out;
wire mealy_out;

mooreFSM moore (clk, RESET, din, moore_out);
mealy_FSM mealy (clk, RESET, din, mealy_out);

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
    $dumpfile("FSM_dump.vcd");
    $dumpvars(0,FSM_tb);
end

endmodule
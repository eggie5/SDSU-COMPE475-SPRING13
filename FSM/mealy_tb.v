`include "mealy.v"
module mealyFSM_tb();
reg clk;
reg RESET;
reg din;
wire pe;

mealy_FSM mealy (clk, RESET, din, pe);

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
    $dumpfile("mealy_dump.vcd");
    $dumpvars(0,mealyFSM_tb);
end

endmodule
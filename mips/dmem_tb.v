`include "dmem.v"
module DataMemory_tb();
parameter addWidth=6, dataWidth=32;
reg clk; 
reg we;
reg [dataWidth-1:0] addr;
reg [dataWidth-1:0] di;
wire [dataWidth-1:0] _do;

DataMemory #(addWidth, dataWidth) mem (clk, we, addr, di, _do);

always #1 clk=~clk;

initial begin
	clk=0;
	we=0;
	addr=0;
	di=0;
	
	$display("time\tCLK\twe3\taddr\t\t\t\t\tdi\t\t\t\t\t_do");
	$monitor("%g\t%b\t%b\t%b\t%b\t%b", $time, clk, we, addr, di, _do);
	#1; addr=0; //should be -31
	#1; addr=31; //should be 0
	#1; addr=62; //should be 31
	$finish;
end

endmodule

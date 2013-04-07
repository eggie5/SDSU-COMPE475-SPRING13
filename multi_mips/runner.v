`include "processor.v"
module runner();
reg clk;
reg reset;

integer fp;
integer i;

always #1 clk=~clk;

Processor processor(clk, reset);

initial begin

	//set any initial values
	clk=0;

	@(posedge clk) reset=1;
	@(posedge clk) reset=0;
	@(posedge clk);
	@(posedge clk);
	
	

	fp = $fopen("tmp/mem_after.dump"); 
	for (i = 0; i <= 63; i = i + 1) 
		$fdisplayb(fp, processor.dp.mem.RAM[i]); 
	$fclose(fp);
	
	$finish;
end

//waveform in gtkplot
initial begin
    $dumpfile("tmp/processor.vcd");
    $dumpvars(0, processor);
end



endmodule

//iverilog -o tmp/multi_mips -DHMWK5 runner.v && ./tmp/multi_mips
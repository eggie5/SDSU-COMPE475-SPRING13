`include "processor.v"

module processor_rb();

reg clk;

processor mips_processor (clk);

initial begin
	clk=0;
	
	$finish;
end

always #1 clk=~clk;

endmodule
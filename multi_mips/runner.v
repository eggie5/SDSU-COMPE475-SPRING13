module runner();

always #10 clk=~clk;

Processor processor(clk);

initial begin

	//set any initial values
	clk=0;

	@(posedge clk) 
	@(posedge clk) 
	@(posedge clk)
	@(posedge clk)

end

//waveform in gtkplot
initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0,processor);
end

endmodule


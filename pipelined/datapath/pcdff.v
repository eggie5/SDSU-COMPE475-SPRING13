module PCDFF #(parameter W = 32)
(input clk,
 input reset,
 input jumps, 
 input stall,
 input [W-1:0] d,
 output reg [W-1:0] q
);

always @(posedge clk or jumps) begin
	$display("time=%g, q=%d, jumps=%b",$time, q, jumps);
end

always @(jumps) begin
	if(jumps===1'b1) begin
		$display("JUMP %g", $time);
	 	q = 32'bx;
	end
end


always @(posedge clk) begin
	if(reset) q <= 0;
	else if(~stall|| stall===1'bx) q <= d;
	

end

endmodule
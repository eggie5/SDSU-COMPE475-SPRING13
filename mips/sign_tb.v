`include "sign.v"

module sign_tb;
reg [15:0] in;
wire [31:0] out;

sign myext (in, out);

initial begin
	$display("time\tin\t\t\t\out");
	$monitor("%g\t%b\t %b", $time, in, out);

	#1 in=16'b1000000000000000;
	#1 in=16'b1000000000000001;
	#1 in=16'b1000000000000011;
end

endmodule
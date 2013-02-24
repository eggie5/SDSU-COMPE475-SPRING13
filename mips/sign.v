module SignExtender #(parameter n = 16)
(input [15:0] in,
output [31:0] extended);


	// assign extended = $signed(in);

	
	assign extended = {{(n){in[n-1]}}, in};
	
	// or this?
	// assign out[15:0] = in[15:0];
	// assign out[31:16] = in[15];
endmodule
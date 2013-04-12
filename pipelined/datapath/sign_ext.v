module SignExtender #(parameter n = 16)
(input [n-1:0] in, //15:0
output [(n*2)-1:0] extended); //31:0
	assign extended = {{(n){in[n-1]}}, in};
endmodule
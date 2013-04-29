module compar #(parameter W = 32)
(input [W-1:0]  a, 
 input [W-1:0] b, 
 output cmp);

   assign cmp = (a == b) ?  1'b1 : 1'b0;

endmodule

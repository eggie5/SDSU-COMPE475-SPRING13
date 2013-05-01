module reg_file
#(parameter addWidth=5, dataWidth=32)
(
	output reg[dataWidth-1:0] RD1, RD2, 
	 input [addWidth-1:0] A1, A2, A3, 
	input [dataWidth-1:0] WD3, 
	clk, WE3);
   
 


reg [dataWidth-1:0] registers [2**addWidth-1:0];

initial $readmemb("datapath/reg.mem", registers);

/*   assign data_out_1 = addr_1 && addr_1 == addr_3 ? data_in_3 : registers[addr_1];
   assign data_out_2 = addr_2 && addr_2 == addr_3 ? data_in_3 : registers[addr_2];

   always @( posedge clk ) if( we3 ) registers[addr_3] <= data_in_3;*/

always @(*) begin
 if (A1 == A3 && WE3)
  RD1 <= WD3;//bypass new value to RD1
 else
  RD1 <= registers[A1];
 if (A2 == A3 && WE3)//bypass new value to RD2
  RD2 <= WD3;
 else
  RD2 <= registers[A2];
 end

 always@(posedge clk)begin
 if(WE3)
 registers[A3]<=WD3;//write to register file
 end

endmodule


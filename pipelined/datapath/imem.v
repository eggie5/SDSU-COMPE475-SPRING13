module IMemory
#(parameter addWidth=6, dataWidth=32)
(
input [addWidth-1:0] addr, //address for read/write operation
output [dataWidth-1:0] out //output insturction or generic data
); 


//add test program to instuction memory
//this would be done by compiler tool chain (loader)
	`ifdef pipelined_program
		initial $readmemh("datapath/pipelined_program", RAM);
	`endif
	`ifdef dp_test_program
		initial $readmemb("datapath/dp_test_program", RAM);
	`endif
	`ifdef test1
		initial $readmemh("programs/test1", RAM);
	`endif
	`ifdef mytest
		initial $readmemb("programs/mytest", RAM);
	`endif
	`ifdef w
		initial $readmemh("programs/w", RAM);
	`endif
	`ifdef haz_program
		initial $readmemb("programs/haz_program", RAM);
	`endif
	`ifdef lw_fwd_test
		initial $readmemb("programs/lw_fwd_test", RAM);
	`endif
	`ifdef hmwk6
		initial $readmemh("programs/hmwk6", RAM);
	`endif

	reg [dataWidth-1:0] RAM [2**addWidth-1:0]; //this is the actual program instructions

	assign out = RAM[addr]; //async read
	

endmodule

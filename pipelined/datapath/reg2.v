module reg_file
#(parameter addWidth=5, dataWidth=32)
(data_out_1, data_out_2, addr_1, addr_2,
                addr_3, data_in_3, clk, we3);
   input [addWidth-1:0] addr_1, addr_2, addr_3;
   input [dataWidth-1:0] data_in_3;
   input        clk;
input we3;
   output [dataWidth-1:0] data_out_1, data_out_2;


reg [dataWidth-1:0] registers [2**addWidth-1:0];

initial $readmemb("datapath/reg.mem", registers);

   assign data_out_1 = addr_1 && addr_1 == addr_3 ? data_in_3 : registers[addr_1];
   assign data_out_2 = addr_2 && addr_2 == addr_3 ? data_in_3 : registers[addr_2];

   always @( posedge clk ) if( we3 ) registers[addr_3] <= data_in_3;



endmodule
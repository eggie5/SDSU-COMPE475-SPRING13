//this is the top-level module
module processor
(input clk, input [5:0] pc_in); //this should be input from the controller (or TB)

wire [5:0] pc_out;
wire [5:0] pc_next;
wire [3:0] alu_sel;//from controller or regsiter file...?
reg [31:0] RD1;
reg [31:0] RD2;
reg [31:0] alu_out;


parameter addWidth=6, dataWidth=16;

reg clk, we, en;
reg [addWidth-1:0] addr;
reg [dataWidth-1:0] di;
wire [dataWidth-1:0] instruction_addr;


ProgramCounter pc (clk, pc_in, pc_out);
ism #(addWidth, dataWidth) instruction_set (clk, we, en, pc_out, di, instruction); //writing dosn't make sense for this
reg register_file (clk, ins[25:21], ins[20:16], ins[15:11], WD3?, RD1, RD2); //FIX: the A3 input bit width is not constant
sign sign_ext (clk);
alu myalu(alu_sel, RD1, RD2, alu_out);

// initial begin
// 	clk=0;
// 	we=1;	
// 	en=1;
// 	di=0;
// 	addr=0;
// 	
// 	$display("time\t clk\t we\t en\t addr\t    di\t do");
// 	$monitor("%g\t %d\t %d\t %d\t %d\t %d\t %b", $time, clk, we, en, addr, di, _do);
// 	
// 	@(posedge clk) di=0; we=1;
// end


always #1 clk=~clk;

endmodule

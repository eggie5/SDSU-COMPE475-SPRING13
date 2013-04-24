`include "datapath/dff.v"
`include "controller/controller.v"

module Controller_tb();

 reg clk;
 reg [5:0] op, funct;
 reg zero;
 wire MemToReg;
 wire MemWriteM, PCSrcM, ALUSrcE, RegDstE, RegWrite, jump;
 wire [2:0] ALUControlE;

 Controller controller (clk, op, funct, zero, MemToReg, MemWriteM, PCSrcM, ALUSrcE, RegDstE, RegWrite, jump, ALUControlE);

  initial begin
	clk=0;
	op=6'b100011; //lw
	funct=0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	$finish;
  end

initial begin
    $dumpfile("tmp/controller_tb.vcd");
    $dumpvars(0,Controller_tb);
 end

always #10 clk=~clk;
endmodule



//run from project root
//iverilog -o tmp/controller_tb controller/controller_tb.v && ./tmp/controller_tb
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
	zero=0;
	funct=0;
	
	@(posedge clk);	op=6'b100011; //lw
	@(posedge clk);	op=6'b101011; //sw
	@(posedge clk); op=6'b000000; funct=6'b100000; //rtype
	@(posedge clk);	op=6'b000100; zero=1;//beq
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
`include "template.v"
module Controller_tb();

 reg [5:0] op, funct;
 reg zero;
 wire memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump;
 wire [2:0] alucontrol;

  Controller cont (op, funct, zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
  
	initial begin
		op=0;
		funct=0;
		$display("time\topcode\tfunction\tzero\tmemtoreg\tmemwrite\tpcsrc\talusrc\tregdst\tregwrite jump\talucontrol"); 
		$monitor("%g\t%b\t%b\t\t%b\t%b\t\t%d\t\t%d\t%d\t%d\t%d\t%d\t%b", $time, op, funct, zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
		
		#1; op=5'b10001; funct= 6'b100000;
		#1; op=5'b10001; funct= 6'b100000;
		#1; op=5'b10011; funct= 6'b100000;


	
		$finish;
	
	end


endmodule



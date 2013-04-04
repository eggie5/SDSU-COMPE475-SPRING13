module Controller
(input clk, reset,
input [5:0] Opcode, Funct,
input zero,
output reg MemToReg, RegDst, IorD, PCSrc, ALUSrcA, ALUSrcB, IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl
);

//??? in pdf
reg [1:0] ALUOp;

//CONSTANTS
parameter LW=6'b100011;
parameter SW=6'b101011;

//state declartion
reg [2:0] state_reg, next_state; //2 bits for 3 states  - not one-hot encoding

parameter S0=0; //fetch/reset
parameter S1=1; //decode
parameter S2=2; //MemAdr
parameter S3=3; //MemRead
parameter S4=4; //MemWriteBack


always @(posedge clk or posedge reset) begin
	if(reset) state_reg <= S0;
	else state_reg <= next_state;
end

always @(state_reg) begin
	case(state_reg)
		S0:
			next_state = S1;
		S1: begin
			if (Opcode == LW) next_state = S2; //next
			else if(Opcode == SW) next_state = S2; //next
			else next_state=S1; //loopback...?
			end
		S2: begin
			if(Opcode == LW) next_state = S3; //next
			else next_state = S2; //loopback
			end
		S3:
			next_state = S4;
		S4:
			next_state = S0; //reset
	endcase
end

always @(state_reg) begin
	case(state_reg)
		S0: begin//fetch
			IorD = 0;
			ALUSrcA=0;
			ALUSrcB=2'b01;
			ALUOp=2'b00;
			PCSrc=0;
			IRWrite=1;
			PCWrite=1;
			end
		S1: begin //decode
			IorD = 1'bx;
			ALUSrcA=1'bx;
			ALUSrcB=2'bxx;
			ALUOp=2'b00;
			PCSrc=1'bx;
			IRWrite=0;
			PCWrite=0; 
			Branch=0;
			end
		S2: begin //MemAdr
			ALUSrcA=1;
			ALUSrcB=2'b10;
			ALUOp=2'b00;
			RegWrite=0;
			MemWrite=0;
			end
		S3: begin //MemRead
			IorD=1;
			end
		S4: begin //Mem WriteBack
			RegDst=0;
			MemToReg=1;
			RegWrite=1;
			end
	endcase
end

endmodule
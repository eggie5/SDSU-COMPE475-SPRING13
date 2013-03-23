module mealy_FSM
(input clk, input RESET, input din, output pe);

//state declartion
reg  state_reg, next_state; 

parameter zero=0;
parameter one=1;

always @(posedge clk or posedge RESET) begin
	if(RESET) state_reg <= zero;
	else state_reg <= next_state;
end

always @(state_reg or din) begin
	case(state_reg)
		zero:
			if(din==0) //stay in 0 state -- loopback
				next_state = zero;
			else if(din==1) //transition to edge state
				next_state = one;
			else next_state = zero; //default
		one:
			if(din==0) next_state=zero;
			else if(din==1) next_state = one; //loopback
			else  next_state=one; //default
		default:
			$display("invalid state error case default fall-through, state:%d", state_reg);
	endcase
end

//this is mealy b/c it's outputing w/ respect to input -- more is w/ respect to state only
assign pe = (state_reg == zero && din==1) ? 1 : 0 ;

endmodule


//iverilog -o fsm moore.v

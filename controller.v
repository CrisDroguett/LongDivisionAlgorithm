// Cris Droguett Noah Fishman
// Final Project
// EECE 573
// Controller

module controller
(
	input start, reset, clk,

	input divisor_is_zero, divisor_msb, cnt_is_zero, dvsr_less_than_dvnd,
	
	output done, error,
	
	output init, left, right, sub
	
);

reg out_init;
reg out_left;
reg out_right;
reg out_sub;
reg out_error;
reg out_done;

`define SWIDTH 3

parameter [`SWIDTH-1:0]
	ST_WAIT_FOR_START = `SWIDTH'd0,
	ST_CHECK_DIVIDE_BY_0 = `SWIDTH'd1,
	ST_ERROR = `SWIDTH'd2,
	ST_SHIFT_LEFT = `SWIDTH'd3,
	ST_SHIFT_RIGHT = `SWIDTH'd4,
	ST_NO_ERROR = `SWIDTH'd5;

reg [`SWIDTH-1:0] state, next_state; // Create our current and next state registers

//state register
always @(posedge clk) begin
	if(reset)
		state <= ST_WAIT_FOR_START;
	else
		state <= next_state; //Otherwise go to the next state 
end

//next state logic
always @(*)
begin
	out_init = 1'b0;
	out_left = 1'b0;
	out_right = 1'b0;
	out_sub = 1'b0;
	out_done = 1'b0;
	out_error = 1'b0;

	case(state)
	ST_WAIT_FOR_START:
	begin
		if(start)
		begin
			next_state <= ST_CHECK_DIVIDE_BY_0;
			out_init  <= 1;
		end
		else 
			next_state <= ST_WAIT_FOR_START;
	end
	ST_CHECK_DIVIDE_BY_0:
	begin
		if(divisor_is_zero)
			next_state <= ST_ERROR;
		else
			next_state <= ST_SHIFT_LEFT;
	end
	ST_ERROR:
	begin
		out_done <= 1;
		out_error <= 1;
		next_state <= ST_WAIT_FOR_START;

	end
	ST_SHIFT_LEFT:
	begin
		if(divisor_msb)
			next_state <= ST_SHIFT_RIGHT;
		else
		begin
			next_state <= ST_SHIFT_LEFT;
			out_left <= 1;
		end
			
	end
	ST_SHIFT_RIGHT:
	begin
		if(cnt_is_zero)
		begin
			next_state <= ST_NO_ERROR;
			out_right <= 0;
		end
		else 
		begin
			if ((dvsr_less_than_dvnd))
				out_sub	<= 1;
			out_right <= 1;
			next_state <= ST_SHIFT_RIGHT;
		end
	
	end
	ST_NO_ERROR:	
	begin
		out_error <= 0;
		out_done <= 1;
		next_state <= ST_WAIT_FOR_START;

	end
	default:
		next_state = {`SWIDTH{1'bx}};
	endcase

end

//output logic
	assign init = out_init;
	assign left = out_left;
	assign right = out_right;
	assign sub = out_sub;
	assign error = out_error;
	assign done = out_done;

endmodule
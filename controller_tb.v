// Controller Test Bench
// Noah Fishman, Cris Droguett
// EECE 573

module controller_tb();

reg clk, reset_iv, start_iv, divisor_is_zero_iv, divisor_msb_iv, cnt_is_zero_iv, dvsr_less_than_dvnd_iv; 
wire error_ov, done_ov, left_ov, right_ov, init_ov, sub_ov;

controller DUT (
	.done(done_ov),
	.error(error_ov),
	.init(init_ov),
	.left(left_ov),
	.right(right_ov),
	.sub(sub_ov),
	.start(start_iv),
	.reset(reset_iv),
	.clk(clk),
	.divisor_is_zero(divisor_is_zero_iv),
	.divisor_msb(divisor_msb_iv),
	.cnt_is_zero(cnt_is_zero_iv),
	.dvsr_less_than_dvnd(dvsr_less_than_dvnd_iv)
);

initial begin
	clk=1'b0;
	forever 
	#10 clk=~clk;
end

initial begin:main_testbench
	// Initialize
	@(posedge clk) #5;
	clk = 0;
	reset_iv = 1;
	start_iv = 0;
	divisor_is_zero_iv = 0;
	divisor_msb_iv = 0;
	cnt_is_zero_iv = 0;
	dvsr_less_than_dvnd_iv = 0;
	

	#1 $display("state | start | divisor_is_0 | divisor_msb | cnt_is_0 | dvsr_<_dvnd |-| next_state | error | done | left | right | init | sub");

	// WAIT_FOR_START -> WAIT_FOR_START
	@(posedge clk) #5;
	reset_iv = 0;
	start_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// WAIT_FOR_START -> CHECK_DIVIDE_BY_ZERO
	@(posedge clk) #5;
	start_iv = 1;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	divisor_is_zero_iv = 1;
	@(posedge clk) #5;
	start_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// CHECK_DIVIDE_BY_ZERO -> ERROR
	@(posedge clk) #5;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// ERROR -> WAIT_FOR_START
	@(posedge clk) #5;
	start_iv = 1;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// WAIT_FOR_START -> CHECK_DIVIDE_BY_ZERO -> SHIFT_LEFT
	@(posedge clk) #5;
	start_iv = 0;
	divisor_is_zero_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);
	@(posedge clk) #5;
	divisor_msb_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// SHIFT_LEFT -> SHIFT_RIGHT
	@(posedge clk) #5;
	divisor_msb_iv = 1;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// SHIFT_RIGHT: Right
	@(posedge clk) #5;
	divisor_msb_iv = 0;
	cnt_is_zero_iv = 0;
	dvsr_less_than_dvnd_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// SHIFT_RIGHT: Right, Sub
	@(posedge clk) #5;
	cnt_is_zero_iv = 0;
	dvsr_less_than_dvnd_iv = 1;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// SHIFT_RIGHT -> NO_ERROR
	@(posedge clk) #5;
	cnt_is_zero_iv = 1;
	//@(posedge clk) #5;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	@(posedge clk) #5;
	cnt_is_zero_iv = 0;
	dvsr_less_than_dvnd_iv = 0;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	// NO_ERROR -> WAIT_FOR_START
	@(posedge clk) #5;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	start_iv = 1;
	@(posedge clk) #5;
	#1 $display("%b",DUT.state,,,,,,,,start_iv,,,,,,,,,,,,divisor_is_zero_iv,,,,,,,,,,,,,,divisor_msb_iv,,,,,,,,,,,,,cnt_is_zero_iv,,,,,,,,,,,,dvsr_less_than_dvnd_iv,,,,,,,,,,,,,,,"%b",DUT.next_state,,,,,,,,,error_ov,,,,,,,,done_ov,,,,,,left_ov,,,,,,,,right_ov,,,,,,,,init_ov,,,,,,sub_ov);

	$finish();

end

endmodule

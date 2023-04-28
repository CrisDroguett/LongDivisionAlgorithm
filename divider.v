//Fall 2022 Digital System Design II - Final Project 
//32 - bit Divider - Pen and Paper Long Division Algorithm

// Noah Fishman, Cris Droguett
// EECE 573

module divider #(parameter size=32)
(
	input [size-1:0] dividend, 
	input [size-1:0] divisor,
	input clk, reset, start,
	output [size-1:0] quotient, 
	output [size-1:0] remainder, 
	output error, 
	output done
);

wire divisor_is_zero, divisor_msb, cnt_is_zero, dvsr_less_than_dvnd, init, left, right, sub;

controller Controller (
	.start(start),
	.reset(reset),
	.clk(clk),
	.divisor_is_zero(divisor_is_zero),
	.divisor_msb(divisor_msb),
	.cnt_is_zero(cnt_is_zero),
	.dvsr_less_than_dvnd(dvsr_less_than_dvnd),
	.init(init),
	.left(left),
	.right(right),
	.sub(sub),
	.done(done),
	.error(error)
);

datapath Datapath (
	.reset(reset),
	.clk(clk),
	.divisor_is_zero(divisor_is_zero),
	.divisor_msb(divisor_msb),
	.cnt_is_zero(cnt_is_zero),
	.dvsr_less_than_dvnd(dvsr_less_than_dvnd),
	.init(init),
	.left(left),
	.right(right),
	.sub(sub),
	.divisor(divisor),
	.dividend(dividend),
	.quotient(quotient),
	.remainder(remainder)
);

endmodule
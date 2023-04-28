// Cris Droguett Noah Fishman
// Final Project
// EECE 573
// Datapath

module datapath #(parameter size = 32)
(
	input init, left, right, sub, reset, clk,
	input [size-1:0] divisor,
	input [size-1:0] dividend,
	output [size-1:0] quotient,
	output [size-1:0] remainder,
	output cnt_is_zero, divisor_msb, divisor_is_zero, dvsr_less_than_dvnd
);

reg [$clog2(size):0] cnt;
wire out_divisor_msb;
reg [size-1:0] out_divisor;
reg [size-1:0] out_dividend;
reg [size-1:0] out_quotient;
reg [size-1:0] out_remainder;

assign cnt_is_zero = (cnt==0)?1:0;
assign divisor_is_zero = (out_divisor==0)?1:0;
assign divisor_msb = out_divisor[31];
assign dvsr_less_than_dvnd = (out_divisor<out_dividend)?1:0;
assign quotient = out_quotient;
assign remainder = out_dividend;

always @(posedge clk) //Divisor Shift Block
begin
	if(init) //LD
		out_divisor <= divisor;
	else if(left)
		out_divisor <= out_divisor << 1;
	else if(right)
		out_divisor <= out_divisor >> 1;
end

always @(posedge clk) //Remainder Block
begin
	if(init) //LD
		out_dividend <= dividend;
	else if(sub)
		out_dividend <= out_dividend - out_divisor;
end

always @(posedge clk) //Quotient block
begin
	if(init)
		out_quotient <= 0;
	else if (sub)
		out_quotient <= (out_quotient << 1) + 1;
	else if (right)
		out_quotient <= out_quotient << 1;
		
end

always @(posedge clk) //Count Block
begin
	if(init)
		cnt <= 1;
	else if(left)
		cnt <= cnt + 1;
	else if(right)
		cnt <= cnt - 1;
end

endmodule
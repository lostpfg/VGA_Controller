module cnt25 (reset, clk, enable, clkdiv25);
	input reset, clk, enable;
	output clkdiv25;
	reg [5:0] cnt;

	assign clkdiv25 = (cnt==5'd24);
	always @(posedge reset or posedge clk)
	  if (reset) cnt <= 0;
	   else if (enable) 
	          if (clkdiv25) cnt <= 0;
	            else cnt <= cnt + 1;
endmodule

module cnt64 (reset, clk, enable, clkdiv64);
	input reset, clk, enable;
	output clkdiv64;
	reg [5:0] cnt;

	assign clkdiv64 = (cnt==6'd63);
	always @ ( posedge reset or posedge clk )
	  if (reset) cnt <= 0;
	   else if (enable) cnt <= cnt + 1;
endmodule

module cnt4 (reset, clk, enable, clkdiv5);
	input reset, clk, enable;
	output clkdiv5;
	reg [2:0] cnt;

	assign clkdiv5 = (cnt==3'd4);
	always @ ( posedge reset or posedge clk )
	  if (reset) cnt <= 0;
	   else if (enable) cnt <= cnt + 1;
endmodule

module flashClk ( reset, clk, en_nxt );
	input clk, reset;
	output en_nxt;
	wire clk1Hz;
	wire first, second, third, fourth;

	cnt25 i0 (reset, clk, 1'b1, first);
	cnt25 i1 (reset, clk, first, second);
	cnt25 i2 (reset, clk, first & second, third);
	cnt64 i4 (reset, clk, first & second & third, fourth);
	cnt4  i5 (reset, clk, first & second & third & fourth, clk1Hz);
	assign en_nxt = first & second & third & fourth & clk1Hz;
endmodule

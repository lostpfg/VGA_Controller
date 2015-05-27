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

module cnt6b (reset, clk, enable, clkdiv64);
input reset, clk, enable;
output clkdiv64;
reg [5:0] cnt;

assign clkdiv64 = (cnt==6'd63);
always @ ( posedge reset or posedge clk )
  if (reset) cnt <= 0;
   else if (enable) cnt <= cnt + 1;
endmodule

module flashClk ( reset, clk, en_nxt );
	input clk, reset;
	output en_nxt;
	wire clk5Hz;
	wire first, second, third;

	cnt25 i0 (reset, clk, 1'b1, first);
	cnt25 i1 (reset, clk, first, second);
	cnt25 i2 (reset, clk, first & second, third);
	cnt6b i4 (reset, clk, first & second & third, clk5Hz);
	
	assign en_nxt = first & second & third & clk5Hz;
endmodule

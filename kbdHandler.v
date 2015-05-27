/*----- Module Overview ------------------------------------------*
*                                                                 *
*                      _____________________                      *
*                                                                 *
*                     |                     |                     * 
*  clock    ------->  |                     |                     * 
*  reset    ------->  |     kbdHandler      | --/04--> scancode   *
*  ps2Data  ------->  |                     |                     * 
*  ps2Clk   ------->  |                     |                     *
*                     |                     |                     *  
*                      _____________________                      *
*                                                                 *
*-----------------------------------------------------------------*/

module kbdHandler ( reset, clock, ps2clk, ps2data, scancode );
  
  input reset;
  input clock; 
  input ps2clk;
  input ps2data;

  output reg [7:0] scancode;

  wire fall_edge; // indicates a falling_edge at ps2clk
  // Synchronize ps2clk to local clock and check for falling edge;
  reg    [7:0] ps2clksamples; // Stores last 8 ps2clk samples
  reg    [9:0] shift;   // Stores a serial package, excluding the stop bit;
  reg    [3:0] cnt;     // Used to count the ps2data samples stored so far
  reg          f0;      // Used to indicate that f0 was encountered earlier

  always @ ( posedge clock or posedge reset )
    if ( reset ) 
      ps2clksamples <= 8'd0;
    else 
      ps2clksamples <= {ps2clksamples[7:0], ps2clk};

  assign fall_edge = (ps2clksamples[7:4] == 4'hF) & (ps2clksamples[3:0] == 4'h0);

  // A simple FSM is implemented here. Grab a whole package,
  // check its parity validity and output it in the scancode
  // only if the previous read value of the package was F0
  // that is, we only trace when a button is released, NOT when it is
  // pressed.
  
  always @ ( posedge clock or posedge reset )
    if (reset) 
      begin
        cnt        <= 4'd0;
        scancode   <= 8'd0;
        shift      <= 10'd0;
        f0         <= 1'b0;
      end  
     else if ( fall_edge )
         begin
           if (cnt == 4'd10) // we just received what should be the stop bit
             begin
               cnt <= 0;
               if ((shift[0] == 0) && (ps2data == 1) && (^shift[9:1]==1)) // A well received serial packet
                 begin
                   scancode   <= 8'd0;
                   if (f0) // following a scancode of f0. So a key is released ! 
                     begin
                      scancode <= shift[8:1];
                      f0 <= 0;
                     end
                    else if (shift[8:1] == 8'hF0) 
                      f0 <= 1'b1;
                 end // All other packets have to do with key presses and are ignored
             end
            else
             begin
               shift <= {ps2data, shift[9:1]}; // Shift right since LSB first is transmitted
               cnt <= cnt+1;
             end
         end
endmodule

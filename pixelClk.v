/*----- Module Overview -------------------------------------*
*                                                            *
*                    _______________                         *
*                                                            *
*                   |               |                        * 
*  clock  ------->  |               |                        * 
*  reset  ------->  |   pixelClk    |  ------->  clockMod4   *
*                   |               |                        * 
*                    _______________                         *
*                                                            *
*                                                            *
*        _   _   _   _   _   _   _   _   _   _   _           *
*      _| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_         *
*                                                            *
*                _______________                 ___         *
*      _________|               |_______________|            *
*                                                            *
*                                                            *
*------------------------------------------------------------*/

module pixelClk ( clock, reset, outClk );

  input            clock;
  input            reset;

  wire             clockMod4;
  reg     [1:0]    cnt; /* 2 bit register */

  output  reg      outClk;

  assign clockMod4 = ( cnt == 2'd3 ); /* We count at range 0-3 */

  always @ ( posedge clock or posedge reset )
    if ( reset ) 
      cnt <= 0; /* Clear Counter */
    else 
      cnt <= cnt + 1;

  always @ ( posedge clockMod4 or posedge reset )
    if ( reset ) 
      outClk <= 0; 
    else 
      outClk <= ~outClk;

endmodule

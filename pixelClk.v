/*----- Module Overview ---------------------------------------*
*                                                              *
*                      _______________                         *
*                                                              *
*                     |               |                        * 
*  clock  ------->    |               |                        * 
*  reset    ------->  |   pixelClk    |  ------->  clockMod4   *
*                     |               |                        * 
*                      _______________                         *
*                                                              *
*--------------------------------------------------------------*/
module pixelClk ( clock, reset, clockMod4 );

  input           clock;
  input           reset;

  reg     [1:0]   cnt; /* 2 bit register */

  output          clockMod4;
  
  assign clockMod4 = ( cnt == 2'd3 ); /* We count at range 0-3 */

  always @ ( posedge clock or posedge reset )
    if ( reset ) 
      cnt <= 0; /* Clear Counter */
    else 
      cnt <= cnt + 1;

endmodule
/*----- Module Overview ------------------------------------------*
*                                                                 *
*                      _____________________                      *
*                                                                 *
*                     |                     |                     * 
*  clock    ------->  |                     |                     * 
*  reset    ------->  |    kbdController    | --/04--> ps2OutCode *
*  ps2Data  ------->  |                     |                     * 
*  ps2Clk   ------->  |                     |                     *
*                     |                     |                     *  
*                      _____________________                      *
*                                                                 *
*-----------------------------------------------------------------*/

module  kbdController ( clock,  reset, ps2Clk, ps2Data, ps2OutCode );

  input                 clock;
  input                 ps2Clk;
  input                 reset;
  input                 ps2Data;

  wire        [7:0]     scanCode;
  output      [3:0]     ps2OutCode;

  kbdHandler  i0 ( reset, clock, ps2Clk, ps2Data, scanCode );
  ps2Decode   i1 ( scanCode, ps2OutCode  );

endmodule
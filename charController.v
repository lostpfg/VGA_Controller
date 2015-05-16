/*----- Module Overvie--w ------------------------------------------*
*																																		*
*                 	     _____________________                      *
*																																		*
*												|											|											* 
*  clock      ------->	|											|                     * 
*  reset      ------->	|									  	|											* 
*  pixelCnt  	--/10-->	|	   charController		| --/09--> vgaRGB     *
*  lineCnt   	--/09-->	|											|											* 
*  rgbIn		 	--/03-->  |											|											*  
*												|											|											* 
*                      	 _____________________                      *
*																																		*
*																																		*
*-------------------------------------------------------------------*/

module  charController	(	clock,	reset, pixelCnt, lineCnt, rgbIn, vgaRGB );

	input						      clock;
	input						      reset;
	input		     [9:0]    pixelCnt; /* Counter of pixels in a line */
	input		     [8:0]		lineCnt;  /* Counter of  lines per frame */
	input	       [2:0]		rgbIn;

	wire 		     [2:0]	  vgaR;  /* Tracks Red Color Depth */
	wire 		     [2:0]    vgaG;  /* Tracks Green Color Depth */
	wire 		     [2:0]	  vgaB;  /* Tracks Blue Color Depth */

	reg 		     [2:0]	  rowCnt;	/* Counter for lines in active Region */
	reg 		     [3:0]	  colCnt;	/* Counter for pixels in active Region */
  reg                   rowEn;  /* Counter for lines in active Region */
  reg                   colEn;  /* Counter for pixels in active Region */

	output	reg  [8:0]	  vgaRGB;

  /* Active Display Regions -- Center of the Screen @ sizeof 16x8 */

  localparam HDT = 640;   /* Horizontal Display Time */
  localparam HAL = 16;    /* Horizontal Active Region Lenght */

  localparam VDT = 400;   /* Vertical Display Time */
  localparam VAL = 8;			/* Vertical Active Region Lenght */

  localparam CHM = 2;     /* Character Magnify */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          rowCnt  <= 3'd0;
          rowEn   <= 1'b0;
        end
      else if ( lineCnt == ( ( HDT - HAL*CHM )/2 ) - 1 ) /* Reached the last line of Active Region, so reset the counter */
        begin
          rowCnt  <= 3'd0;
          rowEn   <= ~rowEn;
        end
      else if ( ( lineCnt >=  HAE - 1 ) && ( lineCnt < ( ( HDT - HAL*CHM )/2 ) - 1 ) ) /* Did not reach the last line, so increase the counter */
        begin
          rowCnt  <=  rowCnt + 1;
          rowEn   <=  ~rowEn;
        end
  end

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          colCnt  <= 2'd0;
          colEn   <= 1'b0;
        end
      else if ( pixelCnt == ( ( VDT - VAL*CHM )/2 ) - 1 ) ) /* Reached the last pixel of Active Region, so reset the counter */
        begin
          colCnt  <= 2'd0;
          colEn   <= ~colEn;
        end
      else if ( ( pixelCnt >=  VAE - 1 ) && ( pixelCnt < ( ( VDT - VAL*CHM )/2 ) - 1 ) )/* Did not reach the pixel line, so increase the counter */
        begin
          colCnt  <=  colCnt + 1;
          colEn   <=  ~colEn;
        end
  end

  UpDownCounter3bit  redCnt   ( clock, reset, rgbIn[0], vgaR ); 
  UpDownCounter3bit  greenCnt ( clock, reset, rgbIn[1], vgaG ); 
  UpDownCounter3bit  blueCnt  ( clock, reset, rgbIn[2], vgaB ); 

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        vgaRGB	<=  9'd0; /* Clear RGB Buffer */
      else if ( colEn && rowEn ) /* Inside Active Region */
  			vgaRGB	<= { vgaB, vgaG, vgaR }; /* Pass each color's depth to output's buffer */
      else 
        vgaRGB	<=  9'd0; 	/* Outside Display Region everything is black */
  end

endmodule
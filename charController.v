/*----- Module Overvie--w ------------------------------------------*
*																																		*
*                 	     _____________________                      *
*																																		*
*												|											|											* 
*  clock   ------->	|											|                      * 
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
	input		     [9:0]    pixelCnt; /* Counter for pixels in a line */
	input		     [8:0]		lineCnt;  /* Counter of  lines per frame */
	input	       [2:0]		rgbIn;

	reg 		     [2:0]	  vgaR;
	reg 		     [2:0]    vgaG;
	reg 		     [2:0]	  vgaB;

	reg 		     [2:0]	  charRow;	/* Counter for pixels in a line */
	reg 		     [3:0]	  charCol;	/* Counter for pixels in a line */
	reg 		     [7:0] 	  dispLine;

	output	reg  [8:0]	  vgaRGB;

  localparam HAE = 192;   /* Horizontal Active Area Start */
  localparam HAL = 16;		/* Horizontal Active Region Lenght */

  localparam VAE = 316;		/* Horizontal Active Area Start */
  localparam VAL = 8;			/* Horizontal Active Region Lenght */

  always @ ( lineCnt or posedge reset ) begin
      if ( reset )
          charRow <= 3'd0;
      else if (  pixelCnt == ( HAE + HAL ) - 1 ) /* Reached the last line of Active Region, so reset the counter */
          charRow <= 3'd0;
      else if (  pixelCnt >= HAE - 1 ) /* Did not reach the last line, so increase the counter */
          charRow <=  charRow + 1;
  end

  always @ ( pixelCnt or posedge reset ) begin
      if ( reset )
          charCol <= 10'd0;
      else if (  pixelCnt == ( VAE + VAL ) - 1 ) /* Reached the last line of Active Region, so reset the counter */
          charCol <= 10'd0;
      else if (  pixelCnt >= VAE - 1 )/* Did not reach the last line, so increase the counter */
          charCol <=  charCol + 1;
  end

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        dispLine	<= 8'd0; 	/* Reset Char Register */
      else if ( charRow != 3'd0 && charCol != 4'd0 )
  			dispLine	<= 8'hFF; 	/* Reset Char Register */
      else 
      	dispLine	<= 8'd0; 	/* Reset Char Register */
  end

  /* Color Edit Mode */
  always @ ( posedge reset ) begin
      if ( reset ) /* Clear Colors Registers */
        begin
          vgaR      <= 3'd0;
          vgaG      <= 3'd0;
          vgaB      <= 3'd0;
          upDownRGB <= 3'b0
        end
  end

  UpDownCounter3bit  redCnt   ( clock, reset, rgbIn[0], vgaR ) ; 
  UpDownCounter3bit  greenCnt ( clock, reset, rgbIn[1], vgaG ) ; 
  UpDownCounter3bit  blueCnt  ( clock, reset, rgbIn[2], vgaB ) ; 

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        vgaRGB		<=  9'd0;
      else if ( charRow != 3'd0 && charCol != 4'd0 ) /* Reached the last line of Active Region, so reset the counter */
  			vgaRGB	<= { vgaB, vgaG, vgaR };
      else 
        vgaRGB	<=  9'd0; 	/* Outside Display Region everything is black */
  end

endmodule
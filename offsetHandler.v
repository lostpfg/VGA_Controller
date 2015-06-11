/*----- Module Overview --------------------------------------------------*
*                                                                         *
*                         ________________________                        *
*                                                                         *
*                        |                        |                       * 
*  reset       ------->  |                        | --/09--> posVerStart  *
*  offsetFlag  --/04-->  |                        | --/09--> posVerEnd    *
*  offsetStep  ------->  |      offsetHandler     | --/10--> posHorStart  * 
*                        |                        | --/10--> posHorEnd    *
*                        |                        |                       *
*                         ________________________                        *
*                                                                         *
*                                                                         *
*-------------------------------------------------------------------------*/

`include "globalVariables.v"

module  offsetHandler  ( reset, offsetStep, offsetFlag, posVerStart, posVerEnd , posHorStart, posHorEnd );
 
  input                   reset;
  input          [3:0]    offsetFlag;   /* Defines offset increament { Right, Left, Down, Up }  */
  input          [3:0]    offsetStep;   /* Defines moving speed (default 1*CharDim)  */
 
  output  reg    [8:0]    posVerStart;  
  output  reg    [8:0]    posVerEnd;
  output  reg    [9:0]    posHorStart;  /* [0,640] */
  output  reg    [9:0]    posHorEnd;    /* [0,640] */


  /* Initialize Drawable Region at the center of the Active Region of the Screen */

  initial 
    begin
      posVerStart <= ( ( `VDR - `VAL )/2 );
      posVerEnd   <= ( ( `VDR - `VAL )/2 ) + ( `VAL - 1 );
      posHorStart <= ( ( `HDR - `HAL )/2 );
      posHorEnd   <= ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
    end

  always @ ( posedge offsetFlag[0] or posedge offsetFlag[1] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posVerStart <= ( ( `VDR - `VAL )/2 );
      posVerEnd   <= ( ( `VDR - `VAL )/2 ) + ( `VAL - 1 );
    end
  else if ( offsetFlag[0] ) /* Drawable Region moves up */
    begin
      if ( posVerStart >= `VAL*offsetStep + 1 ) 
        begin
           posVerStart <= posVerStart - `VAL*offsetStep; 
           posVerEnd   <= ( posVerEnd > `VAL*offsetStep - 1 ) ? ( posVerEnd - `VAL*offsetStep ): ( `VDR - `VAL*offsetStep + posVerEnd );
        end
      else
        begin
           posVerStart <= `VDR - `VAL*offsetStep + posVerStart;
           posVerEnd   <= ( posVerEnd == `VAL*offsetStep ) ? `VDR : ( posVerEnd - `VAL*offsetStep );
        end
    end
  else /* Drawable Region moves down */
   if ( posVerStart <= `VDR - `VAL*offsetStep ) 
      begin
         posVerStart <= posVerStart + `VAL*offsetStep; 
         posVerEnd   <= ( posVerEnd >= `VDR - `VAL*offsetStep ) ? ( `VAL*offsetStep - ( `VDR - posVerEnd ) ) : posVerEnd + `VAL*offsetStep;
      end
    else
      begin
         posVerStart <=  `VAL*offsetStep - ( `VDR - posVerStart ) ;
         posVerEnd   <= ( posVerEnd == `VDR ) ? `VAL*offsetStep : ( posVerEnd + `VAL*offsetStep );
      end

  always @ ( posedge offsetFlag[2] or posedge offsetFlag[3] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posHorStart <= ( ( `HDR - `HAL )/2 );
      posVerEnd   <= ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
    end
  else if ( offsetFlag[2] ) /* Drawable Region moves left */
    begin
      if ( posHorStart >= `HAL*offsetStep + 1 ) 
        begin
           posHorStart <= posHorStart - `HAL*offsetStep; 
           posVerEnd   <= ( posVerEnd > `HAL*offsetStep - 1 ) ? ( posVerEnd - `HAL*offsetStep ): ( `HDR - `HAL*offsetStep + posVerEnd );
        end
      else
        begin
           posHorStart <= `HDR - `HAL*offsetStep + posHorStart;
           posVerEnd   <= ( posVerEnd == `HAL*offsetStep ) ? `HDR : ( posVerEnd - `HAL*offsetStep );
        end
    end
  else /* Drawable Region moves right */
    begin
      if ( posHorStart <= `HDR - `HAL*offsetStep ) 
        begin
          posHorStart <= posHorStart + `HAL*offsetStep; 
          posHorEnd   <= ( posHorEnd >= `HDR - `HAL*offsetStep ) ? ( `HAL*offsetStep - `HDR + posHorEnd ) : posHorEnd + `HAL*offsetStep;
        end
      else
        begin
          posHorStart <=  `HAL*offsetStep - ( `HDR - posHorStart ) ;
          posHorEnd   <= ( posHorEnd == `HDR ) ? `HAL*offsetStep : ( posHorEnd + `HAL*offsetStep );
        end
    end

endmodule

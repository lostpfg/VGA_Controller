/*----- Module Overview -----------------------------------------------------*
*                                                                            *
*                            ________________________                        *
*                                                                            *
*                           |                        |                       *
*  clock          ------->  |                        |                       * 
*  reset          ------->  |                        | --/09--> posVerStart  *
*  moveDirection  --/04-->  |     offsetHandler      | --/09--> posVerEnd    *
*  movemoveStep   --/03-->  |                        | --/10--> posHorStart  * 
*                           |                        | --/10--> posHorEnd    *
*                           |                        |                       *
*                            ________________________                        *
*                                                                            *
*                                                                            *
*----------------------------------------------------------------------------*/
   
`include "globalVariables.v   "

module  offsetHandler  ( clock, reset, movemoveStep , moveDirection, posVerStart, posVerEnd , posHorStart, posHorEnd );
    
  input                   clock;   
  input                   reset;
  input          [3:0]    moveDirection;   /* Defines offset increament { Right, Left, Down, Up }  */
  input          [3:0]    movemoveStep;    /* Defines moving speed (default 1*CharDim)  */

  output  reg    [8:0]    posVerStart;
  output  reg    [8:0]    posVerEnd;
  output  reg    [9:0]    posHorStart;
  output  reg    [9:0]    posHorEnd;


initial 
    begin
      posVerStart <= ( ( `VDR - `VAL )/2 );
      posVerEnd   <= ( ( `VDR - `VAL )/2 ) + ( `VAL - 1 );
      posHorStart <= ( ( `HDR - `HAL )/2 );
      posHorEnd   <= ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
    end

  always @ ( posedge clock or posedge reset )
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
  else if ( offsetFlag[1] ) /* Drawable Region moves down */
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

  always @ ( posedge clock or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posHorStart <= ( ( `HDR - `HAL )/2 );
      posHorEnd   <= ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
    end
  else if ( offsetFlag[2] ) /* Drawable Region moves left */
    begin
      if ( posHorStart >= `HAL*offsetStep + 1 ) 
        begin
           posHorStart <= posHorStart - `HAL*offsetStep; 
           posHorEnd   <= ( posHorEnd > `HAL*offsetStep - 1 ) ? ( posHorEnd - `HAL*offsetStep ): ( `HDR - `HAL*offsetStep + posHorEnd );
        end
      else
        begin
           posHorStart <= `HDR - `HAL*offsetStep + posHorStart;
           posHorEnd   <= ( posHorEnd == `HAL*offsetStep ) ? `HDR : ( posHorEnd - `HAL*offsetStep );
        end
    end
  else if ( offsetFlag[3] )/* Drawable Region moves right */
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

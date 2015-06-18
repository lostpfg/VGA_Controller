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
    else if ( moveDirection[0] ) /* Drawable Region moves up */
      begin
        if ( posVerStart >= `VAL*movemoveStep + 1 ) 
          begin
            posVerStart <= posVerStart - `VAL*movemoveStep; 
            posVerEnd   <= ( posVerEnd > `VAL*movemoveStep - 1 ) ? ( posVerEnd - `VAL*movemoveStep ): ( `VDR - `VAL*movemoveStep + posVerEnd );
          end
        else
          begin
            posVerStart <= `VDR - `VAL*movemoveStep + posVerStart;
            posVerEnd   <= ( posVerEnd == `VAL*movemoveStep ) ? `VDR : ( posVerEnd - `VAL*movemoveStep );
          end
      end
    else if ( moveDirection[1] ) /* Drawable Region moves down */
      if ( posVerStart <= `VDR - `VAL*movemoveStep ) 
        begin
          posVerStart <= posVerStart + `VAL*movemoveStep; 
          posVerEnd   <= ( posVerEnd >= `VDR - `VAL*movemoveStep + 1 ) ? ( `VAL*movemoveStep - ( `VDR - posVerEnd ) ) : posVerEnd + `VAL*movemoveStep;
        end
      else
        begin
          posVerStart <=  `VAL*movemoveStep - ( `VDR - posVerStart ) ;
          posVerEnd   <= ( posVerEnd == `VDR ) ? `VAL*movemoveStep : ( posVerEnd + `VAL*movemoveStep );
        end

  always @ ( posedge clock or posedge reset )
    if ( reset )
      begin /* Reset to Center */ 
        posHorStart <= ( ( `HDR - `HAL )/2 );
        posHorEnd   <= ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
      end
    else if ( moveDirection[2] ) /* Drawable Region moves left */
      begin
        if ( posHorStart >= `HAL*movemoveStep + 1 ) 
          begin
            posHorStart <= posHorStart - `HAL*movemoveStep; 
            posHorEnd   <= ( posHorEnd > `HAL*movemoveStep - 1 ) ? ( posHorEnd - `HAL*movemoveStep ): ( `HDR - `HAL*movemoveStep + posHorEnd );
          end
        else
          begin
            posHorStart <= `HDR - `HAL*movemoveStep + posHorStart;
            posHorEnd   <= ( posHorEnd == `HAL*movemoveStep ) ? `HDR : ( posHorEnd - `HAL*movemoveStep );
          end
      end
    else if ( moveDirection[3] )/* Drawable Region moves right */
      begin
        if ( posHorStart <= `HDR - `HAL*movemoveStep ) 
          begin
            posHorStart <= posHorStart + `HAL*movemoveStep; 
            posHorEnd   <= ( posHorEnd >= `HDR - `HAL*movemoveStep + 1 ) ? ( `HAL*movemoveStep - `HDR + posHorEnd ) : ( posHorEnd + `HAL*movemoveStep );
          end
        else
          begin
            posHorStart <=  `HAL*movemoveStep - ( `HDR - posHorStart ) ;
            posHorEnd   <= ( posHorEnd == `HDR ) ? `HAL*movemoveStep : ( posHorEnd + `HAL*movemoveStep );
          end
      end

endmodule

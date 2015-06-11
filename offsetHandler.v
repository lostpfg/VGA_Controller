/*----- Module Overview -------------------------------------------------*
*                                                                        *
*                         ________________________                       *
*                                                                        *
*                        |                        |                      * 
*  reset       ------->  |                        | --/09-- posVerStart  *
*  charSize    ------->  |                        | --/09-- posVerEnd    *
*  OffsetFlag  --/04-->  |      offsetHandler     | --/10-- posHorStart  * 
*                        |                        | --/10--> posHorEnd   *
*                        |                        |                      *
*                         ________________________                       *
*                                                                        *
*                                                                        *
*------------------------------------------------------------------------*/

`include "globalVariables.v"

module  offsetHandler  ( reset, charSize, OffsetFlag, posVerStart, posVerEnd , posHorStart, posHorEnd );
 
  input                   reset;
  input          [2:0]    charSize;     /* Defines size of character  */
  input          [3:0]    OffsetFlag;   /* Defines offset increament { Right, Left, Down, Up }  */
 
  output  reg    [8:0]    posVerStart;  
  output  reg    [8:0]    posVerEnd;
  output  reg    [9:0]    posHorStart;  /* [0,640] */
  output  reg    [9:0]    posHorEnd;    /* [0,640] */


  /* Initialize Drawable Region at the center of the Active Region of the Screen */

  initial 
    begin
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posHorEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end

  always @ ( posedge OffsetFlag[0] or posedge OffsetFlag[1] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
    end
  else if ( OffsetFlag[0] ) /* Drawable Region moves up */
    begin
      if ( posVerStart >= `VAL*`CHM + 1 ) 
        begin
           posVerStart <= posVerStart - `VAL*`CHM; 
           posVerEnd   <= ( posVerEnd > `VAL*`CHM - 1 ) ? ( posVerEnd - `VAL*`CHM ): ( `VDR - `VAL*`CHM + posVerEnd );
        end
      else
        begin
           posVerStart <= `VDR - `VAL*`CHM + posVerStart;
           posVerEnd   <= ( posVerEnd == `VAL*`CHM ) ? `VDR : ( posVerEnd - `VAL*`CHM );
        end
    end
  else /* Drawable Region moves down */
   if ( posVerStart <= `VDR - `VAL*`CHM ) 
      begin
         posVerStart <= posVerStart + `VAL*`CHM; 
         posVerEnd   <= ( posVerEnd >= `VDR - `VAL*`CHM ) ? ( `VAL*`CHM - ( `VDR - posVerEnd ) ) : posVerEnd + `VAL*`CHM;
      end
    else
      begin
         posVerStart <=  `VAL*`CHM - ( `VDR - posVerStart ) ;
         posVerEnd   <= ( posVerEnd == `VDR ) ? `VAL*`CHM : ( posVerEnd + `VAL*`CHM );
      end

  always @ ( posedge OffsetFlag[2] or posedge OffsetFlag[3] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posVerEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end
  else if ( OffsetFlag[2] ) /* Drawable Region moves left */
    begin
      if ( posHorStart >= `HAL*`CHM + 1 ) 
        begin
           posHorStart <= posHorStart - `HAL*`CHM; 
           posVerEnd   <= ( posVerEnd > `HAL*`CHM - 1 ) ? ( posVerEnd - `HAL*`CHM ): ( `HDR - `HAL*`CHM + posVerEnd );
        end
      else
        begin
           posHorStart <= `HDR - `HAL*`CHM + posHorStart;
           posVerEnd   <= ( posVerEnd == `HAL*`CHM ) ? `HDR : ( posVerEnd - `HAL*`CHM );
        end
    end
  else /* Drawable Region moves right */
    begin
      if ( posHorStart <= `HDR - `HAL*`CHM ) 
        begin
          posHorStart <= posHorStart + `HAL*`CHM; 
          posHorEnd   <= ( posHorEnd >= `HDR - `HAL*`CHM ) ? ( `HAL*`CHM - `HDR + posHorEnd ) : posHorEnd + `HAL*`CHM;
        end
      else
        begin
          posHorStart <=  `HAL*`CHM - ( `HDR - posHorStart ) ;
          posHorEnd   <= ( posHorEnd == `HDR ) ? `HAL*`CHM : ( posHorEnd + `HAL*`CHM );
        end
    end

endmodule

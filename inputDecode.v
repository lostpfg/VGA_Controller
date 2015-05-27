/*----- Module Overview --------------------------------------------*
*                                                                   *
*                        _________________                          *
*                                                                   *
*                       |                 |                         * 
*  clock      ------->  |                 |  --/03-->  userNum      *
*  reset      ------->  |                 |  --/04-->  charSize     *
*  inCode     --/04-->  |                 |  --/09-->  rgbDepth     *
*                       |   inputDecode   |  --/08-->  upOffset     *
*                       |                 |  --/08-->  downOffset   *
*                       |                 |  --/08-->  leftOffset   *
*                       |                 |  --/08-->  rightOffset  *
*                       |                 |  ------->  enFlash      *
*                       |                 |                         * 
*                        _________________                          *
*                                                                   *
*-------------------------------------------------------------------*/

module inputDecode ( clock , reset, inCode, userNum, charSize, rgbDepth, upOffset, downOffset, leftOffset, rightOffset, enFlash );

  input                   clock;
  input                   reset;
  input          [3:0]    inCode;

  output reg     [2:0]    userNum;
  output reg     [3:0]    charSize;
  output reg     [8:0]    rgbDepth;
  output reg     [7:0]    leftOffset;
  output reg     [7:0]    rightOffset;
  output reg     [7:0]    upOffset;
  output reg     [7:0]    downOffset;
  output reg              enFlash;

  wire           [2:0]    outColor;

  initial 
    begin
      charSize    <= 3'h1; /* Initialize Character size to 1 */
      userNum     <= 3'h4; /* Initialize to {1,00}={number pressed, number} */
    end

  /* Detect codes relevant to number input */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
          userNum  <= 3'h4;
      else
        if ( ( inCode >= 4'h0 ) && ( inCode <= 4'h3 ) )
          userNum <= inCode - 1'b1;
  end

  /* Detect codes relevant to RGB input */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        outColor  <= 3'h0;
      else
        case ( inCode )
          4'h4    : outColor  <= 3'h1;  /* Enable R */
          4'h5    : outColor  <= 3'h2;  /* Enable G */
          4'h6    : outColor  <= 3'h4;  /* Enable B */
          default : outColor  <= 3'h0;  /* Clear all flags */
        endcase
  end

  colorHandler i0 ( reset, outColor, rgbDepth );

  /* Detect Codes relevant to character position */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          upOffset    <= 3'd0;
          downOffset  <= 3'd0;
          leftOffset  <= 3'd0;
          rightOffset <= 3'd0;
        end
      else
        case ( inCode )
          4'h7 : upOffset    <= upOffset + 1;
          4'h8 : downOffset  <= downOffset + 1;
          4'h9 : leftOffset  <= leftOffset + 1;
          4'hA : rightOffset <= rightOffset + 1;
        endcase
  end

  /* Detect Codes relevant to character magnify */
  
  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          charSize <= 3'd1;
        end
      else
        case ( inCode )
          4'hB : charSize   <= charSize + 1;
          4'hC : charSize   <= charSize - 1;
        endcase
  end

  /* Detect flash code */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          enFlash <= 1'b0;
        end
      else
        case ( inCode )
          4'hD : enFlash  <= ~enFlash;
        endcase
  end

  flashHandler i1 ( clock, reset, enFlash, flashCnt );

endmodule
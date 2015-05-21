/*----- Module Overview --------------------------------------------*
*                                                                   *
*                        _________________                          *
*                                                                   *
*                       |                 |                         * 
*  clock      ------->  |                 |  --/03-->  userNum      *
*  reset      ------->  |                 |  --/05-->  charSize     *
*  ps2InCode  --/04-->  |                 |  --/03-->  outColor     *
*                       |   inputDecode   |  --/08-->  leftOffset   *
*                       |                 |  --/08-->  rightOffset  *
*                       |                 |  --/08-->  upOffset     *
*                       |                 |  --/08-->  downOffset   *
*                       |                 |  ------->  enFlash      *
*                       |                 |                         * 
*                        _________________                          *
*                                                                   *
*-------------------------------------------------------------------*/

module inputDecode ( clock , reset, inCode, userNum, charSize, outColor, upOffset, downOffset, leftOffset, rightOffset, enFlash );

  input                   clock;
  input                   reset;
  input          [3:0]    inCode;

  output reg     [2:0]    userNum;
  output reg     [4:0]    charSize;
  output reg     [2:0]    outColor;
  output reg     [7:0]    leftOffset;
  output reg     [7:0]    rightOffset;
  output reg     [7:0]    upOffset;
  output reg     [7:0]    downOffset;
  output reg              enFlash;

  initial begin
    charSize    <= 3'd1; /* Initialize char size to 1 */
  end

  /* Detect key strokes relevant to number inputs */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
          userNum  <= 3'd0;
      else
        if ( ( inCode >= 4'h0 ) && ( inCode <= 4'h3 ) )
          userNum <= inCode - 1;
  end

  /* Detect Codes relevant to RGB inputs */

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        outColor  <= 3'd0;
      else
        case ( inCode )
          4'h4    : outColor  <= 3'd1; /* R */
          4'h5    : outColor  <= 3'd2; /* G */
          4'h6    : outColor  <= 3'd4; /* B */
          default : outColor  <= 3'd0; /* Do Nothing */
        endcase
  end

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
          4'h7 : upOffset   <= upOffset + 1;
          4'h8 : downOffset <= downOffset + 1;
          4'h9 : leftOffset <= leftOffset + 1;
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

endmodule
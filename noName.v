/*----- Module Overview ---------------------------------------------------*
*                                                                          *
*                       _____________________                              *
*                                                                          *
*                      |                     |                             *
*   clock     -------> |                     |                             *
*   reset     -------> |                     | -------> outBit             *
*   colEn     -------> |                     |                             *
*   rowEn     -------> |                     |                             *
*                      |                     |                             *
*                       _____________________                              *
*                                                                          *
*--------------------------------------------------------------------------*/

module  charParser ( clock, reset, rowEn, colEn, outBit ) ; 

  input                 clock;
  input                 reset;
  input                 colEn;
  input                 rowEn;

  output  reg           outBit;

  reg          [7:0]    romByte;

  assign  readEn = rowEn && colEn;

  charRom charByte ( clock, rowCnt, reqByte );

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          readEn  <= 1'b0;
          romByte <= 8'd0;
        end
      else if ( readEn ) /* Requested byte stored locally */
        romByte <= reqByte;
  end

  assign outBit = romByte[colCnt];

endmodule
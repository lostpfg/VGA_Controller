/*----- Module Overview ---------------------------------------------------*
*                                                                          *
*                       _____________________                              *
*                                                                          *
*                      |                     |                             *
*   clock     -------> |                     |                             *
*   reset     -------> |                     | -------> outBit             *
*   rowEn     -------> |                     |                             *
*   colEn     -------> |                     |                             *
*   reqByte   --/03--> |                     |                             *
*   reqBit    --/02--> |                     |                             *
*                      |                     |                             *
*                       _____________________                              *
*                                                                          *
*--------------------------------------------------------------------------*/

module  romController ( clock, reset, readEn, reqByte, reqBit, outBit ) ; 

  input                 clock;
  input                 reset;
  input     [2:0]       colCnt;
  input     [3:0]       rowCnt;
  input                 readEn;

  reg       [7:0]       romByte;

  wire      [7:0]       reqAddr;
  wire      [7:0]       romData;
 
  output                outBit;

  assign  reqAddr = { 2'd0, reqAddr }; // Replace msbits with character from user space

  charRom i0 ( clock, reqAddr, romData );

  always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        romByte <= 8'd0;
      else if ( readEn ) /* Requested byte stored locally */
        romByte <= romData;
  end
  
  assign outBit = romByte[colCnt];

endmodule

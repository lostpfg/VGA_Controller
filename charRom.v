/*----- Module Overview --------------------------------------*
*                                                             *
*                        _______________                      *
*                                                             *
*                       |               |                     * 
*  readEn     ------->  |               | --/08--> outData    *
*  inAddress  --/06-->  |    charRom    |                     * 
*                       |               |                     * 
*                        _______________                      *
*                                                             *
*-------------------------------------------------------------*/

module charRom ( readEn, inAddress, outData );

  input               readEn;
  input       [5:0]   inAddress;

  output reg  [7:0]   outData;

  always @ ( posedge readEn ) begin

    case ( inAddress )

      /* 00h: 1 */

      6'h00: outData <= 8'h0C; /*     ##  */
      6'h01: outData <= 8'h1C; /*    ###  */
      6'h02: outData <= 8'h7C; /*  #####  */
      6'h03: outData <= 8'hEC; /* ### ##  */
      6'h04: outData <= 8'h0C; /*     ##  */
      6'h05: outData <= 8'h0C; /*     ##  */
      6'h06: outData <= 8'h0C; /*     ##  */
      6'h07: outData <= 8'h0C; /*     ##  */
      6'h08: outData <= 8'h0C; /*     ##  */
      6'h09: outData <= 8'h0C; /*     ##  */
      6'h0A: outData <= 8'h0C; /*     ##  */
      6'h0B: outData <= 8'h0C; /*     ##  */
      6'h0C: outData <= 8'h0C; /*     ##  */
      6'h0D: outData <= 8'h0C; /*     ##  */
      6'h0E: outData <= 8'h0C; /*     ##  */
      6'h0F: outData <= 8'h0C; /*     ##  */

      /* 00h: 2 */

      6'h10: outData <= 8'h3C; /*   ####   */
      6'h11: outData <= 8'hFE; /* #######  */
      6'h12: outData <= 8'hE3; /* ###   ## */
      6'h13: outData <= 8'h03; /*       ## */
      6'h14: outData <= 8'h03; /*       ## */
      6'h15: outData <= 8'h03; /*       ## */
      6'h16: outData <= 8'h06; /*      ##  */
      6'h17: outData <= 8'h0C; /*     ##   */
      6'h18: outData <= 8'h18; /*    ##    */
      6'h19: outData <= 8'h30; /*   ##     */
      6'h1A: outData <= 8'h60; /*  ##      */
      6'h1B: outData <= 8'hC0; /* ##       */
      6'h1C: outData <= 8'hC0; /* ##       */
      6'h1D: outData <= 8'hC0; /* ##       */
      6'h1E: outData <= 8'hFF; /* ######## */
      6'h1F: outData <= 8'hFF; /* ######## */

      /* 00h: 3 */
   
      6'h20: outData <= 8'h3C; /*   ####   */
      6'h21: outData <= 8'h7E; /*  ######  */
      6'h22: outData <= 8'hE7; /* ###  ### */
      6'h23: outData <= 8'hE3; /* ###   ## */
      6'h24: outData <= 8'h03; /*       ## */
      6'h25: outData <= 8'h03; /*       ## */
      6'h26: outData <= 8'h07; /*      ### */
      6'h27: outData <= 8'h7E; /*  ######  */
      6'h28: outData <= 8'h7E; /*  ######  */
      6'h29: outData <= 8'h07; /*      ### */
      6'h2A: outData <= 8'h03; /*       ## */
      6'h2B: outData <= 8'h03; /*       ## */
      6'h2C: outData <= 8'hE3; /* ###   ## */
      6'h2D: outData <= 8'hE7; /* ###  ### */
      6'h2E: outData <= 8'h7E; /*  ######  */
      6'h2F: outData <= 8'h3C; /*   ####   */

      /* 00h: 4 */

      6'h30: outData <= 8'h1C; /*    ####  */
      6'h31: outData <= 8'h3C; /*   #####  */ 
      6'h32: outData <= 8'h76; /*  ### ##  */ 
      6'h33: outData <= 8'hE6; /* ###  ##  */ 
      6'h34: outData <= 8'hE6; /* ###  ##  */ 
      6'h35: outData <= 8'hC6; /* ##   ##  */ 
      6'h36: outData <= 8'hC6; /* ##   ##  */ 
      6'h37: outData <= 8'hFF; /* ######## */
      6'h38: outData <= 8'hFF; /* ######## */
      6'h39: outData <= 8'h06; /*      ##  */  
      6'h3A: outData <= 8'h06; /*      ##  */  
      6'h3B: outData <= 8'h06; /*      ##  */  
      6'h3C: outData <= 8'h06; /*      ##  */  
      6'h3D: outData <= 8'h06; /*      ##  */  
      6'h3E: outData <= 8'h06; /*      ##  */ 
      6'h3F: outData <= 8'h06; /*      ##  */ 

    endcase
                                  
  end
endmodule
# VGA_Controler

The project's structure is expanded below

        +--- topModule      
            |
            +--- pixelClk            
            |
            +--- kbdController    
            |   |
            |   +--- kbdHandler   
            |   |
            |   +--- ps2Decode    
            |
            +--- inputDecode  
            |    | 
            |    +--- colorHandler
            |    |    |
            |    |    +--- UpDownCounter3bit 
            |    |
            |    +--- flashHandler  
            |         |
            |         +--- flashClk 
            |             |
            |             +--- cnt64 
            |             |
            |             +--- cnt25 
            |
            +--- dispController
            |   |
            |   +--- vgaHandler
            |   |
            |   +--- charController
            |   |
            |   +--- offsetHandler
            |
            +--- romController 
                |
                +--- charRom             
    
### Character ROM

      '00111000' /*   ###    */
      '01111000' /*  ####    */
      '11111000' /* #####    */
      '10111000' /* ## ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '00011000' /*    ##    */
      '11111111' /* ######## */
      '11111111' /* ######## */

All characters are stored in the charROM(16x8bit) which contains the pattern of pixels being on the screen whether a particular character needs to be displayed. The bits within the rom indicate which pixels of a 16x8 bit tile should be displayed. By default rom stores pattern for characters 1,2,3 and 4.

## Functionality 

In the initial state, after the synchronization with the VGA interface the screen remains black. In order to display *(default position is the center of the screen)* the prefered character on the screen user can press the respective key to the available characters stored in the rom module.

### Position change

			- - - - - - - - - - - - - - - - - - - - - -
			|                                         |
			|                                         |
			|                  ---   ^                |
			|                 | # |  Y                |
			|                  ---   v                |
			|                 < X >                   |
			|                                         |
			- - - - - - - - - - - - - - - - - - - - - -

Using the arrow keys character moves on the screen in the corresponding direction by X or Y pixels defined by the character's dimensions *(default 16x8)*. Moving offset *(speed)* can be adjusted and increased up to 4*X,Y using +,- keys. In the case where the character region reaches the limits of the visible screen, character region is being  folded to the oposite side of the screen.

### Colour change
The color of the active pixels *(default white)* of a character can be changed by pressing the keys r, g and b. Every press of such a key increases the caracter's respective color *(3-bits)* component. Furthermore, user has the option to change the color of the background *(default black)* by pressing the key 'i'. In this case using the above exactly procedure color of the background component can be changed. A press of the key 'i' switches changing color mode back to character's region and vise versa.
 
### Flash
By pressing the key 'f' character starts to flash on the screen with frequency depending on the clock defined on the flashClk module.

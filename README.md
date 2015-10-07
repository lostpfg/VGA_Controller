# VGA_Controler

The project structure is expanded below

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
    
   

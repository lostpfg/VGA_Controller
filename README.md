# VGA_Controller

System Architecture

+--- topModule
    |
    +--- pixelClk                   ( 100% - Tested )
    |
    +--- kbdController          
    |   |
    |   +--- kbdHandler             ( 100% - Tested )
    |   |
    |   +--- ps2Decode              ( 90% -  More Tests Pending )
    |
    +--- inputDecode                ( 90% -  More Tests Pending )
    |
    +--- dispController                   
    |   |
    |   +--- vgaHandler             ( 100% - Tested )
    |   |
    |   +--- charController         ( 100% - Tested )
    |   |
    |   +--- colorController
    |       |
    |       +--- UpDownCounter3bit  ( 100% - Tested )
    |
    +--- romController
        |
        +--- charRom  ( 100% - Tested )

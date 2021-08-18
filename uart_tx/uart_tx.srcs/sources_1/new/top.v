`timescale 1ns / 1ps


module top #
// Parameters
(
    parameter
    romAddWidth = 4,
    romDataWidth = 8
)
// Inputs and Outputs
(
    input clk,
    output out
);
    
    
    
    rom # ( .romAddWidth(romAddWidth), .romDataWidth(romDataWidth) )
        rom_uart( .clk(clk), .addr(), .data() );
    
    
endmodule

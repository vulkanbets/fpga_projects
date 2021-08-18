`timescale 1ns / 1ps

module top #
// --Parameters
(
    parameter
    romAddrWidth = 4,
    romDataWidth = 8
)
// --Inputs and Outputs
(
    input clk,
    output out
);
    
    wire [romDataWidth - 1 : 0] rom_out;            // 
    reg [romAddrWidth - 1 : 0] rom_addr_in = 0;     // rom address coming in
    
    always @ (posedge clk)
    begin
        if(rom_addr_in < 13)
            rom_addr_in <= rom_addr_in + 1;
        else
            rom_addr_in <= 0;
    end
    
    
    rom # ( .romAddrWidth(romAddrWidth), .romDataWidth(romDataWidth) )
        rom_uart( .clk(clk), .addr(rom_addr_in), .data(rom_out) );
    
    
    
    
    
endmodule

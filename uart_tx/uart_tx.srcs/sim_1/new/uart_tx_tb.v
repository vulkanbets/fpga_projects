`timescale 1ns / 1ps

module uart_tx_tb # (parameter romAddrWidth = 4, romDataWidth = 8);
    
    // Inputs
    reg clk;                                                                // Internal Clock Oscillator
    
    // Outputs
    wire [romAddrWidth - 1 : 0] current_mem_selected = uut.rom_addr_in;     // Current Memory selected
    wire [romDataWidth - 1 : 0] current_data_selected = uut.rom_out;        // Current data selected
    
    // Unit under test (UUT)
    top uut
    (
        .clk(clk),
        .out()
    );
    
    
    // Clock generation
    always #17 clk <= ~clk;
    
    initial clk <= 0;
    
endmodule

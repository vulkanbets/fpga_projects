`timescale 1ns / 1ps


module uart_tx_tb # (parameter romAddWidth = 4, romDataWidth = 8);
    
    // Inputs
    reg clk;                                            // Internal Clock Oscillator
    
    // Outputs
    wire  out = uut.out;                                // Output data
    wire [romDataWidth - 1 : 0] current_mem_selected;
    
    // Unit under test (UUT)
    top uut
    (
        .clk(clk),
        .out(out)
    );
    
    
    // Clock generation
    always #10 clk <= ~clk;
    
    initial clk <= 0;
    
endmodule

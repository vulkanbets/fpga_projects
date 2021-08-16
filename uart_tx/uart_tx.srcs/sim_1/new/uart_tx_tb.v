`timescale 1ns / 1ps

module uart_tx_tb;
    
    // Inputs
    reg clk;             // Internal Clock Oscillator
    
    // Outputs
    wire  baud_clk = uut.baud_clk;      // Symbol Rate
    
    // Unit under test (UUT)
    top uut
    (
        .clk(clk)
    );
    
    
    // Clock generation
    always #10 clk <= ~clk;
    
    initial clk <= 0;
    
endmodule

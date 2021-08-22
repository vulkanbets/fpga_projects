`timescale 1ns / 1ps

module fibonacci_testbench;
    
    // Inputs
    reg clk;            // Internal Clock Oscillator
    
    // Outputs
    wire tx;            // Serial output of Tx Uart Line
    
    
    // Unit under test (UUT)
    top uut
    (
        .clk(clk),
        .tx(tx)
    );
    
    
    // Clock generation
    always #20 clk <= ~clk;
    
    initial clk <= 0;
    
endmodule

`timescale 1ns / 1ps

module top #
// --Parameters
(
    parameter
    WORDLENGTH = 64  // <-- 64-bit data type
)
// --Inputs and Outputs
(
    input clk,
    output tx
);
    
    // Initial value is set to 0
    reg [WORDLENGTH - 1 : 0] fn_0 = 0; //<-- This represents f(n-2)
    // Initial value is set to 1
    reg [WORDLENGTH - 1 : 0] fn_1 = 1; //<-- This represents f(n-1)
    // current vaue register holder
    reg [WORDLENGTH - 1 : 0] fn_1 = 0; //<-- This represents f(n)
    
    
    
    assign tx = ~clk;
    
endmodule

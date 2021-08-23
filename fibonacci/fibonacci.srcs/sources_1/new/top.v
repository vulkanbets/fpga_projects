`timescale 1ns / 1ps

module top #
// --Parameters
(
    parameter
    WORDLENGTH = 64,    // <-- 64-bit data type
    N = 40              // <-- Number of iterations to calculate
)
// --Inputs and Outputs
(
    input clk,
    output tx
);
    
    reg [WORDLENGTH - 1 : 0] index = 0;     // Initialize Index to 0
    reg [WORDLENGTH - 1 : 0] i_end = N;     // Ending index of sequence
    
    // Initial value is set to 0
    reg [WORDLENGTH - 1 : 0] fn_0 = 0;      //<-- This represents f(n-2)
    
    // Initial value is set to 1
    reg [WORDLENGTH - 1 : 0] fn_1 = 1;      //<-- This represents f(n-1)
    
    // current vaue being calculated register
    reg [WORDLENGTH - 1 : 0] fn;            //<-- This represents f(n)
    
    
    always @ (posedge clk)
    begin
        if(index < N) begin index <= index + 1; end
        if(index > 1 && index < N)
        begin
            fn_0 <= fn_1;
            fn_1 <= fn;
        end
    end
    
    
    always @ (*)
    begin
        if(index == 0) begin fn <= fn_0; end
        else if(index == 1) begin fn <= fn_1; end
        else if(index < N)
        begin
            fn <= fn_0 + fn_1;
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule

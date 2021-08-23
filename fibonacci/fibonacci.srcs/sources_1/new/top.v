`timescale 1ns / 1ps

module top #
// --Parameters
(
    parameter
    N = 40,                         //<-- Number of iterations to calculate
    WORDLENGTH = 64,                //<-- These values are for the FIFO
    MEMDEPTH = 32,                  //<-- These values are for the FIFO
    MEMDEPTHBITS = $clog2(MEMDEPTH) //<-- These values are for the FIFO
)
// --Inputs and Outputs
(
    input clk,
    output tx
);
    
    // Logic to calculate Fibonacci Sequence
    // Logic to calculate Fibonacci Sequence
    reg [WORDLENGTH - 1 : 0] index = 0;     // Initialize Index to 0
    reg [WORDLENGTH - 1 : 0] i_end = N;     // Ending index of sequence
    
    // Initial value is set to 0
    reg [WORDLENGTH - 1 : 0] fn_0 = 0;      //<-- This represents f(n-2)
    
    // Initial value is set to 1
    reg [WORDLENGTH - 1 : 0] fn_1 = 1;      //<-- This represents f(n-1)
    
    // current vaue being calculated register
    reg [WORDLENGTH - 1 : 0] fn;            //<-- This represents f(n)
    
    
    always @ ( posedge clk )
    begin
        if( index < N ) begin index <= index + 1; end
        if( index > 1 && index < N )
        begin
            fn_0 <= fn_1;
            fn_1 <= fn;
        end
    end
    
    
    always @ (*)
    begin
        if( index == 0 ) begin fn <= fn_0; end
        else if( index == 1 ) begin fn <= fn_1; end
        else if( index < N )
        begin
            fn <= fn_0 + fn_1;
        end
    end
    // <----END---->
    // <----END---->
    
    
    
    // Nets used for instantiated modules
    wire empty; //<--- Is it empty?
    wire full;  //<--- Is it full?
    
    reg read = 0;
    reg write = 0;
    wire [WORDLENGTH - 1 : 0] datain = fn;
    wire [WORDLENGTH - 1 : 0] dataout;
    
    // Instantiate FIFO Module
    fifo # ( .WORDLENGTH(64), .MEMDEPTH(MEMDEPTH), .MEMDEPTHBITS(MEMDEPTHBITS) )
    
        myfifo( .clk(clk), .read(read), .write(write), .datain(datain), .empty(empty), .full(full), .dataout(dataout) );
    
    
    // Combinational Logic for storing data into the FIFO
    always @ (*)
    begin
        if( !full ) write <= 1;
        else write <= 0;
    end
    
    
    
    
    
    
    
endmodule

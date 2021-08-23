`timescale 1ns / 1ps

module fifo #
// --Parameters
(
    parameter
    WORDLENGTH = 64,
    MEMDEPTH = 32,  //<-- Ensure this is a power of 2 for proper usage
    MEMDEPTHBITS = $clog2(MEMDEPTH)
)
// --Inputs and Outputs
(
    input  clk, read, write,
    input [WORDLENGTH - 1 : 0] datain,
    
    output  empty, full,
    output reg [WORDLENGTH - 1 : 0] dataout
);
    
    reg [WORDLENGTH - 1 : 0] fifo_mem [0 : MEMDEPTH - 1];
    
    initial begin $readmemh("fifoinit.mem", fifo_mem); end
    
    
    
    reg [MEMDEPTHBITS - 1 : 0] count = 0;
    reg [MEMDEPTHBITS - 1 : 0] readcounter = 0;
    reg [MEMDEPTHBITS - 1 : 0] writecounter = 0;
    
    
    
    assign empty = (count == 0) ? 1'b1 : 1'b0;
    
    assign full = (count == (MEMDEPTH - 1) ) ? 1'b1 : 1'b0;
    
    
    
    always @ (posedge clk)
    begin
        if( read == 1'b1 && count != 0 )
        begin
            dataout = fifo_mem[readcounter];
            readcounter = readcounter + 1;
        end
        else if( write == 1'b1 && count < (MEMDEPTH - 1) )
        begin
            fifo_mem[writecounter] = datain;
            writecounter = writecounter + 1;
        end
        else;
        
        
        if( writecounter == (MEMDEPTH - 1) )
            writecounter = 0;
        else if( readcounter == (MEMDEPTH - 1) )
            readcounter = 0;
        else;
        
        
        if( readcounter > writecounter )
        begin
            count = readcounter - writecounter;
        end
        else if( writecounter > readcounter )
            count = writecounter - readcounter;
        else;
    end
endmodule

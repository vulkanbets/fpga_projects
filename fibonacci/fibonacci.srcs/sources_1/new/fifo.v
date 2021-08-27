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
    input  clk, read_enable, write_enable,
    input [WORDLENGTH - 1 : 0] datain,
    
    output  is_empty, is_full,
    output reg [WORDLENGTH - 1 : 0] dataout
);
    
    // Initialize FIFO Memory
    reg [WORDLENGTH - 1 : 0] fifo_mem [0 : MEMDEPTH - 1];
    
    initial begin $readmemh("fifoinit.mem", fifo_mem); end
    // Initialize FIFO Memory
    
    
    // Empty and Full Logic
    reg [MEMDEPTHBITS - 1 : 0] read_ptr = 0;
    reg [MEMDEPTHBITS - 1 : 0] write_ptr = 0;
    
    
    reg [MEMDEPTHBITS : 0] fifo_cnt = 0;
    
    assign is_empty = ( fifo_cnt == 0 );
    assign is_full = ( fifo_cnt == MEMDEPTH );
    // Empty and Full Logic
    
    
    // Write and Read Logic
    always @ ( posedge clk )
    begin
        if( write_enable && !is_full )
            fifo_mem[write_ptr] <= datain;
        else if( write_enable && read_enable )
            fifo_mem[write_ptr] <= datain;
    end
    
    
    always @ ( posedge clk )
    begin
        if( read_enable && !is_empty )
            dataout <= fifo_mem[read_ptr];
        else if( read_enable && write_enable )
            dataout <= fifo_mem[read_ptr];
    end
    // Write and Read Logic
    
    
    // Pointer Logic
    always @ ( posedge clk )
    begin
        write_ptr <= ( (write_enable && !is_full) || (write_enable && read_enable) ) ? (write_ptr + 1) : write_ptr;
        read_ptr  <= ( (read_enable && !is_empty) || (write_enable && read_enable) ) ? (read_ptr + 1) : read_ptr;
    end
    // Pointer Logic
    
    
    // Counter Logic
    always @ ( posedge clk )
    begin
        case ({write_enable , read_enable})
            2'b00  : fifo_cnt <= fifo_cnt;
            2'b01  : fifo_cnt <= (fifo_cnt==0) ? 0 : (fifo_cnt - 1);
            2'b10  : fifo_cnt <= (fifo_cnt==MEMDEPTH) ? MEMDEPTH : (fifo_cnt + 1);
            2'b11  : fifo_cnt <= fifo_cnt;
            default: fifo_cnt <= fifo_cnt;
        endcase
    end
    // Counter Logic
    
    
endmodule

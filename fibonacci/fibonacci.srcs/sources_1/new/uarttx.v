`timescale 1ns / 1ps


module uarttx #
// --Parameters
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 100 MHz Clock, 115200 baud UART
// (100000000)/(115200) = (868 - 1)
(
    parameter
    DELAY_TIMER = $clog2(50000000),                 // <-- This is for the delay wait time between display
    CLKS_PER_BIT = 868 - 1,                         // 
    BAUD_COUNTER_SIZE = $clog2(CLKS_PER_BIT),       // 
    DATA_WIDTH = 8,                                 // 
    DATA_COUNTER_SIZE = $clog2(DATA_WIDTH + 2)      // <--  This accounts for the start-bit and the stop-bit
)
// --Inputs and Outputs
(
    input clk,
    output reg tx
);
    
    reg [BAUD_COUNTER_SIZE - 1 : 0] baud_counter = 0;   // # of clock ticks for 1 bit of data
    reg [DATA_COUNTER_SIZE - 1 : 0] bits_counter = 0;   // Number of bits sent serially in 1 Frame of data
    
    
    //<--- Local Parameters --->
    localparam [7 : 0] carriage_return = 8'h0D;         // \r  ascii = 0D;
    localparam [7 : 0] new_line = 8'h0A;                // \n  ascii = 0A;
    
    
    // Transmitter Logic
    always @ ( posedge clk )
    begin
        // Clock dividers and Datapath to transmit
        // the correct bits at the correct baud
        if( baud_counter < CLKS_PER_BIT )
        begin
            baud_counter <= baud_counter + 1;
        end
        else
        begin
            baud_counter <= 0;
            if( bits_counter < (DATA_WIDTH + 2 - 1) ) // <--- Length of transmit data (10-bits)
            begin
                bits_counter <= bits_counter + 1;
            end
            else
            begin
                bits_counter <= 0;
            end
        end
    end
    
    
    // Combinational Logic to determine which bits of the frame to transmit
    always @(*)
    begin
        if( bits_counter == 0 )
            tx <=  0;
        else if( bits_counter == 9 )
            tx <=  1;
        else
            tx <= 0;    // <---Put data to be transmitted here
    end
    
    
    
    
    
endmodule

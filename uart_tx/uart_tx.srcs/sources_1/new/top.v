`timescale 1ns / 1ps

module top #
// --Parameters
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 100 MHz Clock, 115200 baud UART
// (100000000)/(115200) = 868
(
    parameter
    DELAY_TIMER = $clog2(100000000),                // <-- This is for the delay wait time between display
    CLKS_PER_BIT = 868,                             // 
    BAUD_COUNTER_SIZE = $clog2(CLKS_PER_BIT),       // 
    ROM_ADDR_WIDTH = 4,                             // 
    ROM_DATA_WIDTH = 8,                             // 
    DATA_COUNTER_SIZE = $clog2(ROM_DATA_WIDTH + 2)  // <--  This accounts for the start-bit and the stop-bit
)
// --Inputs and Outputs
(
    input clk,
    output reg tx
);
    
    wire [ROM_DATA_WIDTH - 1 : 0] rom_out;                  // 
    reg [DELAY_TIMER - 1 : 0] transmit_timer = 75999999;    // Amount of time before flipping transmit bit
    reg [BAUD_COUNTER_SIZE - 1 : 0] baud_counter = 0;       // # of clock ticks for 1 bit of data
    reg [DATA_COUNTER_SIZE - 1 : 0] bits_counter = 0;       // Number of bits sent serially in 1 Frame of data
    reg [ROM_ADDR_WIDTH - 1 : 0] rom_addr_in = 0;           // rom address coming in
    
    
    
    // Receiver Logic
    rom # ( .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH), .ROM_DATA_WIDTH(ROM_DATA_WIDTH) )
    rom_uart( .clk(clk), .addr(rom_addr_in), .data(rom_out) );
    
    
        
    
    
    // Transmitter Logic
    always @ ( posedge clk )
    begin
        if( transmit_timer > 0 ) transmit_timer <= transmit_timer - 1;
        else
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
                if( bits_counter < (ROM_DATA_WIDTH + 2 - 1) ) // <--- Length of transmit data (10-bits)
                begin
                    bits_counter <= bits_counter + 1;
                end
                else
                begin
                    bits_counter <= 0;
                    // Increment Rom address
                    if( rom_addr_in < 13 )
                    begin
                        rom_addr_in <= rom_addr_in + 1;
                    end
                    else
                    begin
                        rom_addr_in <= 0;
                        transmit_timer <= 65999999;
                    end
                end
            end
        end
    end
    
    
    // Combinational Logic to determine which bits of the frame to transmit
    always @(*)
    begin
        if( transmit_timer == 0 )
            if( bits_counter == 0 )
                tx <=  0;
            else if( bits_counter == 9 )
                tx <=  1;
            else
                tx <= rom_out[bits_counter - 1];
        else
            begin tx <=  1; end
    end
    
endmodule

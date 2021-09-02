`timescale 1ns / 1ps


module spi_master
(
    input clk,                      // 
    input transmit_ready,           // 
    input [11 : 0] mem_in,          // 
    output dac7750_sclk,            // 
    output reg transmit_done,       // 
    output reg dac7750_latch,       // 
    output reg dac7750_din          // 
);
    
    // Local Parameters
    localparam [7 : 0] address = 8'h01; // <--- This never changes
    
    reg clock_divider = 0;
    
    reg [19 : 0] data_in = 0;
    
    
    // Counter for transmitting bits to the DIN port of DAC
    reg [4 : 0] transmit_counter = 19;
    
    
    
    // Initialization of variables
    initial
    begin
        dac7750_latch <= 0;
        dac7750_din <= 0;
        transmit_done <= 0;
    end
    
    
    always @ ( posedge clk )
    begin
        clock_divider <= ~clock_divider;
        if( transmit_counter == 18 ) transmit_done <= 1;
        else transmit_done <= 0;
    end
    
    
     
    always @ ( negedge clk )
    begin
        if( transmit_ready && transmit_counter == 19 )
        begin
            data_in <= { address, mem_in };
            transmit_counter <= 0;
        end
        else if( transmit_ready )
        begin
            data_in <= data_in << 1;
            transmit_counter <= transmit_counter + 1;
        end
    end
    
    
    assign dac7750_sclk = transmit_ready ? clock_divider : 0;
    
endmodule

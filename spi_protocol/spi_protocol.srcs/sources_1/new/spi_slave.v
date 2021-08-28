`timescale 1ns / 1ps


module spi_slave
(
    input clk,              // Internal FPGA clock
    input ads7038_cs,       // Chip Select from ADC
    input ads7038_sclk,     // serial clock coming from ADC
    input ads7038_sdo,      // ADC Serial Data out
    output reg ads7038_sdi  // ADC Serial Data in
);
    
    // Serial Data In Variables
    reg [1 : 0] config_reg = 0;     // This bit is set when all the configuration details have been sent to the chip
    reg [4 : 0] frame_counter = 0;  // counts from 0 to 23 for each data frame sent serially
    reg [23 : 0] data_frame = 0;    // Data to be sent serially over wire
    
    // Initialize Serial Data In (SDI)
    initial ads7038_sdi <= 0;
    
    // Serial Data Out Variables
    reg [11 : 0] memory [0 : 1];
    
    // Initialize Memory
    integer i;
    initial for( i = 0; i < 2; i = i + 1 ) memory[i] = 0;
    
    // Serial Data Logic
    //////////////////////////////////////////////////////////////
    always @ ( negedge ads7038_cs )
    begin
        if( config_reg == 0 ) data_frame <= 24'b11111111_00000101_00001000; // <-- Configure Pins as Analog In
        
        else data_frame <= 24'b00000000_00010001_00001000;                  // <-- Use AIN0 as input to ADC
    end
    //////////////////////////////////////////////////////////////
    
    
    
    //////////////////////////////////////////////////////////////
    always @ ( posedge ads7038_sclk )
    begin
        if( frame_counter < 11 || ( frame_counter < 23 && config_reg < 2 ) ) frame_counter <= frame_counter + 1;
        else
        begin
            frame_counter <= 0;
            if( config_reg < 2 ) config_reg <= config_reg + 1;
        end
        
        if( config_reg >= 2 ) memory[0][11] <= ads7038_sdo;
        
    end
    //////////////////////////////////////////////////////////////
    
    
    
    //////////////////////////////////////////////////////////////
    always @ ( negedge ads7038_sclk )
    begin
        if( config_reg < 2 ) data_frame = data_frame >> 1;
        else data_frame <= 0;
        
        if( config_reg >= 2 && frame_counter == 0 )
        begin
            memory[1] <= memory[0];
        end
        else memory[0] <= memory[0] >> 1;
        
    end
    //////////////////////////////////////////////////////////////
    
    
    
    //////////////////////////////////////////////////////////////
    always @ ( * )
    begin
        if( !ads7038_cs ) ads7038_sdi <= data_frame[0];
    end
    //////////////////////////////////////////////////////////////
    // Serial Data Logic
    
    
endmodule

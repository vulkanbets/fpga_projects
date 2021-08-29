`timescale 1ns / 1ps


module top
(
    // I/O for the ADC
    input clk,              // Internal FPGA clock           <--- This is all for the ADC ADS7038
    input ads7038_cs,       // Chip Select from ADC          <--- This is all for the ADC ADS7038
    input ads7038_sclk,     // serial clock coming from ADC  <--- This is all for the ADC ADS7038
    input ads7038_sdo,      // ADC Serial Data out           <--- This is all for the ADC ADS7038
    output ads7038_sdi,     // ADC Serial Data in            <--- This is all for the ADC ADS7038
    output transmit_ready   // transmit ready signal         <--- This is all for the ADC ADS7038
    
    // I/O for the DAC
    
);
    
    spi_slave  spi_in
    (
        .clk(clk),
        .ads7038_cs(ads7038_cs),
        .ads7038_sclk(ads7038_sclk),
        .ads7038_sdo(ads7038_sdo),
        .ads7038_sdi(ads7038_sdi),
        .transmit_ready(transmit_ready)
    );
    
    
    
    spi_master spi_out
    (
        .clk(clk),
        .transmit_ready(transmit_ready),
        .dac7750_sclk(dac7750_sclk),
        .dac7750_latch(dac7750_latch),
        .dac7750_din(dac7750_din),
        .dac7750_transmit_done(dac7750_transmit_done)
    )
    
    
    
    
    
    
endmodule

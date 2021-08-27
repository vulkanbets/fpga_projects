`timescale 1ns / 1ps


module top
(
    input clk,              // Internal FPGA clock           <--- This is all for the ADC ADS7038
    input ads7038_cs,       // Chip Select from ADC          <--- This is all for the ADC ADS7038
    input ads7038_sclk,     // serial clock coming from ADC  <--- This is all for the ADC ADS7038
    input ads7038_sdo,      // ADC Serial Data out           <--- This is all for the ADC ADS7038
    output ads7038_sdi      // ADC Serial Data in            <--- This is all for the ADC ADS7038
);
    
    spi_slave  spi_in
    (
        .clk(clk),
        .ads7038_cs(ads7038_cs),
        .ads7038_sclk(ads7038_sclk),
        .ads7038_sdo(ads7038_sdo),
        .ads7038_sdi(ads7038_sdi)
    );
    
    
endmodule

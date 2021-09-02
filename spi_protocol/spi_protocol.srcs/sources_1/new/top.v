`timescale 1ns / 1ps


module top
(
    // I/O for the ADC
    input clk,              // Internal FPGA clock          <--- This is all for the ADC ADS7038
    input ads7038_cs,       // Chip Select from ADC         <--- This is all for the ADC ADS7038
    input ads7038_sclk,     // serial clock coming from ADC <--- This is all for the ADC ADS7038
    input ads7038_sdo,      // ADC Serial Data out          <--- This is all for the ADC ADS7038
    output ads7038_sdi,     // ADC Serial Data in           <--- This is all for the ADC ADS7038
    output transmit_ready,  // transmit ready signal        <--- This is all for the ADC ADS7038
    
    // I/O for the DAC
    output dac7750_sclk,    //                              <--- This is all for the DAC DAC7750
    output dac7750_latch,   //                              <--- This is all for the DAC DAC7750
    output dac7750_din      //                              <--- This is all for the DAC DAC7750
);
    
    
    wire [11 : 0] memory; // <--- 12-bit Bus
    wire transmit_done;   // 
    
    
    spi_slave  spi_in
    (
        .clk(clk),
        .ads7038_cs(ads7038_cs),
        .ads7038_sclk(ads7038_sclk),
        .ads7038_sdo(ads7038_sdo),
        .ads7038_sdi(ads7038_sdi),
        .mem_out(memory),
        .transmit_ready(transmit_ready)
    );
    
    
    
    spi_master spi_out
    (
        .clk(clk),
        .transmit_ready(transmit_ready),
        .mem_in(memory),
        .dac7750_sclk(dac7750_sclk),
        .dac7750_latch(dac7750_latch),
        .dac7750_din(dac7750_din)
    );
    
    
    
    
    
    
endmodule

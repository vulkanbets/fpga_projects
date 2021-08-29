`timescale 1ns / 1ps


module spi_testbench;
    
    // Inputs
    reg clk;
    reg ads7038_cs;
    reg ads7038_sclk;
    reg ads7038_sdo = 1;
    reg alternating_bit = 0;
    
    // Outputs
    wire ads7038_sdi;
    wire transmit_ready;
    
    
    // Unit under test (UUT)
    top uut
    (
        .clk(clk),
        .ads7038_cs(ads7038_cs),
        .ads7038_sclk(ads7038_sclk),
        .ads7038_sdo(ads7038_sdo),
        .ads7038_sdi(ads7038_sdi),
        .transmit_ready(transmit_ready)
    );
    
    
    // Clock generation
    always #1 clk <= ~clk;
    
    always #4 if(!ads7038_cs) ads7038_sclk <= ~ads7038_sclk; else ads7038_sclk <= 0;
    
    
    // Chip Select Simulation
    integer i;
    initial
    begin
        for( i = 30; i < 500; i = i + 1 )
        begin
            if( i < 32 )
            begin
                #(i) ads7038_cs <= ~ads7038_cs;
                #(i+158) ads7038_cs <= ~ads7038_cs;
            end
            else
            begin
                #(i) ads7038_cs <= ~ads7038_cs;
                #(i+60) ads7038_cs <= ~ads7038_cs;
            end
            alternating_bit <= ~alternating_bit;
        end
    end
    
    always @ ( negedge ads7038_sclk )
    begin
        if( top.spi_in.config_reg >= 2 && !alternating_bit ) ads7038_sdo <= ~ads7038_sdo;
        else ads7038_sdo <= 1;
    end
    
    initial
    begin
        clk <= 0;
        ads7038_cs <= 1;
        ads7038_sclk <= 0;
    end
    
endmodule

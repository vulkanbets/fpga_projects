`timescale 1ns / 1ns
`include "barrel.v"

module barrelshifter_tb;

    // Instantiate DUT
    barrelshifter DUT();

    initial
    begin
        $dumpfile("barrel_tb.vcd");
        // $dumpvars(0, barrel_tb);



        $display("Test Complete");

    end



endmodule

`timescale 1ns / 1ps

module top
(
    input clk,  // 
    output out  // 
);
    reg [3:0] counter = 0;   // Counter for clock divider
    reg baud_clk = 0;        // 
    
    // 
    always @ (posedge clk)
    begin
        if(counter < 9) begin counter <= counter + 1; end
        
        else
        begin
            counter <= 0;
            baud_clk <= ~baud_clk;
        end
    end
    
    
    
endmodule

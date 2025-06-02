`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2025 07:05:57
// Design Name: 
// Module Name: CPU_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_TB();

    reg clk = 0;
    reg reset = 1;

    CPU uut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin 
        // Hold reset for a few cycles
        #10 reset = 0;
        $display("---------------------------------------------------------------------------------------------------------------");
        // Run the CPU for a few clock cycles
        #100;

        $display("CPU simulation done.");
        $display("---------------------------------------------------------------------------------------------------------------");
        $finish;
    end
endmodule

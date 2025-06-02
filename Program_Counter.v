`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 21:18:25
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input clk,
    input reset,
    output reg [15:0] pc
    );
    always@(posedge clk or posedge reset)begin
        if(reset)
            pc <= 16'b0;
        else
            pc <= pc + 1;
    end
endmodule

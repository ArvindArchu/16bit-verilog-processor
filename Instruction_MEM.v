`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 19:26:02
// Design Name: 
// Module Name: Instruction_MEM
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

//program will be stored in this location
module Instruction_MEM(
    input [15:0] address,
    output reg [15:0] inst
    );

    reg [15:0] mem [0:255];
    //insert program here
    initial begin
        // MOV R1, #5
        mem[0] = 16'b0000_000_101_001_1_00; 
        // MOV R2, #3
        mem[1] = 16'b0000_000_011_010_1_00;
        // ADD R3,R1,R2
        mem[3] = 16'b0000_001_010_011_0_00;        
    end
    always@(*) begin
        inst = mem[address];
    end
endmodule

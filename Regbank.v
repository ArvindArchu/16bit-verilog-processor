`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 08:17:08
// Design Name: 
// Module Name: Regbank
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


module Regbank(
    input clk,write,reset,
    input [2:0]sr1,sr2,dr,
    input [15:0]wrData,
    output wire [15:0]rdData1,rdData2
    );
    integer k;
    reg [15:0] regfile [0:7];

    assign rdData1 = regfile[sr1];  
    assign rdData2 = regfile[sr2];

    always @(posedge clk) begin
        $display("R0 = %h, R1 = %h, R2 = %h, R3 = %h ,R4 = %h ,R5 = %h ,R6 = %h ,R7 = %h", regfile[0], regfile[1], regfile[2],regfile[3],regfile[4],regfile[5],regfile[6],regfile[7]);
        if (reset) begin
            for (k = 0;k<8 ;k=k+1 ) begin
                regfile[k] <= 0;
            end
        end
        else begin
            if(write && dr != 3'b000)
                    regfile[dr] <= wrData;
        end
    end
endmodule

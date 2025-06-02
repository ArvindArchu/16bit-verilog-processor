`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 08:36:55
// Design Name: 
// Module Name: Regbank_TB
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


module Regbank_TB();
    reg clk,write,reset;
    reg [2:0]sr1,sr2,dr;
    reg [15:0]wrData;
    wire [15:0]rdData1,rdData2;
    integer k;

    Regbank uut(.clk(clk),
                .write(write),
                .reset(reset),
                .sr1(sr1),
                .sr2(sr2),
                .dr(dr),
                .wrData(wrData),
                .rdData1(rdData1),
                .rdData2(rdData2));

    initial clk = 0;
    always #5 clk = !clk;

    initial
        begin
            #1 reset = 1; write =0;
            #5 reset = 0;
            #7 for(k=0;k<8;k=k+1)begin
                dr = k; wrData = k*10; write = 1;
                #10 write = 0;
            end
            #20
            for(k=0;k<8;k=k+2)begin
                sr1 = k;sr2 = k+1;
                #5;
                $display("reg[%2d] = %d, reg[%2d] = %d",sr1,rdData1,sr2,rdData2);
            end
            #20 $finish;
        end
endmodule

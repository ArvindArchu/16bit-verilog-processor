`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 19:07:31
// Design Name: 
// Module Name: ALU_TB
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


module ALU_TB();
    reg [15:0]A;
    reg [15:0]B;
    reg [3:0]opcode;
    wire [15:0]result;
    wire Z,C,N,O;

    ALU uut(.A(A),
            .B(B),
            .result(result),
            .opcode(opcode),
            .Z(Z),
            .C(C),
            .O(O),
            .N(N));
    initial begin
        $display("ALU TB");
        A = 16'h05;B = 16'h03;opcode = 4'b0000; #10;
        $display("Add: %h",result);
        opcode = 4'b0001; #10;
        $display("Sub: %h",result);
        A = 16'b01;B = 16'b11;opcode = 4'b0010; #10;
        A = 16'b01;B = 16'b11;opcode = 4'b0011; #10;
        A = 16'b01;B = 16'b11;opcode = 4'b0100; #10;
        A = 16'b1010;opcode = 4'b0101; #10;//NOT
        A = 16'b1010;opcode = 4'b0110; #10;
        A = 16'b1010;opcode = 4'b0111; #10;
        $finish;
    end
endmodule

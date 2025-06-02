`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 17:40:48
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [15:0]A,
    input [15:0]B,
    input [3:0]opcode,
    output reg [15:0]result,
    output Z,N,O,
    output reg C
    );
    reg C;
    always@(*)begin
        $display("ALU: A=%h, B=%h, opcode=%b => result=%h", A, B, opcode, result);
        case(opcode)
            4'b0000: {C,result} = {1'b0,A}+{1'b0,B};      //ADD
            4'b0001: {C,result} = {1'b0,A}-{1'b0,B};      //SUB
            4'b0010: result = A&B;      //AND
            4'b0011: result = A|B;      //OR
            4'b0100: result = A^B;      //XOR
            4'b0101: result = ~A;       //NOT
            4'b0110: result = A<<1;     //LEFT SHIFT
            4'b0111: result = A>>1;     //RIGHT SHIFT
            default: result = 16'b0;    //NOP
        endcase
    end
    assign Z = (result==16'b0)?1:0;
    assign N = result[15];
    assign O = (A[15]&B[15]&~result[15])|(~A[15]&~B[15]&result[15]);
endmodule
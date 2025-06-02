`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 18:37:36
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clk,reset
    );

    wire [15:0] PC;               //program counter

    wire [15:0] inst;               //instruction memory

    //decoding inst fields
    wire [3:0] opcode       = inst[15:12];
    wire [2:0] sr1          = inst[11:9];
    wire [2:0] sr2          = inst[8:6];
    wire [2:0] dr           = inst[5:3];
    wire       imm_flag     = inst[2];      //imm flag is used to directly use 
    wire [2:0] imm_val      = inst[8:6];    //numbers instead of registers

    wire [15:0] A, reg_data2;
    wire [15:0] B = imm_flag ? {13'b0,imm_val}:reg_data2; // check for imm flag
    wire [15:0] result;
    wire Z,C,N,O;

    Program_Counter pc(
        .clk(clk),
        .reset(reset),
        .pc(PC)
    );

    Instruction_MEM IM(
        .address(PC),
        .inst(inst)
    );

    Regbank regfile(
        .clk(clk),
        .write(1),
        .reset(reset),
        .sr1(sr1),
        .sr2(sr2),
        .dr(dr),
        .wrData(result),
        .rdData1(A),
        .rdData2(reg_data2)
    );

    ALU alu(
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .Z(Z),.C(C),.N(N),.O(O)
    );

endmodule

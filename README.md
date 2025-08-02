16 Bit CPU Documentation

1.	Instruction format

 
-	Opcode: 4 bits — operation type (e.g., ADD, SUB, LOAD, STORE)
-	SR1: Source Register 1 (used for operands or address
-	SR2: Source Register 2 (used for second operand or data in store)
-	DR: Destination Register (target of result in ALU or loaded value)
-	Imm: Immediate value flag, use value in SR2 directly instead of registers
1.  //decoding inst fields
2.     wire [3:0] opcode       = inst[15:12];
3.     wire [2:0] sr1          = inst[11:9];
4.     wire [2:0] sr2          = inst[8:6];
5.     wire [2:0] dr           = inst[5:3];
6.     wire       imm_flag     = inst[2];      //imm flag is used to directly use 
7.     wire [2:0] imm_val      = inst[8:6];    //numbers instead of registers

Opcode : 
These are the opcodes defined in ALU for arithmetic and logical operations
 1. case(opcode)
 2.             4'b0000: {C,result} = {1'b0,A}+{1'b0,B};      //ADD
 3.             4'b0001: {C,result} = {1'b0,A}-{1'b0,B};      //SUB
 4.             4'b0010: result = A&B;      //AND
 5.             4'b0011: result = A|B;      //OR
 6.             4'b0100: result = A^B;      //XOR
 7.             4'b0101: result = ~A;       //NOT
 8.             4'b0110: result = A<<1;     //LEFT SHIFT
 9.             4'b0111: result = A>>1;     //RIGHT SHIFT
10.             default: result = 16'b0;    //NOP
11.         endcase
Apart from these two more opcodes are defined in CPU for load and store operations :
1. wire is_load = (opcode == 4'b0100);
2. wire is_store = (opcode == 4'b0101); 

Sr1,sr2,dr:
3 bit variables are used to point to the required register, so giving sr1 a value of 011 (3’d) would mean we are accessing the third index i.e register R3. More on this is explained in the register bank section.

2.	ALU
The ALU performs basic arithmetic and logical operations, it takes in two registers A,B and the opcode and outputs the result along with the zero, negative, overflow and carry flag. Carry flag is defined as register since we embed it in the addition operation to directly assign it a value.
The ALU operations have been listed in the opcodes.
1. module ALU(
2.     input [15:0]A,
3.     input [15:0]B,
4.     input [3:0]opcode,
5.     output reg [15:0]result,
6.     output Z,N,O,
7.     output reg C
8.     ); 

3.	Register Bank
The register bank consists of 8 registers of length 16 bits. Register read and write operations are performed in this module. This module is also used to extract register value required for load and store operations.

It takes input clk, write flag and reset flag along with sr1,sr2 and dr values for read and write operations. The module can perform two reads and one write.
It outputs rdData1 and rdData2 which are the read values.
1. module Regbank(
2.     input clk,write,reset,
3.     input [2:0]sr1,sr2,dr,
4.     input [15:0]wrData,
5.     output wire [15:0]rdData1,rdData2
6.     );
8.     reg [15:0] regfile [0:7]; 
The “reg” variable is a vector of length 8 where each element in turn is a vector of length 16 i.e R0,R1,R2,R3,R4,R5,R6,R7.
For read and write operations we index the “regfile” variable to access each individual registers. 
Index value	Register
000	R0
001	R1
010	R2
011	R3
100	R4
101	R5
110	R6
111	R7



Write and reset operation:
The write operation checks if write is required and if the directory is not register R0 and it is reserved for other operations. According to RISC-V ISA R0 is hardwired to 0 and any write operations to it are ignored.
 1. always @(posedge clk) begin
 3. 	if (reset) begin
 4.         for (k = 0;k<8 ;k=k+1 ) begin
 5. 		regfile[k] <= 0;
 6.         end
 7.     end
 8.     else begin
 9.         if(write && dr != 3'b000)//register writeback except R0
10.		regfile[dr] <= wrData;//write wrData into register 'dr'
11.     end                               
12.end

4.	Instruction Memory
The instruction memory stores the program to be executed, in the current CPU model the program has to be manually written in instruction format specified in section 1 . The instruction memory is 256 words wide.
1. module Instruction_MEM(
2.     input [15:0] address_I,
3.     output reg [15:0] inst
4.     );
 It takes in input address_I which is the address at which next instruction is located and outputs the instruction as 16bit instruction format.
Example program: 
 1.         // MOV R1, #5
 2.         mem[0] = 16'b0000_000_101_001_1_00; 
 3.         // MOV R2, #3
 4.         mem[1] = 16'b0000_000_011_010_1_00;
 5.         // ADD R3,R1,R2
 6.         mem[3] = 16'b0000_001_010_011_0_00;  
 7.         // STORE R1, [R2]
 8.         mem[4] = 16'b0101_010_001_000_0_00;
 9.         // STORE R3, [R1]
10.         mem[5] = 16'b0100_011_100_000_0_00;   
11.         // LOAD R4, [R3]
12.         mem[6] = 16'b0100_011_xxx_100_0_00;

5.	Program Counter
Program counter increments the address_I which points to instruction memory every clock cycle. It also sets this value to 0 on reset. This module will be crucial when jumps and branches are implemented.
1. module Program_Counter(
2.     input clk,
3.     input reset,
4.     output reg [15:0] pc
5.     );




6.	Data Memory
Implements a 256 words synchronous data memory which supports load/store operations. It takes in clock, write_en flag, read address and write data as inputs and outputs the 16bit data read from memory. The write flag is used to indicate load operation, in which case the write_DAT value is written to the address passed into the module. The load operations happen on posedge of clock while store operations are independent of the clock
1. module Data_MEM(
2.     input clk,
3.     input write_en,
4.     input [15:0] address,
5.     input [15:0] write_DAT,
6.     output [15:0] read_DAT
7.     );
a
7.	Load Instruction
LDR rd, [rs] 
Load a value from memory address stored in rs into register rd.
Eg: LDR R1, [R3] //assume R3 = 4b’0101 – value 5

Instruction encoding: 
1. Opcode = 4'b0001
2. [15:12] 0001      → LOAD
3. [11:9]  011       → R3 (source reg, holds address)
4. [8:6]   001       → R1 (destination reg, loaded with mem data)
5. [5:0]   000000    → Unused
Execution flow:
1.	Instruction decoding:
a.	sr1 = rs ->read address register(R3)
b.	dr = rd-> destination register(R1)
2.	Register bank access:
a.	Output rdData1(i.e A) gets value of R3 -> used as memory address pointer
3.	Data memory read:
a.	data_mem_out = mem[A] (A holds address from R3 i.e value of R3)
4.	Write back:
a.	Write data_mem_out into register rd (R1)

8.	Store Instruction
STR [rd], rs
Store a value from register rs into memory address pointed by value in rd
Eg: STR [R1], R3

Instruction encoding:
1. Opcode = 4'b0010
2. [15:12] 0010      → STORE
3. [11:9]  001       → R1 (address reg)
4. [8:6]   011       → R3 (value to be stored)
5. [5:0]   000000    → Unused
Execution flow:
1.	Instruction decode:
a.	sr1 = rd -> holds memory address (goes to A)
b.	sr2 = rs -> holds value to store goes into reg_data2
2.	Register Bank Access:
a.	A = reg[rd] → address
b.	reg_data2 = reg[rs] → data
3.	Data Memory Write:
a.	mem[A] <= reg_data2 only if write_en is active and opcode is STORE

9.	CPU
The CPU is the top module that integrates all these modules and executes the program in instruction memory module. The only inputs to this module are the clk and reset. It drives the entire datapath.
________________________________________
Key Responsibilities:
1.	Instruction Fetch: Reads instructions sequentially from the Instruction Memory module using the Program Counter.
2.	Instruction Decode: Extracts fields such as opcode, source/destination registers, and immediate flags.
3.	Control Logic:
a.	Decides whether an instruction uses immediate values or register operands.
b.	Detects load and store operations.
c.	Controls data path direction for memory access and ALU operations.
4.	Register File Access:
a.	Reads register values based on decoded instruction fields (sr1, sr2).
b.	Writes back results to destination register (dr) unless it's register R0 (which is reserved).
5.	ALU Operations: Executes arithmetic or logical operations based on the opcode.
6.	Memory Access:
a.	For store, it sends data from the register file to the Data_MEM module at the address specified by a register.
b.	For load, it fetches data from memory and writes it back to the destination register.
7.	Write-Back: Stores the final result (from ALU or memory) back to the appropriate register.

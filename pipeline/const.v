// ======= Register =======
`define REG_ADDR_WIDTH 5
`define REG_DATA_WIDTH 32
`define REG_SIZE 32

// ======= Control =======
`define OPCODE 6:0
// R-Type
`define RD 11:7
`define FUNCT3 14:12
`define RS1 19:15
`define RS2 24:20
`define FUNCT7 31:25
// I-Type
`define I_imm 31:20
// B-Type
`define B_imm_1 11:8
`define B_imm_2 30:25
`define B_imm_3 7
`define B_imm_4 31
// J-Type
`define J_imm_1 30:21
`define J_imm_2 20
`define J_imm_3 19:12
`define J_imm_4 31
// S-Type
`define S_imm_1 11:7
`define S_imm_2 31:25


`define OPCODE_WIDTH 7
// add sub and or xor sll srl
`define R_FORMAT_OPCODE 7'b0110011
// beq blt
`define B_FORMAT_OPCODE 7'b1100011
// jal
`define J_FORMAT_OPCODE 7'b1101111
// addi
`define I_addi_FORMAT_OPCODE 7'b0010011
// lw
`define I_lw_FORMAT_OPCODE 7'b0000011
// sw
`define S_FORMAT_OPCODE 7'b0100011

`define FUNCT3_WIDTH 3
`define FUNCT7_WIDTH 7

`define ADD_FUNCT3 3'h0
`define ADD_FUNCT7 7'h00
`define SUB_FUNCT3 3'h0
`define SUB_FUNCT7 7'h20
`define XOR_FUNCT3 3'h4
`define XOR_FUNCT7 7'h00
`define OR_FUNCT3 3'h6
`define OR_FUNCT7 7'h00
`define AND_FUNCT3 3'h7
`define AND_FUNCT7 7'h00
`define SLL_FUNCT3 3'h1
`define SLL_FUNCT7 7'h00
`define SRL_FUNCT3 3'h5
`define SRL_FUNCT7 7'h00

`define ADDI_FUNCT3 3'h0
`define LW_FUNCT3 3'h2

`define SW_FUNCT3 3'h2

`define BEQ_FUNCT3 3'h0
`define BLT_FUNCT3 3'h4

//======= ALU =======
`define ALU_AND 4'b0000
`define ALU_OR 4'b0001
`define ALU_ADD 4'b0010
`define ALU_SUB 4'b0011
`define ALU_NOR 4'b1100
`define ALU_LT 4'b0111
// * May be not consistent with RISK-V
`define ALU_XOR 4'b0100
`define ALU_SLL 4'b0101
`define ALU_SRL 4'b0110
`define ALU_JAL 4'b1111

`define ALU_CONTROL_WIDTH 4
`define ALU_DATA_WIDTH 32

// ======= IF =======
`define INST_ADDR_WIDTH 32
`define INST_WIDTH 32

// ======= MEM =======
`define MEM_ADDR_WIDTH 32

`include "const.v"
`include "ID/control.v"
`include "ID/register.v"
`include "ID/imm_gen.v"
`include "ID/alu_control.v"

module ID (
        input wire clk,
        input wire reset,
        input wire [`INST_WIDTH - 1:0] inst,                 // Input inst from Inst_mem, connected to inst_i
        input wire [`REG_DATA_WIDTH - 1:0]write_data,        // write_back data from Data_mem
        // ---- Control Signals ----
        output wire Branch,
        output wire MemRead,
        output wire MemtoReg,
        output wire [1:0] ALUOp,                             // TODO: Unnecessary. To be removed.
        output wire MemWrite,
        output wire ALUSrc,
        // -------------------------
        output wire [`REG_DATA_WIDTH - 1:0]read_reg_data_1,  // read data from Register
        output wire [`REG_DATA_WIDTH - 1:0]read_reg_data_2,  // read data from Register
        output wire [`REG_DATA_WIDTH - 1:0]jump,             // Jump to be used in IF
        output wire [`ALU_CONTROL_WIDTH - 1:0] ALU_ctl       // ALU control, to be used in EX
    );

    wire [`OPCODE_WIDTH - 1:0] opcode = inst [`OPCODE];

    wire RegWrite;
    wire [`REG_ADDR_WIDTH-1:0] rd = inst[`RD];
    wire [`REG_ADDR_WIDTH-1:0] rs1 = inst[`RS1];
    wire [`REG_ADDR_WIDTH-1:0] rs2 = inst[`RS2];

    control u_control (
                .inst(inst),
                .opcode(opcode),
                .Branch(Branch),
                .MemRead(MemRead),
                .MemtoReg(MemtoReg),
                .ALUOp(ALUOp),
                .MemWrite(MemWrite),
                .ALUSrc(ALUSrc),
                .RegWrite(RegWrite)
            );

    register u_register (
                 .clk(clk),
                 .reset(reset),
                 .RegWrite(RegWrite),
                 .read_reg_addr_1(rs1),
                 .read_reg_addr_2(rs2),
                 .write_reg_addr(rd),
                 .write_reg_data(write_data),
                 .read_reg_data_1(read_reg_data_1),
                 .read_reg_data_2(read_reg_data_2)
             );

    imm_gen u_imm_gen (
                .inst(inst),
                .imm(jump)
            );

    alu_control u_alu_control (
                    .ALUOp(ALUOp),
                    .inst(inst),
                    .ALU_ctl(ALU_ctl)
                );

endmodule

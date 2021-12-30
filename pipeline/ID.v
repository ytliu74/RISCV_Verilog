`include "const.v"
`include "ID/control.v"
`include "ID/register.v"
`include "ID/imm_gen.v"

module ID (
        input wire clk,
        input wire rst,
        input wire [`INST_WIDTH - 1:0] inst,                 // Input inst from IF/ID
        input wire [`REG_DATA_WIDTH - 1:0]write_data,        // write_back data from WB
        input wire [`REG_ADDR_WIDTH-1:0] rd,                 // read from IF/ID
        input wire [`REG_ADDR_WIDTH-1:0] rs1,                // read from IF/ID
        input wire [`REG_ADDR_WIDTH-1:0] rs2,                // read from IF/ID
        input wire [`OPCODE_WIDTH - 1:0] opcode,             // read from IF/ID
        // ---- Control Signals ---- ALL output to ID/EX
        output wire Branch,
        output wire MemRead,
        output wire MemtoReg,
        output wire MemWrite,
        output wire ALUSrc,
        output wire RegWrite,
        // -------------------------
        output wire [`REG_DATA_WIDTH - 1:0]read_reg_data_1,  // read data from Register
        output wire [`REG_DATA_WIDTH - 1:0]read_reg_data_2,  // read data from Register
        output wire [`REG_DATA_WIDTH - 1:0]imm               // imm, output to ID/EX
    );

    control u_control (
                .inst(inst),
                .opcode(opcode),
                .Branch(Branch),
                .MemRead(MemRead),
                .MemtoReg(MemtoReg),
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
                .imm(imm)
            );

endmodule

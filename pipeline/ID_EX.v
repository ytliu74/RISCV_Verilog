`include "const.v"

module ID_EX (
  input wire                          clk,
  input wire                          rst,
  input wire                          ID_flush,
  //  -- Control Signals --
  input wire                          Branch_in,
  input wire                          MemRead_in,
  input wire                          MemtoReg_in,
  input wire                          MemWrite_in,
  input wire                          ALUSrc_in,
  input wire                          RegWrite_in,
  //  ---------------------
  input wire [ `REG_DATA_WIDTH - 1:0] read_reg_data_1_in,  // from ID
  input wire [ `REG_DATA_WIDTH - 1:0] read_reg_data_2_in,  // from ID
  input wire [ `REG_DATA_WIDTH - 1:0] imm_in,              // from ID
  input wire [`INST_ADDR_WIDTH - 1:0] inst_addr_in,        // from IF/ID
  input wire [     `INST_WIDTH - 1:0] inst_in,             // from IF/ID
  input wire [ `REG_ADDR_WIDTH - 1:0] rd_in,               // from IF/ID
  input wire [ `REG_ADDR_WIDTH - 1:0] rs1_in,              // from IF/ID
  input wire [ `REG_ADDR_WIDTH - 1:0] rs2_in,              // from IF/ID

  output reg Branch_out,
  output reg MemRead_out,
  output reg MemtoReg_out,
  output reg MemWrite_out,
  output reg ALUSrc_out,    // used in EX
  output reg RegWrite_out,

  output reg [ `REG_DATA_WIDTH - 1:0] read_reg_data_1_out,  // output to EX
  output reg [ `REG_DATA_WIDTH - 1:0] read_reg_data_2_out,  // output to EX
  output reg [ `REG_DATA_WIDTH - 1:0] imm_out,              // output to EX
  output reg [     `INST_WIDTH - 1:0] inst_out,             // output to EX/MEM
  output reg [`INST_ADDR_WIDTH - 1:0] inst_addr_out,        // output to EX/MEM & EX(for jal)
  output reg [ `REG_ADDR_WIDTH - 1:0] rd_out,               // ID/EX.rd
  output reg [ `REG_ADDR_WIDTH - 1:0] rs1_out,              // ID/EX.rs1
  output reg [ `REG_ADDR_WIDTH - 1:0] rs2_out               // ID/EX.rs2
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Branch_out <= 0;
      MemRead_out <= 0;
      MemtoReg_out <= 0;
      MemWrite_out <= 0;
      read_reg_data_2_out <= 0;
      inst_addr_out <= 0;
      rd_out <= 0;
      rs1_out <= 0;
      rs2_out <= 0;
    end else if (ID_flush) begin
      {Branch_out, MemRead_out, MemtoReg_out, MemWrite_out, ALUSrc_out, RegWrite_out} <= 0;

      {read_reg_data_1_out, read_reg_data_2_out, imm_out,
             inst_out, inst_addr_out, rd_out, rs1_out, rs2_out} <= 0;
    end else begin
      {Branch_out, MemRead_out, MemtoReg_out, MemWrite_out, ALUSrc_out, RegWrite_out} <= {
        Branch_in, MemRead_in, MemtoReg_in, MemWrite_in, ALUSrc_in, RegWrite_in
      };

      {read_reg_data_1_out, read_reg_data_2_out, imm_out,
             inst_out, inst_addr_out, rd_out, rs1_out, rs2_out}
            <= {
        read_reg_data_1_in, read_reg_data_2_in, imm_in, inst_in, inst_addr_in, rd_in, rs1_in, rs2_in
      };
    end
  end

endmodule

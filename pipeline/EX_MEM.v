`include "const.v"

module EX_MEM (
  input wire                         clk,
  input wire                         rst,
  //  -- Control Signals --
  input wire                         MemRead_in,
  input wire                         MemtoReg_in,
  input wire                         MemWrite_in,
  input wire                         RegWrite_in,
  //  ---------------------
  input wire [`REG_DATA_WIDTH - 1:0] ALU_result_in,       // from EX
  input wire [ `REG_DATA_WIDTH -1:0] read_reg_data_2_in,  // from ID/EX
  input wire [`REG_ADDR_WIDTH - 1:0] rd_in,               // from ID/EX

  output reg MemRead_out,
  output reg MemtoReg_out,
  output reg MemWrite_out,
  output reg RegWrite_out,

  output reg [`REG_DATA_WIDTH - 1:0] ALU_result_out,       // output to MEM & MEM/WB
  output reg [ `REG_DATA_WIDTH -1:0] read_reg_data_2_out,  // output to MEM
  output reg [ `REG_ADDR_WIDTH -1:0] rd_out                // output to MEM/WB
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      MemRead_out  <= 0;
      MemtoReg_out <= 0;
      MemWrite_out <= 0;
    end else begin
      {MemRead_out, MemtoReg_out, MemWrite_out, RegWrite_out} <= {
        MemRead_in, MemtoReg_in, MemWrite_in, RegWrite_in
      };

      {ALU_result_out, read_reg_data_2_out, rd_out} <= {ALU_result_in, read_reg_data_2_in, rd_in};
    end
  end

endmodule

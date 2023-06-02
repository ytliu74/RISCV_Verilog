`include "const.v"

module MEM_WB (
  input wire                         clk,
  input wire                         rst,
  //  -- Control Signals --
  input wire                         MemtoReg_in,    // from EX/MEM
  input wire                         RegWrite_in,
  input wire                         MemRead_in,
  //  ---------------------
  input wire [`REG_DATA_WIDTH - 1:0] ALU_result_in,  // from EX/MEM
  input wire [`REG_ADDR_WIDTH - 1:0] rd_in,          // from EX/MEM
  input wire [`REG_DATA_WIDTH - 1:0] mem_data_in,    // from MEM

  output reg RegWrite_out,  // output to REG in ID
  output reg MemtoReg_out,  // output to WB
  output reg MemRead_out,   // output to FORWARDING

  output reg [`REG_DATA_WIDTH - 1:0] mem_data_out,    // output to WB
  output reg [`REG_DATA_WIDTH - 1:0] ALU_result_out,  // output to WB
  output reg [`REG_ADDR_WIDTH - 1:0] rd_out           // output to WB
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      MemtoReg_out <= 0;
      RegWrite_out <= 0;
    end else begin
      {MemtoReg_out, RegWrite_out, MemRead_out} <= {MemtoReg_in, RegWrite_in, MemRead_in};

      {mem_data_out, ALU_result_out, rd_out} <= {mem_data_in, ALU_result_in, rd_in};
    end
  end

endmodule

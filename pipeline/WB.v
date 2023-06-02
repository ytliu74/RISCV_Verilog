`include "const.v"

module WB (
  input wire                         MemtoReg,    // from MEM/WB
  input wire [`REG_DATA_WIDTH - 1:0] mem_data,    // from MEM/WB
  input wire [`REG_DATA_WIDTH - 1:0] ALU_result,  // from MEM/WB
  input wire [`REG_ADDR_WIDTH - 1:0] rd_in,       // from MEM/WB

  output wire [`REG_DATA_WIDTH - 1:0] write_back,  // write back to ID register
  output wire [`REG_ADDR_WIDTH - 1:0] rd_out       // output to ID register
);

  assign write_back = MemtoReg ? mem_data : ALU_result;
  assign rd_out = rd_in;

endmodule

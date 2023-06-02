`include "const.v"

module MEM (
  input wire [`REG_DATA_WIDTH - 1:0] ALU_result,  // ALU result from EX
  input wire MemRead,  // Control signal from ID
  input wire MemtoReg,  // Control signal from ID
  input wire MemWrite,  // Control signal from ID
  input wire [`REG_DATA_WIDTH - 1:0] reg_read_data,   // Read data 2 from register, to be used in data_mem->data_i
  input wire [`MEM_ADDR_WIDTH - 1:0] mem_data_o,  // Receive Read data from data_mem
  output wire write_enable,  // Generate `we` signal, connected to data_mem->we
  output wire [`MEM_ADDR_WIDTH - 1:0] mem_address,  // Connected to data_mem->addr
  output wire [`REG_DATA_WIDTH - 1:0] mem_data_i,  // Connected to data_mem->data_i
  output wire [`REG_DATA_WIDTH - 1:0] write_back_data  // To be used in ID
);

  assign mem_address = ALU_result;
  assign write_enable = MemWrite;
  assign mem_data_i = reg_read_data;
  assign write_back_data = (MemtoReg == 0) ? ALU_result : mem_data_o;

endmodule

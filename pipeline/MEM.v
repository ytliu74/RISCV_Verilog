`include "const.v"

module MEM (
  input wire MemRead,   // Control signal from EX/MEM
  input wire MemtoReg,  // Control signal from EX/MEM
  input wire MemWrite,  // Control signal from EX/MEM
  input wire RegWrite,  // Control signal from EX/MEM

  input wire [`REG_DATA_WIDTH - 1:0] ALU_result,  // Read from EX/MEM
  input wire [`REG_DATA_WIDTH - 1:0] reg_read_data,   // Read data 2 from register, to be used in data_mem->data_i
  input wire [`MEM_ADDR_WIDTH - 1:0] mem_data_o,  // Receive Read data from data_mem

  output wire write_enable,  // Generate `we` signal, connected to data_mem->we
  output wire [`MEM_ADDR_WIDTH - 1:0] mem_address,  // Connected to data_mem->addr
  output wire [`REG_DATA_WIDTH - 1:0] mem_data_i,  // Connected to data_mem->data_i
  output wire [`MEM_ADDR_WIDTH - 1:0] mem_data_o_WB  // output to MEM/WB
);

  assign mem_address = ALU_result;
  assign write_enable = MemWrite;
  assign mem_data_i = reg_read_data;
  assign mem_data_o_WB = mem_data_o;

endmodule

`include "const.v"

module DATA_HAZARD (
  input  wire                         ID_EX_MemRead,  // MemRead from ID/EX
  input  wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rd,       // rd from ID/EX
  input  wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs1,      // rs1 from IF/ID
  input  wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs2,      // rs2 from IF/ID
  output wire                         stall           // output stall to IF, IF/ID, ID/EX
);

  assign stall = ID_EX_MemRead && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2));

endmodule

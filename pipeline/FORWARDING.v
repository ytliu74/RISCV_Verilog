`include "const.v"

module FORWARDING (
  input wire                         EX_MEM_RegWrite,
  input wire                         MEM_WB_RegWrite,
  input wire                         MEM_WB_MemRead,
  input wire [`REG_ADDR_WIDTH - 1:0] EX_MEM_rd,
  input wire [`REG_ADDR_WIDTH - 1:0] MEM_WB_rd,
  input wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rs1,
  input wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rs2,
  input wire [`REG_DATA_WIDTH - 1:0] forwarding_EX_MEM_in,      // ALU_result from EX/MEM
  input wire [`REG_DATA_WIDTH - 1:0] forwarding_MEM_WB_ALU_in,  // ALU_result from MEM/WB
  input wire [`REG_DATA_WIDTH - 1:0] forwarding_MEM_WB_MEM_in,  // mem read data from MEM/WB

  output wire [`REG_DATA_WIDTH - 1:0] forwarding_EX_MEM_out,  // output to EX
  output wire [`REG_DATA_WIDTH - 1:0] forwarding_MEM_WB_out,  // output to EX
  output reg  [                  1:0] ForwardA,               // connect to EX mux
  output reg  [                  1:0] ForwardB                // connect to EX mux
);

  assign forwarding_EX_MEM_out = forwarding_EX_MEM_in;
  assign forwarding_MEM_WB_out = MEM_WB_MemRead ? forwarding_MEM_WB_MEM_in : forwarding_MEM_WB_ALU_in;

  always @(*) begin
    // EX Hazard
    if (EX_MEM_RegWrite && (EX_MEM_rd != 0)) begin
      if (EX_MEM_rd == ID_EX_rs1) ForwardA = 2'b10;
      else ForwardA = 2'b00;

      if (EX_MEM_rd == ID_EX_rs2) ForwardB = 2'b10;
      else ForwardB = 2'b00;

    end

    // MEM Hazard
    if (MEM_WB_RegWrite && (MEM_WB_rd != 0)) begin
      if (~(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)))
        if (MEM_WB_rd == ID_EX_rs1) ForwardA = 2'b01;
        else ForwardA = 2'b00;
      else;
      if (~(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)))
        if (MEM_WB_rd == ID_EX_rs2) ForwardB = 2'b01;
        else ForwardB = 2'b00;
      else;
    end
  end


endmodule

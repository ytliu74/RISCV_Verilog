`include "const.v"

module IF (
  input wire                          clk,
  input wire                          rst,
  input wire                          PCSrc,
  input wire                          PCWrite,     // stall from hazard detection unit
  input wire [`INST_ADDR_WIDTH - 1:0] branch_addr, // From EX/MEM

  output wire [`INST_ADDR_WIDTH - 1:0] out_addr  // Connected to inst_mem->inst_addr_o & IF/ID
);

  reg  [`INST_ADDR_WIDTH - 1:0] in_addr;
  wire [`INST_ADDR_WIDTH - 1:0] seq_addr;
  wire [`INST_ADDR_WIDTH - 1:0] jump_addr;

  assign seq_addr = out_addr + 4;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      in_addr <= -4;
    end else begin
      if (in_addr == -4) in_addr <= 0;
      else if (PCWrite) in_addr <= in_addr;
      else in_addr <= PCSrc ? branch_addr : seq_addr;
    end
  end

  assign out_addr = in_addr;
endmodule

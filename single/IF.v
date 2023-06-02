`include "const.v"

module IF (
  input  wire                          clk,
  input  wire                          reset,
  input  wire                          Branch,    // Branch from ID->Control
  input  wire                          ALU_Zero,  // ALU_Zero from EX->zero
  input  wire [ `REG_DATA_WIDTH - 1:0] jump,      // From ID->Imm_Gen with Shift left 1
  output wire [`INST_ADDR_WIDTH - 1:0] out_addr   // Connected to inst_mem->inst_addr_o
);

  reg [`INST_ADDR_WIDTH - 1:0] in_addr;
  wire [`INST_ADDR_WIDTH - 1:0] seq_addr;
  wire [`INST_ADDR_WIDTH - 1:0] jump_addr;

  wire PCSrc = Branch && ALU_Zero;

  assign seq_addr  = out_addr + 4;
  assign jump_addr = out_addr + jump;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      in_addr <= -4;
    end else begin
      if (in_addr == -4) in_addr <= 0;
      else in_addr <= PCSrc ? jump_addr : seq_addr;
    end
  end

  assign out_addr = in_addr;
endmodule

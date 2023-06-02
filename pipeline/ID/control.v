`include "const.v"

module control (
  input wire [`INST_WIDTH - 1:0] inst,
  input wire [`OPCODE_WIDTH - 1:0] opcode,
  input wire stall,
  output wire Branch,
  output wire MemRead,
  output wire MemtoReg,
  output wire MemWrite,
  output wire ALUSrc,
  output wire RegWrite
);
  reg [5:0] code;

  assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch} = stall ? 0 : code;

  always @(*) begin
    case (opcode)
      `R_FORMAT_OPCODE: code = 8'b001000;
      `B_FORMAT_OPCODE: code = 8'b000001;
      `J_FORMAT_OPCODE: code = 8'b001001;
      `I_addi_FORMAT_OPCODE: code = 8'b101000;
      `I_lw_FORMAT_OPCODE: code = 8'b111100;
      `S_FORMAT_OPCODE: code = 8'b100010;
      default: code = 0;
    endcase
  end
endmodule

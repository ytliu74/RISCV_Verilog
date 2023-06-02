`include "const.v"

module control (
  input wire [`INST_WIDTH - 1:0] inst,
  input wire [`OPCODE_WIDTH - 1:0] opcode,
  output wire Branch,
  output wire MemRead,
  output wire MemtoReg,
  output wire [1:0] ALUOp,
  output wire MemWrite,
  output wire ALUSrc,
  output wire RegWrite
);
  reg [7:0] code;

  assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = code;

  always @(inst) begin
    case (opcode)
      `R_FORMAT_OPCODE: code <= 8'b00100010;
      `B_FORMAT_OPCODE: code <= 8'b00000101;
      `J_FORMAT_OPCODE: code <= 8'b00100100;
      `I_addi_FORMAT_OPCODE: code <= 8'b10100000;
      `I_lw_FORMAT_OPCODE: code <= 8'b11110000;
      `S_FORMAT_OPCODE: code <= 8'b10001000;
      default: code <= 0;
    endcase
  end
endmodule

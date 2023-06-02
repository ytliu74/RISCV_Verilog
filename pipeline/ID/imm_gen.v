`include "const.v"

module imm_gen (
  input wire [`INST_WIDTH - 1:0] inst,
  output reg [`REG_DATA_WIDTH - 1:0] imm
);

  wire [`OPCODE_WIDTH - 1:0] opcode;
  wire sign;

  assign opcode = inst[`OPCODE];
  assign sign   = inst[`INST_WIDTH-1];

  always @(*) begin
    case (opcode)
      `R_FORMAT_OPCODE: imm = 0;
      `I_addi_FORMAT_OPCODE:
      imm = sign == 1 ? {{20{1'b1}}, inst[`I_imm]} : {{20{1'b0}}, inst[`I_imm]};
      `I_lw_FORMAT_OPCODE:
      imm = sign == 1 ? {{20{1'b1}}, inst[`I_imm]} : {{20{1'b0}}, inst[`I_imm]};
      `S_FORMAT_OPCODE:
      imm = sign == 1?
                {{20{1'b1}}, inst [`S_imm_2], inst [`S_imm_1]} :
                    {{20{1'b0}}, inst [`S_imm_2], inst [`S_imm_1]};
      `B_FORMAT_OPCODE:
      imm = sign == 1 ?  // With left shift 1
      {{19{1'b1}}, inst [`B_imm_4], inst [`B_imm_3], inst [`B_imm_2], inst [`B_imm_1], 1'b0} :
                    {{19{1'b0}}, inst [`B_imm_4], inst [`B_imm_3], inst [`B_imm_2], inst [`B_imm_1], 1'b0};
      `J_FORMAT_OPCODE:
      imm = sign == 1 ?  // With left shift 1
      {{11{1'b1}}, inst [`J_imm_4], inst [`J_imm_3], inst [`J_imm_2], inst [`J_imm_1], 1'b0} :
                    {{11{1'b0}}, inst [`J_imm_4], inst [`J_imm_3], inst [`J_imm_2], inst [`J_imm_1], 1'b0};

      default: imm = 0;
    endcase
  end
endmodule

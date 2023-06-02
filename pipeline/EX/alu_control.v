`include "const.v"

module alu_control (
  input wire [`INST_WIDTH - 1:0] inst,
  output reg [`ALU_CONTROL_WIDTH - 1:0] ALU_ctl
);
  wire [`OPCODE_WIDTH - 1:0] opcode;
  wire [`FUNCT3_WIDTH - 1:0] funct3;
  wire [`FUNCT7_WIDTH - 1:0] funct7;

  assign opcode = inst[`OPCODE];
  assign funct3 = inst[`FUNCT3];
  assign funct7 = inst[`FUNCT7];

  always @(*) begin
    case (opcode)
      // add sub and or xor sll srl
      `R_FORMAT_OPCODE: begin
        case ({
          funct3, funct7
        })
          {`ADD_FUNCT3, `ADD_FUNCT7} : ALU_ctl = `ALU_ADD;
          {`SUB_FUNCT3, `SUB_FUNCT7} : ALU_ctl = `ALU_SUB;
          {`XOR_FUNCT3, `XOR_FUNCT7} : ALU_ctl = `ALU_XOR;
          {`OR_FUNCT3, `OR_FUNCT7} : ALU_ctl = `ALU_OR;
          {`AND_FUNCT3, `AND_FUNCT7} : ALU_ctl = `ALU_AND;
          {`SLL_FUNCT3, `SLL_FUNCT7} : ALU_ctl = `ALU_SLL;
          {`SRL_FUNCT3, `SRL_FUNCT7} : ALU_ctl = `ALU_SRL;
          default: ;
        endcase
      end
      // beq blt
      `B_FORMAT_OPCODE: begin
        case (funct3)
          `BEQ_FUNCT3: ALU_ctl = `ALU_SUB;
          `BLT_FUNCT3: ALU_ctl = `ALU_LT;
          default: ;
        endcase
      end
      // jal
      `J_FORMAT_OPCODE: begin
        ALU_ctl = `ALU_JAL;
      end
      // addi
      `I_addi_FORMAT_OPCODE: begin
        ALU_ctl = `ALU_ADD;
      end
      // lw
      `I_lw_FORMAT_OPCODE: begin
        ALU_ctl = `ALU_ADD;
      end
      // sw
      `S_FORMAT_OPCODE: begin
        ALU_ctl = `ALU_ADD;
      end
      default: ;
    endcase
  end

endmodule

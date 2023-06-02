`include "const.v"

// ! Cannot recognize imm correctly
module DEBUGGER (
  input wire [`INST_WIDTH - 1:0] inst,
  input wire [`REG_DATA_WIDTH - 1:0] imme
);
  parameter imm_check_width = 8;

  wire [  `REG_ADDR_WIDTH-1:0] rd;
  wire [  `REG_ADDR_WIDTH-1:0] rs1;
  wire [  `REG_ADDR_WIDTH-1:0] rs2;
  wire [  `OPCODE_WIDTH - 1:0] opcode;
  wire [  `FUNCT3_WIDTH - 1:0] funct3;
  wire [  `FUNCT7_WIDTH - 1:0] funct7;
  wire [imm_check_width - 1:0] imm;

  assign rd = inst[`RD];
  assign rs1 = inst[`RS1];
  assign rs2 = inst[`RS2];
  assign opcode = inst[`OPCODE];
  assign funct3 = inst[`FUNCT3];
  assign funct7 = inst[`FUNCT7];
  assign imm = imme[imm_check_width-1:0];

  always @(inst) begin
    case (opcode)
      // add sub and or xor sll srl
      `R_FORMAT_OPCODE: begin
        case ({
          funct3, funct7
        })
          {`ADD_FUNCT3, `ADD_FUNCT7} : $display("add x%d, x%d, x%d", rd, rs1, rs2);
          {`SUB_FUNCT3, `SUB_FUNCT7} : $display("sub x%d, x%d, x%d", rd, rs1, rs2);
          {`XOR_FUNCT3, `XOR_FUNCT7} : $display("xor x%d, x%d, x%d", rd, rs1, rs2);
          {`OR_FUNCT3, `OR_FUNCT7} : $display("or x%d, x%d, x%d", rd, rs1, rs2);
          {`AND_FUNCT3, `AND_FUNCT7} : $display("and x%d, x%d, x%d", rd, rs1, rs2);
          {`SLL_FUNCT3, `SLL_FUNCT7} : $display("sll x%d, x%d, x%d", rd, rs1, rs2);
          {`SRL_FUNCT3, `SRL_FUNCT7} : $display("srl x%d, x%d, x%d", rd, rs1, rs2);
          default: ;
        endcase
      end
      // beq blt
      `B_FORMAT_OPCODE: begin
        case (funct3)
          `BEQ_FUNCT3: $display("beq x%d, x%d, imm", rs1, rs2);
          `BLT_FUNCT3: $display("blt x%d, x%d, imm", rs1, rs2);
          default: ;
        endcase
      end
      // jal
      `J_FORMAT_OPCODE: begin
        $display("jal x%d, imm", rd);
      end
      // addi
      `I_addi_FORMAT_OPCODE: begin
        $display("addi x%d, x%d, imm", rd, rs1);
      end
      // lw
      `I_lw_FORMAT_OPCODE: begin
        $display("lw x%d, imm(x%d)", rd, rs1);
      end
      // sw
      `S_FORMAT_OPCODE: begin
        $display("sw x%d, imm(x%d)", rs2, rs1);
      end
      default: ;
    endcase
  end

endmodule

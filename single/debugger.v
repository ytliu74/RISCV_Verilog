`include "const.v"

module DEBUGGER (
        input wire [`INST_WIDTH - 1:0] inst,
        input wire [`REG_DATA_WIDTH - 1:0] imme
    );
    parameter imm_check_width = 8;

    wire [`REG_ADDR_WIDTH-1:0] rd;
    wire [`REG_ADDR_WIDTH-1:0] rs1;
    wire [`REG_ADDR_WIDTH-1:0] rs2;
    wire [`OPCODE_WIDTH - 1:0] opcode;
    wire [`FUNCT3_WIDTH - 1:0] funct3;
    wire [`FUNCT7_WIDTH - 1:0] funct7;
    wire [imm_check_width - 1:0] imm;

    assign rd = inst[`RD];
    assign rs1 = inst[`RS1];
    assign rs2 = inst[`RS2];
    assign opcode = inst[`OPCODE];
    assign funct3 = inst[`FUNCT3];
    assign funct7 = inst[`FUNCT7];
    assign imm = imme[imm_check_width - 1:0];

    always @(inst) begin
        case (opcode)
            // add sub and or xor sll srl
            `R_FORMAT_OPCODE: begin
                case ({funct3, funct7})
                    {`ADD_FUNCT3, `ADD_FUNCT7}:
                        $display("add %d %d %d", rd, rs1, rs2);
                    {`SUB_FUNCT3, `SUB_FUNCT7}:
                        $display("sub %d %d %d", rd, rs1, rs2);
                    {`XOR_FUNCT3, `XOR_FUNCT7}:
                        $display("xor %d %d %d", rd, rs1, rs2);
                    {`OR_FUNCT3, `OR_FUNCT7}:
                        $display("or %d %d %d", rd, rs1, rs2);
                    {`AND_FUNCT3, `AND_FUNCT7}:
                        $display("and %d %d %d", rd, rs1, rs2);
                    {`SLL_FUNCT3, `SLL_FUNCT7}:
                        $display("sll %d %d %d", rd, rs1, rs2);
                    {`SRL_FUNCT3, `SRL_FUNCT7}:
                        $display("srl %d %d %d", rd, rs1, rs2);
                    default:
                        ;
                endcase
            end
            // beq blt
            `B_FORMAT_OPCODE: begin
                case (funct3)
                    `BEQ_FUNCT3:
                        $display("beq %d %d %d", rs1, rs2, imm);
                    `BLT_FUNCT3:
                        $display("blt %d %d %d", rs1, rs2, imm);
                    default:
                        ;
                endcase
            end
            // jal
            `J_FORMAT_OPCODE: begin
                $display("jal");
            end
            // addi
            `I_addi_FORMAT_OPCODE: begin
                $display("addi %d %d %d", rd, rs1, imm);
            end
            // lw
            `I_lw_FORMAT_OPCODE: begin
                $display("lw %d %d(%d)", rd, imm, rs1);
            end
            // sw
            `S_FORMAT_OPCODE: begin
                $display("sw %d %d(%d)", rs2, imm, rs1);
            end
            default:
                ;
        endcase
    end

endmodule

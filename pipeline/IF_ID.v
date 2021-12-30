`include "const.v"

module IF_ID (
        input wire clk,
        input wire rst,
        input wire [`INST_ADDR_WIDTH - 1:0] inst_addr_in,  // input from IF
        input wire [`INST_WIDTH - 1:0] inst_in,            // input from IF
        input wire if_flush,                               // if_flush from HAZARD_DETECTION

        output reg [`OPCODE_WIDTH - 1:0] opcode,           // output to control and ID/EX
        output reg [`REG_ADDR_WIDTH - 1:0] rd,             // IF/ID.rd
        output reg [`REG_ADDR_WIDTH - 1:0] rs1,            // IF/ID.rs1
        output reg [`REG_ADDR_WIDTH - 1:0] rs2,            // IF/ID.rs2
        output reg [`INST_ADDR_WIDTH - 1:0] inst_addr_out, // IF/ID.inst_addr
        output reg [`INST_WIDTH - 1:0] inst_out            // IF/ID.inst
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode <= 0;
            rd <= 0;
            rs1 <= 0;
            rs2 <= 0;
            inst_out <= 0;
        end
        else begin
            if (if_flush)  // Stall, do nothing
                ;
            else begin
                inst_addr_out <= inst_addr_in;
                inst_out <= inst_in;
                opcode <= inst_in[`OPCODE];
                rd <= inst_in[`RD];
                rs1 <= inst_in[`RS1];
                rs2 <= inst_in[`RS2];
            end
        end
    end

endmodule

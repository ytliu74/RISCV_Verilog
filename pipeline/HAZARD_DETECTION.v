`include "const.v"

// ! Only data hazard is supported.

module HAZARD_DETECTION (
        input wire ID_EX_MemRead,                      // MemRead from ID/EX
        input wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rd,   // rd from ID/EX
        input wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs1,  // rs1 from IF/ID
        input wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs2,  // rs2 from IF/ID
        output wire if_flush                           // output if_flush to IF, IF/ID, ID/EX
    );

    assign if_flush =
           (ID_EX_MemRead && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2)))? 1 :0;

endmodule

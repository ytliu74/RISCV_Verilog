`include "EX/alu.v"
`include "const.v"


module EX(
        input wire [`REG_DATA_WIDTH - 1:0] read_data_1,   // read data 1 from register
        input wire [`REG_DATA_WIDTH - 1:0] read_data_2,   // read data 2 from register
        input wire [`REG_DATA_WIDTH - 1:0] imm,           // from Imm_Gen, where imm = jump
        input wire [`INST_ADDR_WIDTH - 1:0] pc,           // form IF, for jal
        input wire [`ALU_CONTROL_WIDTH - 1:0] ALU_ctl,    // ALU control, From ID
        input wire ALUSrc,                                // Control signal from ID
        output wire [`REG_DATA_WIDTH - 1:0] ALU_result,
        output wire zero                                  // Set high if ALU_result is zero, to be used in IF
    );

    wire [`REG_DATA_WIDTH - 1:0] input_data_2;
    assign input_data_2 = (ALUSrc == 1'b0) ? read_data_2 : imm; // ALUSrc MUX

    ALU u_ALU(
            .input_data_1 (read_data_1),
            .input_data_2 (input_data_2),
            .ALU_control (ALU_ctl),
            .pc(pc),
            .zero (zero),
            .output_data(ALU_result)
        );
endmodule

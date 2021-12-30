`include "const.v"
`include "EX/alu.v"
`include "EX/alu_control.v"

module EX(
        input wire [`INST_WIDTH - 1:0] inst,                  // read from ID/EX
        input wire [`INST_ADDR_WIDTH - 1:0] inst_addr,        // read from ID/EX
        input wire [`REG_DATA_WIDTH - 1:0] read_data_1,       // read from ID/EX
        input wire [`REG_DATA_WIDTH - 1:0] read_data_2,       // read from ID/EX
        input wire [`REG_DATA_WIDTH - 1:0] imm,               // read from ID/EX
        input wire ALUSrc,                                    // Control signal, read from ID/EX
        // -- Forwarding --
        input wire [1:0] ForwardA,                            // forward signal from FORWARDING
        input wire [1:0] ForwardB,                            // forward signal from FORWARDING
        input wire [`REG_DATA_WIDTH - 1:0] forwarding_EX_MEM, // forwarding EX/MEM from FORWARDING
        input wire [`REG_DATA_WIDTH - 1:0] forwarding_MEM_WB, // forwarding MEM/WB from FORWARDING

        output wire [`INST_ADDR_WIDTH - 1:0] branch_addr,     // output to EX/MEM
        output wire [`REG_DATA_WIDTH - 1:0] ALU_result,
        output wire ALU_zero                                      // Set high if ALU_result is zero, output to EX/MEM
    );

    wire [`REG_DATA_WIDTH - 1:0] input_data_1;
    wire [`REG_DATA_WIDTH - 1:0] input_data_2;
    wire [`ALU_CONTROL_WIDTH - 1:0] ALU_ctl;
    reg [`REG_DATA_WIDTH - 1:0] input_A;
    reg [`REG_DATA_WIDTH - 1:0] input_B;

    assign branch_addr = inst_addr + imm;

    always @(*) begin
        if (ForwardA == 2'b10)
            input_A <= forwarding_EX_MEM;
        else if (ForwardA == 2'b01)
            input_A <= forwarding_MEM_WB;
        else
            input_A <= read_data_1;
    end

    always @(*) begin
        if (ForwardB == 2'b10)
            input_B <= forwarding_EX_MEM;
        else if (ForwardA == 2'b01)
            input_B <= forwarding_MEM_WB;
        else
            input_B <= read_data_2;
    end

    // assign input_A = ForwardA[0] ? (forwarding_MEM_WB) : (ForwardA[1] ? (forwarding_EX_MEM) : (read_data_1));
    // assign input_B = ForwardB[0] ? (forwarding_MEM_WB) : (ForwardB[1] ? (forwarding_EX_MEM) : (read_data_2));

    assign input_data_1 = input_A;
    assign input_data_2 = ALUSrc ? imm : input_B; // ALUSrc MUX


    ALU u_ALU(
            .input_data_1 (input_data_1),
            .input_data_2 (input_data_2),
            .ALU_control (ALU_ctl),
            .zero (ALU_zero),
            .output_data(ALU_result)
        );

    alu_control u_alu_control(
                    .inst(inst),
                    .ALU_ctl(ALU_ctl)
                );

endmodule

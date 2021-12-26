`include "const.v"
`include "IF/pc.v"

module IF (
        input wire clk,
        input wire reset,
        input wire Branch,                            // Branch from ID->Control
        input wire ALU_Zero,                          // ALU_Zero from EX->zero
        input wire [`REG_DATA_WIDTH - 1:0] jump,      // From ID->Imm_Gen with Shift left 1
        output wire [`INST_ADDR_WIDTH - 1:0] out_addr // Connected to inst_mem->inst_addr_o
    );

    reg [`INST_ADDR_WIDTH - 1:0] in_addr;

    reg [`INST_ADDR_WIDTH - 1:0] seq_addr;
    reg [`INST_ADDR_WIDTH - 1:0] jump_addr;

    wire PCSrc = Branch && ALU_Zero;

    always @(*) begin
        if (reset)
            in_addr <= 0;
    end

    always @(posedge clk) begin
        seq_addr  <= out_addr + 4;
        jump_addr <= out_addr + jump;

        in_addr <= PCSrc ? jump_addr : seq_addr;
    end

    pc u_pc(
           .clk(clk),
           .reset(reset),
           .in_addr(in_addr),
           .out_addr(out_addr)
       );
endmodule

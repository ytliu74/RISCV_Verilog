`include "const.v"

module pc (
        input wire clk,
        input wire reset,
        input wire [`INST_ADDR_WIDTH - 1:0] in_addr,
        output reg [`INST_ADDR_WIDTH - 1:0] out_addr
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            out_addr <= 0;
        else
            out_addr <= in_addr;
    end
endmodule

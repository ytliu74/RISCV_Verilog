`include "const.v"

module register (
        input wire clk,
        input wire reset,
        input wire RegWrite,
        input wire [`REG_ADDR_WIDTH - 1:0] read_reg_addr_1,
        input wire [`REG_ADDR_WIDTH - 1:0] read_reg_addr_2,
        input wire [`REG_ADDR_WIDTH - 1:0] write_reg_addr,
        input wire [`REG_DATA_WIDTH - 1:0] write_reg_data,
        output reg [`REG_DATA_WIDTH - 1:0] read_reg_data_1,
        output reg [`REG_DATA_WIDTH - 1:0] read_reg_data_2
    );

    // 32 * 64bit
    reg [`REG_DATA_WIDTH - 1:0] Reg_data [0:`REG_SIZE];

    // always @(posedge clk or posedge reset) begin
    //     Reg_data[0] <= 0;

    //     if (reset) begin
    //         read_reg_data_1 <= 0;
    //         read_reg_data_2 <= 0;
    //     end
    //     else begin
    //         if(RegWrite)
    //             Reg_data[write_reg_addr] <= write_reg_data;
    //         else
    //             ;
    //         read_reg_data_1 <= Reg_data[read_reg_addr_1];
    //         read_reg_data_2 <= Reg_data[read_reg_addr_2];
    //     end
    // end

    always @(*) begin
        if (reset) begin
            read_reg_data_1 <= 0;
            read_reg_data_2 <= 0;
        end
        else begin
            if (RegWrite)
                Reg_data[write_reg_addr] <= write_reg_data;
            else
                ;
            read_reg_data_1 <= (read_reg_addr_1 == 0) ? 0:Reg_data[read_reg_addr_1];
            read_reg_data_2 <= (read_reg_addr_2 == 0) ? 0:Reg_data[read_reg_addr_2];
        end
    end

endmodule

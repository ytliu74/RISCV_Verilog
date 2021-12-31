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

    always @(posedge clk or posedge reset) begin
        if (reset)
            ;
        else if (RegWrite)
            Reg_data[write_reg_addr] <= write_reg_data;
    end

    always @(*) begin
        if (reset) begin
            read_reg_data_1 <= 0;
            read_reg_data_2 <= 0;
        end
        else begin
            if (RegWrite && read_reg_addr_1 == write_reg_addr)
                read_reg_data_1 <= write_reg_data;
            else
                read_reg_data_1 <= (read_reg_addr_1 == 0) ? 0:Reg_data[read_reg_addr_1];

            if (RegWrite && read_reg_addr_2 == write_reg_addr)
                read_reg_data_2 <= write_reg_data;
            else
                read_reg_data_2 <= (read_reg_addr_2 == 0) ? 0:Reg_data[read_reg_addr_2];
        end
    end

    always @(*) begin
        $display("x1:%d,   x2:%d,   x3:%d,   x4:%d,   x5:%d", Reg_data[1], Reg_data[2], Reg_data[3], Reg_data[4], Reg_data[5] );
        $display("x6:%d,   x7:%d,   x8:%d,   x9:%d,   x10:%d", Reg_data[6], Reg_data[7], Reg_data[8], Reg_data[9], Reg_data[10] );
        $display("x11:%d,  x12:%d,  x13:%d,  x14:%d   x15:%d", Reg_data[11], Reg_data[12], Reg_data[13], Reg_data[14], Reg_data[15]);
        $display("-----------------------");
    end

endmodule

`include "const.v"

module ALU (
        input wire [`ALU_DATA_WIDTH - 1:0] input_data_1,
        input wire [`ALU_DATA_WIDTH - 1:0] input_data_2,
        input wire [`ALU_CONTROL_WIDTH - 1:0] ALU_control,
        output wire zero,
        output reg [`ALU_DATA_WIDTH - 1:0] output_data
    );
    always @ (input_data_1 or input_data_2 or ALU_control) begin
        case (ALU_control)
            `ALU_AND:
                output_data <= input_data_1 & input_data_2;
            `ALU_OR:
                output_data <= input_data_1 | input_data_2;
            `ALU_ADD:
                output_data <= input_data_1 + input_data_2;
            `ALU_SUB:
                output_data <= input_data_1 - input_data_2;
            `ALU_NOR:
                output_data <= ~ (input_data_1 | input_data_2);
            `ALU_LT:
                output_data <= input_data_1 < input_data_2? 1'b0 : 1'b1;
            `ALU_XOR:
                output_data <= input_data_1 ^ input_data_2;
            `ALU_SLL:
                output_data <= input_data_1 << input_data_2;
            `ALU_SRL:
                output_data <= input_data_1 >> input_data_2;
            default:
                ;
        endcase
    end

    assign zero = output_data == 0 ? 1'b1: 1'b0;
endmodule

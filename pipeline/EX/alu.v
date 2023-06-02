`include "const.v"

module ALU (
  input wire [`ALU_DATA_WIDTH - 1:0] input_data_1,
  input wire [`ALU_DATA_WIDTH - 1:0] input_data_2,
  input wire [`ALU_CONTROL_WIDTH - 1:0] ALU_control,
  input wire [`INST_ADDR_WIDTH - 1:0] pc,
  output wire zero,
  output reg [`ALU_DATA_WIDTH - 1:0] output_data
);

  wire data_1_sign;
  wire data_2_sign;

  assign data_1_sign = input_data_1[`ALU_DATA_WIDTH-1];
  assign data_2_sign = input_data_2[`ALU_DATA_WIDTH-1];

  always @(*) begin
    case (ALU_control)
      `ALU_AND: output_data = input_data_1 & input_data_2;
      `ALU_OR:  output_data = input_data_1 | input_data_2;
      `ALU_ADD: output_data = input_data_1 + input_data_2;
      `ALU_SUB: output_data = input_data_1 - input_data_2;
      `ALU_NOR: output_data = ~(input_data_1 | input_data_2);
      `ALU_LT: begin
        case ({
          data_1_sign, data_2_sign
        })
          2'b00, 2'b11:  // With same sign
          output_data = input_data_1 < input_data_2 ? 0 : 1;
          2'b10:  // data_1 < 0 , data_2 >= 0
          output_data = 0;
          2'b01:  // data_1 >= 0 , data_2 < 0
          output_data = 1;
        endcase
      end
      `ALU_XOR: output_data = input_data_1 ^ input_data_2;
      `ALU_SLL: output_data = input_data_1 << input_data_2;
      `ALU_SRL: output_data = input_data_1 >> input_data_2;
      `ALU_JAL: output_data = pc + 4;
      default:  ;
    endcase
  end

  assign zero = (ALU_control == `ALU_JAL) ? 1'b1 : (output_data == 0 ? 1'b1 : 1'b0);
endmodule

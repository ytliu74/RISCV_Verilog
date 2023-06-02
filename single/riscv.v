`include "const.v"
`include "IF.v"
`include "ID.v"
`include "EX.v"
`include "MEM.v"
`include "DEBUGGER.v"


module riscv (

  input wire clk,
  input wire rst,  // high is reset

  // inst_mem
  input  wire [31:0] inst_i,
  output wire [31:0] inst_addr_o,
  output wire        inst_ce_o,

  // data_mem
  input  wire [31:0] data_i,       // load data from data_mem
  output wire        data_we_o,
  output wire        data_ce_o,
  output wire [31:0] data_addr_o,
  output wire [31:0] data_o        // store data to  data_mem

);

  assign inst_ce_o = ~rst;
  assign data_ce_o = ~rst;

  wire Branch;
  wire ALU_Zero;
  wire MemRead;
  wire MemToReg;
  wire MemWrite;
  wire ALUSrc;
  wire [1:0] ALUOp;
  wire [`ALU_CONTROL_WIDTH - 1:0] ALU_ctl;
  wire [`REG_DATA_WIDTH - 1:0] jump;
  wire [`REG_DATA_WIDTH - 1:0] write_back_data;
  wire [`REG_DATA_WIDTH - 1:0] read_reg_data_1;
  wire [`REG_DATA_WIDTH - 1:0] read_reg_data_2;
  wire [`REG_DATA_WIDTH - 1:0] ALU_result;

  IF u_IF (
    // INPUT
    .clk     (clk),
    .reset   (rst),
    .Branch  (Branch),
    .ALU_Zero(ALU_Zero),
    .jump    (jump),
    // OUTPUT
    .out_addr(inst_addr_o)
  );

  ID u_ID (
    // INPUT
    .clk            (clk),
    .reset          (rst),
    .inst           (inst_i),
    .write_data     (write_back_data),
    // OUTPUT
    .Branch         (Branch),
    .MemRead        (MemRead),
    .MemtoReg       (MemToReg),
    .ALUOp          (ALUOp),
    .MemWrite       (MemWrite),
    .ALUSrc         (ALUSrc),
    .read_reg_data_1(read_reg_data_1),
    .read_reg_data_2(read_reg_data_2),
    .jump           (jump),
    .ALU_ctl        (ALU_ctl)
  );

  EX u_EX (
    // INPUT
    .read_data_1(read_reg_data_1),
    .read_data_2(read_reg_data_2),
    .imm        (jump),
    .pc         (inst_addr_o),
    .ALU_ctl    (ALU_ctl),
    .ALUSrc     (ALUSrc),
    // OUTPUT
    .ALU_result (ALU_result),
    .zero       (ALU_Zero)
  );

  MEM u_MEM (
    // INPUT
    .ALU_result     (ALU_result),
    .MemRead        (MemRead),
    .MemtoReg       (MemToReg),
    .MemWrite       (MemWrite),
    .reg_read_data  (read_reg_data_2),
    .mem_data_o     (data_i),
    // OUTPUT
    .write_enable   (data_we_o),
    .mem_address    (data_addr_o),
    .mem_data_i     (data_o),
    .write_back_data(write_back_data)
  );

  DEBUGGER u_DEBUGGER (
    .inst(inst_i),
    .imme(jump)
  );



endmodule

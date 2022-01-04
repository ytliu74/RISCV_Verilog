`include "const.v"
`include "IF.v"
`include "IF_ID.v"
`include "ID.v"
`include "ID_EX.v"
`include "EX.v"
`include "EX_MEM.v"
`include "MEM.v"
`include "MEM_WB.v"
`include "WB.v"
`include "FORWARDING.v"
`include "DATA_HAZARD.v"
`include "DEBUGGER.v"


module riscv(

        input wire				 clk,
        input wire				 rst,         // high is reset

        // inst_mem
        input wire[31:0]         inst_i,
        output wire[31:0]        inst_addr_o,
        output wire              inst_ce_o,

        // data_mem
        input wire[31:0]         data_i,      // load data from data_mem
        output wire              data_we_o,
        output wire              data_ce_o,
        output wire[31:0]        data_addr_o,
        output wire[31:0]        data_o       // store data to  data_mem

    );

    assign inst_ce_o = ~rst;
    assign data_ce_o = ~rst;

    wire stall;

    wire IF_flush;
    wire ID_flush;

    wire [`OPCODE_WIDTH - 1:0] IF_ID_opcode;
    wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rd;
    wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs1;
    wire [`REG_ADDR_WIDTH - 1:0] IF_ID_rs2;
    wire [`INST_ADDR_WIDTH - 1:0] IF_ID_inst_addr;
    wire [`INST_WIDTH - 1:0] IF_ID_inst;

    wire ID_Branch;
    wire ID_MemRead;
    wire ID_MemToReg;
    wire ID_MemWrite;
    wire ID_ALUSrc;
    wire ID_RegWrite;
    wire [`REG_DATA_WIDTH - 1:0] ID_read_reg_data_1;
    wire [`REG_DATA_WIDTH - 1:0] ID_read_reg_data_2;
    wire [`REG_DATA_WIDTH - 1:0] ID_imm;

    wire ID_EX_Branch;
    wire ID_EX_MemRead;
    wire ID_EX_MemToReg;
    wire ID_EX_MemWrite;
    wire ID_EX_ALUSrc;
    wire ID_EX_RegWrite;
    wire [`REG_DATA_WIDTH - 1:0] ID_EX_read_reg_data_1;
    wire [`REG_DATA_WIDTH - 1:0] ID_EX_read_reg_data_2;
    wire [`REG_DATA_WIDTH - 1:0]ID_EX_imm;
    wire [`INST_WIDTH - 1:0] ID_EX_inst;
    wire [`INST_ADDR_WIDTH - 1:0] ID_EX_inst_addr;
    wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rd;
    wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rs1;
    wire [`REG_ADDR_WIDTH - 1:0] ID_EX_rs2;

    wire [`INST_ADDR_WIDTH - 1:0] EX_branch_addr;
    wire [`REG_DATA_WIDTH - 1:0] EX_ALU_result;
    wire [`REG_DATA_WIDTH - 1:0] EX_read_reg_data_2;
    wire EX_ALU_Zero;
    wire EX_PCSrc;

    wire EX_MEM_MemRead;
    wire EX_MEM_MemToReg;
    wire EX_MEM_MemWrite;
    wire EX_MEM_RegWrite;
    wire [`REG_DATA_WIDTH - 1:0] EX_MEM_ALU_result;
    wire [`REG_DATA_WIDTH -1:0] EX_MEM_read_reg_data_2;
    wire [`REG_ADDR_WIDTH -1:0] EX_MEM_rd;

    wire [`REG_DATA_WIDTH -1:0] MEM_mem_data;

    wire MEM_WB_RegWrite;
    wire MEM_WB_MemtoReg;
    wire MEM_WB_MemRead;
    wire [`REG_DATA_WIDTH -1:0] MEM_WB_mem_data;
    wire [`REG_DATA_WIDTH - 1:0] MEM_WB_ALU_result;
    wire [`REG_ADDR_WIDTH -1:0] MEM_WB_rd;


    wire [`REG_DATA_WIDTH - 1:0] WB_write_back_data;
    wire [`REG_ADDR_WIDTH -1:0] WB_rd;

    wire [1:0] ForwardA;
    wire [1:0] ForwardB;
    wire [`REG_DATA_WIDTH - 1:0] forwarding_EX_MEM;
    wire [`REG_DATA_WIDTH - 1:0] forwarding_MEM_WB;


    IF u_IF(
           // INPUT
           .clk(clk),
           .rst(rst),
           .PCSrc(EX_PCSrc),
           .PCWrite(stall),
           .branch_addr(EX_branch_addr),
           // OUTPUT
           .out_addr(inst_addr_o)
       );

    IF_ID u_IF_ID(
              // INPUT
              .clk(clk),
              .rst(rst),
              .inst_addr_in(inst_addr_o),
              .inst_in(inst_i),
              .IF_ID_Write(stall),
              .IF_flush(IF_flush),

              // OUTPUT
              .opcode(IF_ID_opcode),
              .rd(IF_ID_rd),
              .rs1(IF_ID_rs1),
              .rs2(IF_ID_rs2),
              .inst_addr_out(IF_ID_inst_addr),
              .inst_out(IF_ID_inst)
          );

    ID u_ID(
           // INPUT
           .clk(clk),
           .rst(rst),
           // From IF/ID
           .inst(IF_ID_inst),
           .RegWrite_in(MEM_WB_RegWrite),
           .write_data(WB_write_back_data),
           .rd(WB_rd),
           .rs1(IF_ID_rs1),
           .rs2(IF_ID_rs2),
           .opcode(IF_ID_opcode),
           // From HAZARD
           .stall(stall),

           // OUTPUT
           .Branch(ID_Branch),
           .MemRead(ID_MemRead),
           .MemtoReg(ID_MemToReg),
           .MemWrite(ID_MemWrite),
           .ALUSrc(ID_ALUSrc),
           .RegWrite(ID_RegWrite),
           .read_reg_data_1(ID_read_reg_data_1),
           .read_reg_data_2(ID_read_reg_data_2),
           .imm(ID_imm)
           //    .IF_flush(IF_flush)
       );

    ID_EX u_ID_EX(
              // INPUT
              .clk(clk),
              .rst(rst),
              .ID_flush(ID_flush),
              // from ID
              .Branch_in(ID_Branch),
              .MemRead_in(ID_MemRead),
              .MemtoReg_in(ID_MemToReg),
              .MemWrite_in(ID_MemWrite),
              .ALUSrc_in(ID_ALUSrc),
              .RegWrite_in(ID_RegWrite),
              .read_reg_data_1_in(ID_read_reg_data_1),
              .read_reg_data_2_in(ID_read_reg_data_2),
              .imm_in(ID_imm),
              // from IF/ID
              .inst_addr_in(IF_ID_inst_addr),
              .inst_in(IF_ID_inst),
              .rd_in(IF_ID_rd),
              .rs1_in(IF_ID_rs1),
              .rs2_in(IF_ID_rs2),

              //OUTPUT
              .Branch_out(ID_EX_Branch),
              .MemRead_out(ID_EX_MemRead),
              .MemtoReg_out(ID_EX_MemToReg),
              .MemWrite_out(ID_EX_MemWrite),
              .ALUSrc_out(ID_EX_ALUSrc),
              .RegWrite_out(ID_EX_RegWrite),
              .read_reg_data_1_out(ID_EX_read_reg_data_1),
              .read_reg_data_2_out(ID_EX_read_reg_data_2),
              .imm_out(ID_EX_imm),
              .inst_out(ID_EX_inst),
              .inst_addr_out(ID_EX_inst_addr),
              .rd_out(ID_EX_rd),
              .rs1_out(ID_EX_rs1),
              .rs2_out(ID_EX_rs2)
          );

    EX u_EX(
           // INPUT
           // from ID/EX
           .inst(ID_EX_inst),
           .inst_addr(ID_EX_inst_addr),
           .read_data_1(ID_EX_read_reg_data_1),
           .read_data_2(ID_EX_read_reg_data_2),
           .imm(ID_EX_imm),
           .ALUSrc(ID_EX_ALUSrc),
           .Branch(ID_EX_Branch),
           // from FORWARDING
           .ForwardA(ForwardA),
           .ForwardB(ForwardB),
           .forwarding_EX_MEM(forwarding_EX_MEM),
           .forwarding_MEM_WB(forwarding_MEM_WB),

           // OUTPUT
           .branch_addr(EX_branch_addr),
           .read_reg_2_with_forwarding(EX_read_reg_data_2),
           .ALU_result(EX_ALU_result),
           .PCSrc(EX_PCSrc),
           .IF_flush(IF_flush),
           .ID_flush(ID_flush)
       );

    EX_MEM u_EX_MEM(
               //INPUT
               .clk(clk),
               .rst(rst),
               // from ID/EX
               .MemRead_in(ID_EX_MemRead),
               .MemtoReg_in(ID_EX_MemToReg),
               .MemWrite_in(ID_EX_MemWrite),
               .RegWrite_in(ID_EX_RegWrite),
               // from EX
               .ALU_result_in(EX_ALU_result),
               .read_reg_data_2_in(EX_read_reg_data_2),
               .rd_in(ID_EX_rd),

               //OUTPUT
               .MemRead_out(EX_MEM_MemRead),
               .MemtoReg_out(EX_MEM_MemToReg),
               .MemWrite_out(EX_MEM_MemWrite),
               .RegWrite_out(EX_MEM_RegWrite),
               .ALU_result_out(EX_MEM_ALU_result),
               .read_reg_data_2_out(EX_MEM_read_reg_data_2),
               .rd_out(EX_MEM_rd)
           );

    MEM u_MEM(
            // INPUT
            // from EX/MEM
            .MemRead(EX_MEM_MemRead),
            .MemtoReg(EX_MEM_MemToReg),
            .MemWrite(EX_MEM_MemWrite),
            .RegWrite(EX_MEM_RegWrite),
            .ALU_result(EX_MEM_ALU_result),
            .reg_read_data(EX_MEM_read_reg_data_2),
            // from data_mem
            .mem_data_o(data_i),

            // OUTPUT
            // to data_mem
            .write_enable(data_we_o),
            .mem_address(data_addr_o),
            .mem_data_i(data_o),
            // to MEM/WB
            .mem_data_o_WB(MEM_mem_data)
        );

    MEM_WB u_MEM_WB(
               // INPUT
               .clk(clk),
               .rst(rst),
               // from EX/MEM
               .MemtoReg_in(EX_MEM_MemToReg),
               .RegWrite_in(EX_MEM_RegWrite),
               .MemRead_in(EX_MEM_MemRead),
               .ALU_result_in(EX_MEM_ALU_result),
               .rd_in(EX_MEM_rd),
               // from MEM
               .mem_data_in(MEM_mem_data),

               // OUTPUT
               .RegWrite_out(MEM_WB_RegWrite),
               .MemtoReg_out(MEM_WB_MemtoReg),
               .MemRead_out(MEM_WB_MemRead),
               .mem_data_out(MEM_WB_mem_data),
               .ALU_result_out(MEM_WB_ALU_result),
               .rd_out(MEM_WB_rd)
           );

    WB u_WB(
           // INPUT
           .MemtoReg(MEM_WB_MemtoReg),
           .mem_data(MEM_WB_mem_data),
           .ALU_result(MEM_WB_ALU_result),
           .rd_in(MEM_WB_rd),

           // OUTPUT
           .write_back(WB_write_back_data),
           .rd_out(WB_rd)
       );

    FORWARDING u_FORWARDING(
                   // INPUT
                   .EX_MEM_RegWrite(EX_MEM_RegWrite),
                   .MEM_WB_RegWrite(MEM_WB_RegWrite),
                   .MEM_WB_MemRead(MEM_WB_MemRead),
                   .EX_MEM_rd(EX_MEM_rd),
                   .MEM_WB_rd(MEM_WB_rd),
                   .ID_EX_rs1(ID_EX_rs1),
                   .ID_EX_rs2(ID_EX_rs2),
                   .forwarding_EX_MEM_in(EX_MEM_ALU_result),
                   .forwarding_MEM_WB_ALU_in(MEM_WB_ALU_result),
                   .forwarding_MEM_WB_MEM_in(MEM_WB_mem_data),
                   // OUTPUT
                   .forwarding_EX_MEM_out(forwarding_EX_MEM),
                   .forwarding_MEM_WB_out(forwarding_MEM_WB),
                   .ForwardA(ForwardA),
                   .ForwardB(ForwardB)
               );

    DATA_HAZARD u_DATA_HAZARD(
                    .ID_EX_MemRead(ID_EX_MemRead),
                    .ID_EX_rd(ID_EX_rd),
                    .IF_ID_rs1(IF_ID_rs1),
                    .IF_ID_rs2(IF_ID_rs2),
                    .stall(stall)
                );

    DEBUGGER u_DEBUGGER(
                 .inst(inst_i),
                 .imme(ID_imm)
             );



endmodule

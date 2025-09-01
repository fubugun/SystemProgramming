`timescale 1ns/1ps
module forwarding(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] exMemRd,
    input       exMemRw,
    input [4:0] memWBRd,
    input       memWBRw,
    input       mem_wb_ctrl_data_toReg,
    input [31:0] mem_wb_readData,
    input [31:0] mem_wb_data_result,
    input [31:0] id_ex_data_regRData1,
    input [31:0] id_ex_data_regRData2,
    input [31:0] ex_mem_data_result,
    output [31:0] forward_rs1_data,
    output [31:0] forward_rs2_data
);
    // 先直接传递，不做转发，保证综合通过
    assign forward_rs1_data = id_ex_data_regRData1;
    assign forward_rs2_data = id_ex_data_regRData2;
endmodule

`timescale 1ns / 1ps
module RegisterFile (
    input         clk,
    input         rst,

    // 读寄存器编号
    input  [4:0]  rs1_addr_i,
    input  [4:0]  rs2_addr_i,

    // 写寄存器编号
    input  [4:0]  rd_addr_i,
    input  [31:0] rd_data_i,
    input         reg_write_i,   // 写使能

    // 输出数据
    output [31:0] rs1_data_o,
    output [31:0] rs2_data_o
);

    // 32 个寄存器，每个 32 位
    reg [31:0] regs [0:31];

    integer i;

    // 寄存器复位
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (reg_write_i && (rd_addr_i != 5'b0)) begin
            // x0 恒为 0，所以写寄存器时忽略 x0
            regs[rd_addr_i] <= rd_data_i;
        end
    end

    // 读操作（组合逻辑，支持旁路 x0=0）
    assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 : regs[rs1_addr_i];
    assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 : regs[rs2_addr_i];

endmodule

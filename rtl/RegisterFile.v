`timescale 1ns / 1ps
module RegisterFile (
    input         clk,
    input         rst,

    // ���Ĵ������
    input  [4:0]  rs1_addr_i,
    input  [4:0]  rs2_addr_i,

    // д�Ĵ������
    input  [4:0]  rd_addr_i,
    input  [31:0] rd_data_i,
    input         reg_write_i,   // дʹ��

    // �������
    output [31:0] rs1_data_o,
    output [31:0] rs2_data_o
);

    // 32 ���Ĵ�����ÿ�� 32 λ
    reg [31:0] regs [0:31];

    integer i;

    // �Ĵ�����λ
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (reg_write_i && (rd_addr_i != 5'b0)) begin
            // x0 ��Ϊ 0������д�Ĵ���ʱ���� x0
            regs[rd_addr_i] <= rd_data_i;
        end
    end

    // ������������߼���֧����· x0=0��
    assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 : regs[rs1_addr_i];
    assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 : regs[rs2_addr_i];

endmodule

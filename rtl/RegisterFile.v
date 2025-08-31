`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/30 17:53:01
// Design Name: 
// Module Name: RegisterFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile (
    input clk,                  // ʱ���ź�
    input reset,                // �����ź�
    input [4:0] rs1,            // Դ�Ĵ���1
    input [4:0] rs2,            // Դ�Ĵ���2
    input [4:0] rd,             // Ŀ��Ĵ���
    input [31:0] writeData,     // д������
    input regWrite,             // дʹ���ź�
    output [31:0] readData1,    // ��ȡ�Ĵ���1������
    output [31:0] readData2     // ��ȡ�Ĵ���2������
);

    // ����32��32λ�Ĵ���
    reg [31:0] registers [31:0];

    // ��ʼ���Ĵ���
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 32'b0;  // �Ĵ���0�̶�Ϊ��
            registers[1] <= 32'b0;
            // �����Ĵ�����ʼ��Ϊ��
        end
        else if (regWrite && rd != 0) begin
            registers[rd] <= writeData;  // д������
        end
    end

    // ��ȡ����
    assign readData1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign readData2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

endmodule


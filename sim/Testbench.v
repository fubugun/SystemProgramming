`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/30 17:54:02
// Design Name: 
// Module Name: Testbench
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


module Testbench;

    // �����ź�
    reg [31:0] A, B;
    reg [3:0] ALU_Control;
    reg clk, reset;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] writeData;
    reg regWrite;

    // ����ź�
    wire [31:0] ALU_Result;
    wire Zero, Overflow;
    wire [31:0] readData1, readData2;

    // ʵ����ALUģ��
    ALU alu_instance (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU_Result),
        .Zero(Zero),
        .Overflow(Overflow)
    );

    // ʵ�����Ĵ�����
    RegisterFile regfile_instance (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeData(writeData),
        .regWrite(regWrite),
        .readData1(readData1),
        .readData2(readData2)
    );

    // ʱ�Ӳ�����
    always begin
        #5 clk = ~clk;  // ʱ������5��ʱ�䵥λ
    end

    initial begin
        // ��ʼ���ź�
        clk = 0;
        reset = 1;
        rs1 = 5'b00001;  // ����Ĵ���1
        rs2 = 5'b00010;  // ����Ĵ���2
        rd = 5'b00011;  // Ŀ��Ĵ���
        writeData = 32'd100;  // д������
        regWrite = 1;

        // �����ź�
        #10 reset = 0;
        #10 reset = 1;

        // ����ALU�ͼĴ�����
        A = 32'd10; B = 32'd5; ALU_Control = 4'b0000; // ADD
        #10;
        $display("ADD: A + B = %d, Zero = %b, Overflow = %b", ALU_Result, Zero, Overflow);

        A = 32'd10; B = 32'd5; ALU_Control = 4'b0001; // SUB
        #10;
        $display("SUB: A - B = %d, Zero = %b, Overflow = %b", ALU_Result, Zero, Overflow);

        // ���ԼĴ�����д��
        #10 regWrite = 1;  // ���üĴ���д����
        #10 rs1 = 5'b00001; rs2 = 5'b00010;  // ��ȡ�Ĵ���1�ͼĴ���2
        #10 $display("Read Register 1: %d, Read Register 2: %d", readData1, readData2);

        // ����ALU����������
        A = 32'd20; B = 32'd5; ALU_Control = 4'b1011; // ADDI
        #10;
        $display("ADDI: A + Imm = %d, Zero = %b", ALU_Result, Zero);
        
        $finish;
    end

endmodule


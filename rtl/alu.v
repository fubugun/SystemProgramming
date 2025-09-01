`timescale 1ns / 1ps
module alu (
    input  [31:0] alu_data1_i,
    input  [31:0] alu_data2_i,
    input  [ 3:0] alu_op_i,
    output reg [31:0] alu_result_o
);

    // ALU 操作码定义
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    localparam ALU_LUI  = 4'b1010;  // 新增：Load Upper Immediate

    always @(*) begin
        case (alu_op_i)
            ALU_ADD:  alu_result_o = alu_data1_i + alu_data2_i;   // ADD / ADDI / JAL目标计算
            ALU_SUB:  alu_result_o = alu_data1_i - alu_data2_i;   // SUB
            ALU_AND:  alu_result_o = alu_data1_i & alu_data2_i;   // AND / ANDI
            ALU_OR:   alu_result_o = alu_data1_i | alu_data2_i;   // OR / ORI
            ALU_XOR:  alu_result_o = alu_data1_i ^ alu_data2_i;   // XOR
            ALU_SLL:  alu_result_o = alu_data1_i << alu_data2_i[4:0]; // SLL
            ALU_SRL:  alu_result_o = alu_data1_i >> alu_data2_i[4:0]; // SRL
            ALU_SRA:  alu_result_o = $signed(alu_data1_i) >>> alu_data2_i[4:0]; // SRA
            ALU_SLT:  alu_result_o = ($signed(alu_data1_i) < $signed(alu_data2_i)) ? 32'b1 : 32'b0; // BLT
            ALU_SLTU: alu_result_o = (alu_data1_i < alu_data2_i) ? 32'b1 : 32'b0; // 无符号比较
            ALU_LUI:  alu_result_o = alu_data2_i;   // 立即数 << 12 由控制单元送入 alu_data2_i
            default:  alu_result_o = 32'b0;
        endcase
    end

endmodule

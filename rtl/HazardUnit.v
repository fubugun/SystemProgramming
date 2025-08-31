`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/30 17:53:38
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit (
    input [4:0] ID_rs1,      // ID�׶ε�rs1
    input [4:0] ID_rs2,      // ID�׶ε�rs2
    input [4:0] EX_rd,       // EX�׶ε�Ŀ��Ĵ���
    input EX_regWrite,       // EX�׶εļĴ���дʹ��
    output reg hazard        // �Ƿ�������ð��
);

always @(*) begin
    if (EX_regWrite && ((ID_rs1 == EX_rd) || (ID_rs2 == EX_rd))) begin
        hazard = 1;  // ����ð��
    end else begin
        hazard = 0;  // û������ð��
    end
end

endmodule

`timescale 1ns/1ps
module gen_regs(
    input         clk,
    input         reset,
    input         wen,
    input  [4:0]  regRAddr1,
    input  [4:0]  regRAddr2,
    input  [4:0]  regWAddr,
    input  [31:0] regWData,
    output [31:0] regRData1,
    output [31:0] regRData2
);

reg [31:0] regs [31:0];
integer i;

// “Ï≤Ω∂¡
assign regRData1 = regs[regRAddr1];
assign regRData2 = regs[regRAddr2];

// Õ¨≤Ω–¥
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i=0; i<32; i=i+1)
            regs[i] <= 32'b0;
    end else if (wen && regWAddr != 0) begin
        regs[regWAddr] <= regWData;
    end
end

endmodule

`timescale 1ns/1ps
// ALU_OP {instr[30], func3}
`define ALU_OP_ADD      4'b0000
`define ALU_OP_SUB      4'b1000
`define ALU_OP_SLL      4'b0001
`define ALU_OP_SLT      4'b0010
`define ALU_OP_SLTU     4'b0011
`define ALU_OP_XOR      4'b0100
`define ALU_OP_SRL      4'b0101
`define ALU_OP_SRA      4'b1101
`define ALU_OP_OR       4'b0110
`define ALU_OP_AND      4'b0111

`define ALU_OP_EQ       4'b1001
`define ALU_OP_NEQ      4'b1010
`define ALU_OP_GE       4'b1100
`define ALU_OP_GEU      4'b1011

`define ALU_OP_XXX      4'b1111


`define BEQ_FUNCT3      3'b000
`define BNE_FUNCT3      3'b001
`define BLT_FUNCT3      3'b100
`define BGE_FUNCT3      3'b101
`define BLTU_FUNCT3     3'b110
`define BGEU_FUNCT3     3'b111

`define OPCODE_LUI             7'b01_101_11
`define OPCODE_AUIPC           7'b00_101_11
`define OPCODE_JAL             7'b11_011_11
`define OPCODE_JALR            7'b11_001_11
`define OPCODE_BRANCH          7'b11_000_11
`define OPCODE_LOAD            7'b00_000_11
`define OPCODE_STORE           7'b01_000_11
`define OPCODE_ALUI            7'b00_100_11
`define OPCODE_ALUR            7'b01_100_11
`define OPCODE_FENCE           7'b00_011_11
`define OPCODE_SYSTEM          7'b11_100_11

module decode (
  input  [31:0] instr,

  output  [4:0] rs1_addr,
  output  [4:0] rs2_addr,
  output  [4:0] rd_addr,
  output  [2:0] funct3,
  output  [6:0] funct7,
  output        branch,
  output [1:0]  jump,
  output        mem_read,
  output        mem_write,
  output        reg_write,
  output        to_reg,
  output [1:0]  result_sel,
  output        alu_src,
  output        pc_add,
  output [6:0]  types,
  output [1:0]  alu_ctrlop,
  output        valid_inst,
  output [31:0] imm
);

localparam DEC_INVALID = 21'b0;

reg [20:0] dec_array;

//---------- decode rs1、rs2 -----------------
assign rs1_addr = instr[19:15]; 
assign rs2_addr = instr[24:20];

//---------- decode rd -----------------------
assign rd_addr = instr[11:7]; 

//---------- decode funct3、funct7 -----------
assign funct7 = instr[31:25]; 
assign funct3 = instr[14:12]; 

// ----------------------------- decode signals ---------------------------------

//                        20     19-18  17       16        15        14     13-12      11      10     9--------3  2---1      0
//                        branch jump   memRead  memWrite  regWrite  toReg  resultSel  aluSrc  pcAdd     RISBUJZ  aluctrlop  validInst
localparam DEC_LUI     = {1'b0,  2'b00, 1'b0,    1'b0,     1'b1,     1'b0,  2'b01,     1'b0,   1'b0,  7'b0000100, 2'b00,     1'b1};
localparam DEC_AUIPC   = {1'b0,  2'b00, 1'b0,    1'b0,     1'b1,     1'b0,  2'b00,     1'b1,   1'b1,  7'b0000100, 2'b00,     1'b1};
localparam DEC_JAL     = {1'b0,  2'b00, 1'b0,    1'b0,     1'b1,     1'b0,  2'b10,     1'b0,   1'b0,  7'b0000010, 2'b00,     1'b1};
localparam DEC_JALR    = {1'b0,  2'b11, 1'b0,    1'b0,     1'b1,     1'b0,  2'b10,     1'b1,   1'b0,  7'b0100000, 2'b00,     1'b1};
localparam DEC_BRANCH  = {1'b1,  2'b00, 1'b0,    1'b0,     1'b0,     1'b0,  2'b00,     1'b0,   1'b0,  7'b0001000, 2'b10,     1'b1};
localparam DEC_LOAD    = {1'b0,  2'b00, 1'b1,    1'b0,     1'b1,     1'b1,  2'b00,     1'b1,   1'b0,  7'b0100000, 2'b00,     1'b1};
localparam DEC_STORE   = {1'b0,  2'b00, 1'b0,    1'b1,     1'b0,     1'b0,  2'b00,     1'b1,   1'b0,  7'b0010000, 2'b00,     1'b1};
localparam DEC_ALUI    = {1'b0,  2'b00, 1'b0,    1'b0,     1'b1,     1'b0,  2'b00,     1'b1,   1'b0,  7'b0100000, 2'b01,     1'b1};
localparam DEC_ALUR    = {1'b0,  2'b00, 1'b0,    1'b0,     1'b1,     1'b0,  2'b00,     1'b0,   1'b0,  7'b1000000, 2'b01,     1'b1};

assign  {branch, jump, mem_read, mem_write, reg_write, to_reg, result_sel, alu_src, pc_add, types, alu_ctrlop, valid_inst} = dec_array;


always @(*) begin
  //$write("%x", instr);
  case(instr[6:0])
    `OPCODE_LUI    :   dec_array <= DEC_LUI;   
    `OPCODE_AUIPC  :   dec_array <= DEC_AUIPC; 
    `OPCODE_JAL    :   dec_array <= DEC_JAL; 
    `OPCODE_JALR   :   dec_array <= DEC_JALR;   
    `OPCODE_BRANCH :   dec_array <= DEC_BRANCH; 
    `OPCODE_LOAD   :   dec_array <= DEC_LOAD;   
    `OPCODE_STORE  :   dec_array <= DEC_STORE;  
    `OPCODE_ALUI   :   dec_array <= DEC_ALUI;  
    `OPCODE_ALUR   :   dec_array <= DEC_ALUR;  
    default        :  begin
                 dec_array <= DEC_INVALID;
               //  $display("~~~decode error~~~%x", instr); 
    end
  endcase
end

// -------------------- IMM -------------------------

wire [31:0] Iimm = {{21{instr[31]}}, instr[30:20]};
wire [31:0] Simm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
wire [31:0] Bimm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
wire [31:0] Uimm = {instr[31:12], 12'b0};
wire [31:0] Jimm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};   

assign imm = {32{types[5]}} & Iimm
           | {32{types[4]}} & Simm
           | {32{types[3]}} & Bimm
           | {32{types[2]}} & Uimm
           | {32{types[1]}} & Jimm;

endmodule
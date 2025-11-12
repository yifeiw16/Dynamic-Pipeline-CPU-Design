`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 21:07:16
// Design Name: 
// Module Name: EX_Decoder
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

`include "def.vh"

module EX_Decoder(
 input wire [31:0] ex_ir,    // 输入指令
 output wire [5:0]ex_op,
 output wire [4:0]ex_shamt,
 output wire [5:0]ex_func,
 output wire [15:0]ex_imm16,
 output wire [4:0]ex_Rsc,
 output wire [4:0]ex_Rtc,
 output wire [4:0]ex_Rdc,
 output wire ex_add,         // ADD 指令
 output wire ex_addu,        // ADDU 指令
 output wire ex_sub,         // SUB 指令
 output wire ex_subu,        // SUBU 指令
 output wire ex_and,         // AND 指令
 output wire ex_or,          // OR 指令
 output wire ex_xor,         // XOR 指令
 output wire ex_nor,         // NOR 指令
 output wire ex_slt,         // SLT 指令
 output wire ex_sltu,        // SLTU 指令
 output wire ex_sll,         // SLL 指令
 output wire ex_srl,         // SRL 指令
 output wire ex_sra,         // SRA 指令
 output wire ex_sllv,        // SLLV 指令
 output wire ex_srlv,        // SRLV 指令
 output wire ex_srav,        // SRAV 指令
 output wire ex_jr,          // JR 指令
 output wire ex_addi,        // ADDI 指令
 output wire ex_addiu,       // ADDIU 指令
 output wire ex_andi,        // ANDI 指令
 output wire ex_ori,         // ORI 指令
 output wire ex_xori,        // XORI 指令
 output wire ex_lw,          // LW 指令
 output wire ex_sw,          // SW 指令
 output wire ex_beq,         // BEQ 指令
 output wire ex_bne,         // BNE 指令
 output wire ex_slti,        // SLTI 指令
 output wire ex_sltiu,       // SLTIU 指令
 output wire ex_lui,         // LUI 指令
 output wire ex_j,           // J 指令
 output wire ex_jal          // JAL 指令
);

assign ex_op = ex_ir[31:26];
assign ex_shamt = ex_ir[10:6];
assign ex_func = ex_ir[5:0];
assign ex_imm16 = ex_ir[15:0];
assign ex_Rsc = ex_ir[25:21];
assign ex_Rtc = ex_ir[20:16];
assign ex_Rdc = ex_ir[15:11];

`define EX_OP_COMMON(op) (ex_op == `OP_COMMON && ex_func == op)
`define EX_OP(op) (ex_op == op)

assign ex_add = `EX_OP_COMMON(`FUNCT_ADD);   // ADD 指令
assign ex_addu = `EX_OP_COMMON(`FUNCT_ADDU); // ADDU 指令
assign ex_sub = `EX_OP_COMMON(`FUNCT_SUB);   // SUB 指令
assign ex_subu = `EX_OP_COMMON(`FUNCT_SUBU); // SUBU 指令
assign ex_and = `EX_OP_COMMON(`FUNCT_AND);   // AND 指令
assign ex_or = `EX_OP_COMMON(`FUNCT_OR);     // OR 指令
assign ex_xor = `EX_OP_COMMON(`FUNCT_XOR);   // XOR 指令
assign ex_nor = `EX_OP_COMMON(`FUNCT_NOR);   // NOR 指令
assign ex_slt = `EX_OP_COMMON(`FUNCT_SLT);   // SLT 指令
assign ex_sltu = `EX_OP_COMMON(`FUNCT_SLTU); // SLTU 指令
assign ex_sll = `EX_OP_COMMON(`FUNCT_SLL);   // SLL 指令
assign ex_srl = `EX_OP_COMMON(`FUNCT_SRL);   // SRL 指令
assign ex_sra = `EX_OP_COMMON(`FUNCT_SRA);   // SRA 指令
assign ex_sllv = `EX_OP_COMMON(`FUNCT_SLLV); // SLLV 指令
assign ex_srlv = `EX_OP_COMMON(`FUNCT_SRLV); // SRLV 指令
assign ex_srav = `EX_OP_COMMON(`FUNCT_SRAV); // SRAV 指令
assign ex_jr = `EX_OP_COMMON(`FUNCT_JR);     // JR 指令

// Immediate 指令
assign ex_addi = `EX_OP(`OP_ADDI);    // ADDI 指令
assign ex_addiu = `EX_OP(`OP_ADDIU);  // ADDIU 指令
assign ex_andi = `EX_OP(`OP_ANDI);    // ANDI 指令
assign ex_ori = `EX_OP(`OP_ORI);      // ORI 指令
assign ex_xori = `EX_OP(`OP_XORI);    // XORI 指令
assign ex_lw = `EX_OP(`OP_LW);        // LW 指令
assign ex_sw = `EX_OP(`OP_SW);        // SW 指令
assign ex_beq = `EX_OP(`OP_BEQ);      // BEQ 指令
assign ex_bne = `EX_OP(`OP_BNE);      // BNE 指令
assign ex_slti = `EX_OP(`OP_SLTI);    // SLTI 指令
assign ex_sltiu = `EX_OP(`OP_SLTIU);  // SLTIU 指令
assign ex_lui = `EX_OP(`OP_LUI);      // LUI 指令

// Jump 指令
assign ex_j = `EX_OP(`OP_J);          // J 指令
assign ex_jal = `EX_OP(`OP_JAL);      // JAL 指令

endmodule

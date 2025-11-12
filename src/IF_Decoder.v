`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 20:38:47
// Design Name: 
// Module Name: IF_Decoder
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

module IF_Decoder(
 input wire [31:0] if_ir,    // ����ָ��
 output wire [5:0]if_op,
 output wire [4:0]if_shamt,
 output wire [5:0]if_func,
  output wire [15:0]if_imm16,
  output wire [4:0]if_Rsc,
  output wire [4:0]if_Rtc,
  output  wire [4:0]if_Rdc,
 output wire if_add,         // ADD ָ��
 output wire if_addu,        // ADDU ָ��
 output wire if_sub,         // SUB ָ��
 output wire if_subu,        // SUBU ָ��
 output wire if_and,         // AND ָ��
 output wire if_or,          // OR ָ��
 output wire if_xor,         // XOR ָ��
 output wire if_nor,         // NOR ָ��
 output wire if_slt,         // SLT ָ��
 output wire if_sltu,        // SLTU ָ��
 output wire if_sll,         // SLL ָ��
 output wire if_srl,         // SRL ָ��
 output wire if_sra,         // SRA ָ��
 output wire if_sllv,        // SLLV ָ��
 output wire if_srlv,        // SRLV ָ��
 output wire if_srav,        // SRAV ָ��
 output wire if_jr,          // JR ָ��
 output wire if_addi,        // ADDI ָ��
 output wire if_addiu,       // ADDIU ָ��
 output wire if_andi,        // ANDI ָ��
 output wire if_ori,         // ORI ָ��
 output wire if_xori,        // XORI ָ��
 output wire if_lw,          // LW ָ��
 output wire if_sw,          // SW ָ��
 output wire if_beq,         // BEQ ָ��
 output wire if_bne,         // BNE ָ��
 output wire if_slti,        // SLTI ָ��
 output wire if_sltiu,       // SLTIU ָ��
 output wire if_lui,         // LUI ָ��
 output wire if_j,           // J ָ��
 output wire if_jal  ,        // JAL ָ��
 output wire if_break ,
 output wire if_mul
    );
 
assign if_op = if_ir[31:26] ;
assign if_shamt = if_ir[10:6];
assign  if_func = if_ir[5:0];
assign if_imm16 = if_ir[15:0];
assign if_Rsc = if_ir[25:21];
assign if_Rtc = if_ir[20:16];
assign if_Rdc = if_ir[15:11];

`define IS_OP_COMMON(op) (if_op == `OP_COMMON && if_func == op)
`define IS_OP(op) (if_op == op)

assign if_add = `IS_OP_COMMON(`FUNCT_ADD);   // ADD ָ��
  assign if_addu = `IS_OP_COMMON(`FUNCT_ADDU); // ADDU ָ��
  assign if_sub = `IS_OP_COMMON(`FUNCT_SUB);   // SUB ָ��
  assign if_subu = `IS_OP_COMMON(`FUNCT_SUBU); // SUBU ָ��
  assign if_and = `IS_OP_COMMON(`FUNCT_AND);   // AND ָ��
  assign if_or = `IS_OP_COMMON(`FUNCT_OR);     // OR ָ��
  assign if_xor = `IS_OP_COMMON(`FUNCT_XOR);   // XOR ָ��
  assign if_nor = `IS_OP_COMMON(`FUNCT_NOR);   // NOR ָ��
  assign if_slt = `IS_OP_COMMON(`FUNCT_SLT);   // SLT ָ��
  assign if_sltu = `IS_OP_COMMON(`FUNCT_SLTU); // SLTU ָ��
  assign if_sll = `IS_OP_COMMON(`FUNCT_SLL);   // SLL ָ��
  assign if_srl = `IS_OP_COMMON(`FUNCT_SRL);   // SRL ָ��
  assign if_sra = `IS_OP_COMMON(`FUNCT_SRA);   // SRA ָ��
  assign if_sllv = `IS_OP_COMMON(`FUNCT_SLLV); // SLLV ָ��
  assign if_srlv = `IS_OP_COMMON(`FUNCT_SRLV); // SRLV ָ��
  assign if_srav = `IS_OP_COMMON(`FUNCT_SRAV); // SRAV ָ��
  assign if_jr = `IS_OP_COMMON(`FUNCT_JR);     // JR ָ��

  // Immediate ָ��
  assign if_addi = `IS_OP(`OP_ADDI);    // ADDI ָ��
  assign if_addiu = `IS_OP(`OP_ADDIU);  // ADDIU ָ��
  assign if_andi = `IS_OP(`OP_ANDI);    // ANDI ָ��
  assign if_ori = `IS_OP(`OP_ORI);      // ORI ָ��
  assign if_xori = `IS_OP(`OP_XORI);    // XORI ָ��
  assign if_lw = `IS_OP(`OP_LW);        // LW ָ��
  assign if_sw = `IS_OP(`OP_SW);        // SW ָ��
  assign if_beq = `IS_OP(`OP_BEQ);      // BEQ ָ��
  assign if_bne = `IS_OP(`OP_BNE);      // BNE ָ��
  assign if_slti = `IS_OP(`OP_SLTI);    // SLTI ָ��
  assign if_sltiu = `IS_OP(`OP_SLTIU);  // SLTIU ָ��
  assign if_lui = `IS_OP(`OP_LUI);      // LUI ָ��

  // Jump ָ��
  assign if_j = `IS_OP(`OP_J);          // J ָ��
  assign if_jal = `IS_OP(`OP_JAL);      // JAL ָ��

  //new here 
  assign if_break =  `IS_OP_COMMON(`FUNCT_BREAK);     // JR ָ��
  assign if_mul = (if_op == `OP_MUL) && (if_func ==`FUNCT_MUL) ;
  
  
endmodule
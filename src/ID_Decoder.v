`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 21:01:59
// Design Name: 
// Module Name: ID_Decoder
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

module ID_Decoder(
 input wire [31:0] id_ir,    // 输入指令
 output wire [5:0]id_op,
 output wire [4:0]id_shamt,
 output wire [5:0]id_func,
 output wire [15:0]id_imm16,
 output wire [4:0]id_Rsc,
 output wire [4:0]id_Rtc,
 output wire [4:0]id_Rdc,
 output wire id_add,         // ADD 指令
 output wire id_addu,        // ADDU 指令
 output wire id_sub,         // SUB 指令
 output wire id_subu,        // SUBU 指令
 output wire id_and,         // AND 指令
 output wire id_or,          // OR 指令
 output wire id_xor,         // XOR 指令
 output wire id_nor,         // NOR 指令
 output wire id_slt,         // SLT 指令
 output wire id_sltu,        // SLTU 指令
 output wire id_sll,         // SLL 指令
 output wire id_srl,         // SRL 指令
 output wire id_sra,         // SRA 指令
 output wire id_sllv,        // SLLV 指令
 output wire id_srlv,        // SRLV 指令
 output wire id_srav,        // SRAV 指令
 output wire id_jr,          // JR 指令
 output wire id_addi,        // ADDI 指令
 output wire id_addiu,       // ADDIU 指令
 output wire id_andi,        // ANDI 指令
 output wire id_ori,         // ORI 指令
 output wire id_xori,        // XORI 指令
 output wire id_lw,          // LW 指令
 output wire id_sw,          // SW 指令
 output wire id_beq,         // BEQ 指令
 output wire id_bne,         // BNE 指令
 output wire id_slti,        // SLTI 指令
 output wire id_sltiu,       // SLTIU 指令
 output wire id_lui,         // LUI 指令
 output wire id_j,           // J 指令
 output wire id_jal          // JAL 指令
);

assign id_op = id_ir[31:26];
assign id_shamt = id_ir[10:6];
assign id_func = id_ir[5:0];
assign id_imm16 = id_ir[15:0];
assign id_Rsc = id_ir[25:21];
assign id_Rtc = id_ir[20:16];
assign id_Rdc = id_ir[15:11];

`define ID_OP_COMMON(op) (id_op == `OP_COMMON && id_func == op)
`define ID_OP(op) (id_op == op)

assign id_add = `ID_OP_COMMON(`FUNCT_ADD);   // ADD 指令
assign id_addu = `ID_OP_COMMON(`FUNCT_ADDU); // ADDU 指令
assign id_sub = `ID_OP_COMMON(`FUNCT_SUB);   // SUB 指令
assign id_subu = `ID_OP_COMMON(`FUNCT_SUBU); // SUBU 指令
assign id_and = `ID_OP_COMMON(`FUNCT_AND);   // AND 指令
assign id_or = `ID_OP_COMMON(`FUNCT_OR);     // OR 指令
assign id_xor = `ID_OP_COMMON(`FUNCT_XOR);   // XOR 指令
assign id_nor = `ID_OP_COMMON(`FUNCT_NOR);   // NOR 指令
assign id_slt = `ID_OP_COMMON(`FUNCT_SLT);   // SLT 指令
assign id_sltu = `ID_OP_COMMON(`FUNCT_SLTU); // SLTU 指令
assign id_sll = `ID_OP_COMMON(`FUNCT_SLL);   // SLL 指令
assign id_srl = `ID_OP_COMMON(`FUNCT_SRL);   // SRL 指令
assign id_sra = `ID_OP_COMMON(`FUNCT_SRA);   // SRA 指令
assign id_sllv = `ID_OP_COMMON(`FUNCT_SLLV); // SLLV 指令
assign id_srlv = `ID_OP_COMMON(`FUNCT_SRLV); // SRLV 指令
assign id_srav = `ID_OP_COMMON(`FUNCT_SRAV); // SRAV 指令
assign id_jr = `ID_OP_COMMON(`FUNCT_JR);     // JR 指令

// Immediate 指令
assign id_addi = `ID_OP(`OP_ADDI);    // ADDI 指令
assign id_addiu = `ID_OP(`OP_ADDIU);  // ADDIU 指令
assign id_andi = `ID_OP(`OP_ANDI);    // ANDI 指令
assign id_ori = `ID_OP(`OP_ORI);      // ORI 指令
assign id_xori = `ID_OP(`OP_XORI);    // XORI 指令
assign id_lw = `ID_OP(`OP_LW);        // LW 指令
assign id_sw = `ID_OP(`OP_SW);        // SW 指令
assign id_beq = `ID_OP(`OP_BEQ);      // BEQ 指令
assign id_bne = `ID_OP(`OP_BNE);      // BNE 指令
assign id_slti = `ID_OP(`OP_SLTI);    // SLTI 指令
assign id_sltiu = `ID_OP(`OP_SLTIU);  // SLTIU 指令
assign id_lui = `ID_OP(`OP_LUI);      // LUI 指令

// Jump 指令
assign id_j = `ID_OP(`OP_J);          // J 指令
assign id_jal = `ID_OP(`OP_JAL);      // JAL 指令

endmodule

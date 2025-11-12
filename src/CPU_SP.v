`timescale 1ns / 1ps
`include "def.vh"
module CPU(
  input clk,
  input rst,
  input [31:0] IMEM_instruction,
  output [31:0] pc_out

);
reg JUMP_halt;
reg RAW_halt;

 wire [31:0] IFInstruction;
 wire [31:0]if_ir = IFInstruction;
 
 wire [31:0]ifID_ir;
 wire [31:0]ID_ir = ifID_ir;
 
 wire [31:0]IDEX_ir;
 wire [31:0]EX_ir = IDEX_ir;
 
  wire [31:0]EX_MEM_ir;
 wire [31:0]MEM_ir = EX_MEM_ir;
 
  wire [31:0]MEM_WBack_ir;
 wire [31:0]WBack_ir = MEM_WBack_ir;

 // ���Ƚ���ָ������
 // IF
 wire [5:0]if_op ;
 wire [4:0]if_shamt;
 wire [5:0]if_func ;
 wire [15:0]if_imm16 ;
 wire [4:0]if_Rsc ;
 wire [4:0]if_Rtc;
 wire [4:0]if_Rdc ;
 

wire if_addu, if_sub, if_subu,if_add,if_mul,if_break;
 wire if_and, if_or, if_xor, if_nor, if_slt, if_sltu, if_sll, if_srl, if_sra, if_sllv, if_srlv, if_srav, if_jr;
 
 // Immediate instructions
 wire if_addi, if_addiu, if_andi, if_ori, if_xori, if_lw, if_sw, if_beq, if_bne, if_slti, if_sltiu, if_lui;
 
 // Jump instructions
 wire if_j, if_jal;

IF_Decoder IF_Decoder (
  .if_ir(if_ir),
  .if_op(if_op),
  .if_shamt(if_shamt),
  .if_func(if_func),
  .if_imm16(if_imm16),
  .if_Rsc(if_Rsc),
  .if_Rtc(if_Rtc),
  .if_Rdc(if_Rdc),
  .if_add(if_add),
  .if_addu(if_addu),
  .if_sub(if_sub),
  .if_subu(if_subu),
  .if_and(if_and),
  .if_or(if_or),
  .if_xor(if_xor),
  .if_nor(if_nor),
  .if_slt(if_slt),
  .if_sltu(if_sltu),
  .if_sll(if_sll),
  .if_srl(if_srl),
  .if_sra(if_sra),
  .if_sllv(if_sllv),
  .if_srlv(if_srlv),
  .if_srav(if_srav),
  .if_jr(if_jr),
  .if_addi(if_addi),
  .if_addiu(if_addiu),
  .if_andi(if_andi),
  .if_ori(if_ori),
  .if_xori(if_xori),
  .if_lw(if_lw),
  .if_sw(if_sw),
  .if_beq(if_beq),
  .if_bne(if_bne),
  .if_slti(if_slti),
  .if_sltiu(if_sltiu),
  .if_lui(if_lui),
  .if_j(if_j),


  //new here
  .if_jal(if_jal),
  .if_mul(if_mul)
);

// ID ��
wire [5:0] ID_op = ID_ir[31:26];
wire [4:0] ID_shamt = ID_ir[10:6];
wire [5:0] ID_func = ID_ir[5:0];
wire [15:0] ID_imm16 = ID_ir[15:0];
wire [4:0] ID_Rsc = ID_ir[25:21];
wire [4:0] ID_Rtc = ID_ir[20:16];
wire [4:0] ID_Rdc = ID_ir[15:11];

`define ID_OP_COMMON(op) (ID_op == `OP_COMMON && ID_func == op)
`define ID_OP(op) (ID_op == op)

// ID stage ALU instructions
wire ID_add = `ID_OP_COMMON(`FUNCT_ADD);
wire ID_addu = `ID_OP_COMMON(`FUNCT_ADDU);
wire ID_sub = `ID_OP_COMMON(`FUNCT_SUB);
wire ID_subu = `ID_OP_COMMON(`FUNCT_SUBU);
wire ID_and = `ID_OP_COMMON(`FUNCT_AND);
wire ID_or = `ID_OP_COMMON(`FUNCT_OR);
wire ID_xor = `ID_OP_COMMON(`FUNCT_XOR);
wire ID_nor = `ID_OP_COMMON(`FUNCT_NOR);
wire ID_slt = `ID_OP_COMMON(`FUNCT_SLT);
wire ID_sltu = `ID_OP_COMMON(`FUNCT_SLTU);
wire ID_sll = `ID_OP_COMMON(`FUNCT_SLL);
wire ID_srl = `ID_OP_COMMON(`FUNCT_SRL);
wire ID_sra = `ID_OP_COMMON(`FUNCT_SRA);
wire ID_sllv = `ID_OP_COMMON(`FUNCT_SLLV);
wire ID_srlv = `ID_OP_COMMON(`FUNCT_SRLV);
wire ID_srav = `ID_OP_COMMON(`FUNCT_SRAV);
wire ID_jr = `ID_OP_COMMON(`FUNCT_JR);

// ID stage Immediate instructions
wire ID_addi = `ID_OP(`OP_ADDI);
wire ID_addiu = `ID_OP(`OP_ADDIU);
wire ID_andi = `ID_OP(`OP_ANDI);
wire ID_ori = `ID_OP(`OP_ORI);
wire ID_xori = `ID_OP(`OP_XORI);
wire ID_lw = `ID_OP(`OP_LW);
wire ID_sw = `ID_OP(`OP_SW);
wire ID_beq = `ID_OP(`OP_BEQ);
wire ID_bne = `ID_OP(`OP_BNE);
wire ID_slti = `ID_OP(`OP_SLTI);
wire ID_sltiu = `ID_OP(`OP_SLTIU);
wire ID_lui = `ID_OP(`OP_LUI);

// ID stage Jump instructions
wire ID_j = `ID_OP(`OP_J);
wire ID_jal = `ID_OP(`OP_JAL);

//new here
wire ID_mul = (ID_op == `OP_MUL) && (ID_func ==`FUNCT_MUL) ;
wire ID_break = `ID_OP_COMMON(`FUNCT_BREAK);

// EX ��
wire [5:0] EX_op = EX_ir[31:26];
wire [4:0] EX_shamt = EX_ir[10:6];
wire [5:0] EX_func = EX_ir[5:0];
wire [15:0] EX_imm16 = EX_ir[15:0];
wire [4:0] EX_Rsc = EX_ir[25:21];
wire [4:0] EX_Rtc = EX_ir[20:16];
wire [4:0] EX_Rdc = EX_ir[15:11];

`define EX_OP_COMMON(func) (EX_op == 6'b000000 && EX_func == func)
`define EX_OP(op) (EX_op == op)

// EX stage ALU instructions
wire EX_add = `EX_OP_COMMON(`FUNCT_ADD);
wire EX_addu = `EX_OP_COMMON(`FUNCT_ADDU);
wire EX_sub = `EX_OP_COMMON(`FUNCT_SUB);
wire EX_subu = `EX_OP_COMMON(`FUNCT_SUBU);
wire EX_and = `EX_OP_COMMON(`FUNCT_AND);
wire EX_or = `EX_OP_COMMON(`FUNCT_OR);
wire EX_xor = `EX_OP_COMMON(`FUNCT_XOR);
wire EX_nor = `EX_OP_COMMON(`FUNCT_NOR);
wire EX_slt = `EX_OP_COMMON(`FUNCT_SLT);
wire EX_sltu = `EX_OP_COMMON(`FUNCT_SLTU);
wire EX_sll = `EX_OP_COMMON(`FUNCT_SLL);
wire EX_srl = `EX_OP_COMMON(`FUNCT_SRL);
wire EX_sra = `EX_OP_COMMON(`FUNCT_SRA);
wire EX_sllv = `EX_OP_COMMON(`FUNCT_SLLV);
wire EX_srlv = `EX_OP_COMMON(`FUNCT_SRLV);
wire EX_srav = `EX_OP_COMMON(`FUNCT_SRAV);
wire EX_jr = `EX_OP_COMMON(`FUNCT_JR);

// EX stage Immediate instructions
wire EX_addi = `EX_OP(`OP_ADDI);
wire EX_addiu = `EX_OP(`OP_ADDIU);
wire EX_andi = `EX_OP(`OP_ANDI);
wire EX_ori = `EX_OP(`OP_ORI);
wire EX_xori = `EX_OP(`OP_XORI);
wire EX_lw = `EX_OP(`OP_LW);
wire EX_sw = `EX_OP(`OP_SW);
wire EX_beq = `EX_OP(`OP_BEQ);
wire EX_bne = `EX_OP(`OP_BNE);
wire EX_slti = `EX_OP(`OP_SLTI);
wire EX_sltiu = `EX_OP(`OP_SLTIU);
wire EX_lui = `EX_OP(`OP_LUI);

// EX stage Jump instructions
wire EX_j = `EX_OP(`OP_J);
wire EX_jal = `EX_OP(`OP_JAL);

//new here
wire EX_mul = (EX_op == `OP_MUL) && (EX_func ==`FUNCT_MUL) ;
wire EX_break = `EX_OP_COMMON(`FUNCT_BREAK);

// MEM ��
wire [5:0] MEM_op = MEM_ir[31:26];
wire [4:0] MEM_shamt = MEM_ir[10:6];
wire [5:0] MEM_func = MEM_ir[5:0];
wire [15:0] MEM_imm16 = MEM_ir[15:0];
wire [4:0] MEM_Rsc = MEM_ir[25:21];
wire [4:0] MEM_Rtc = MEM_ir[20:16];
wire [4:0] MEM_Rdc = MEM_ir[15:11];

`define MEM_OP_COMMON(func) (MEM_op == 6'b000000 && MEM_func == func)
`define MEM_OP(op) (MEM_op == op)

// ME stage ALU instructions
wire MEM_add = `MEM_OP_COMMON(`FUNCT_ADD);
wire MEM_addu = `MEM_OP_COMMON(`FUNCT_ADDU);
wire MEM_sub = `MEM_OP_COMMON(`FUNCT_SUB);
wire MEM_subu = `MEM_OP_COMMON(`FUNCT_SUBU);
wire MEM_and = `MEM_OP_COMMON(`FUNCT_AND);
wire MEM_or = `MEM_OP_COMMON(`FUNCT_OR);
wire MEM_xor = `MEM_OP_COMMON(`FUNCT_XOR);
wire MEM_nor = `MEM_OP_COMMON(`FUNCT_NOR);
wire MEM_slt = `MEM_OP_COMMON(`FUNCT_SLT);
wire MEM_sltu = `MEM_OP_COMMON(`FUNCT_SLTU);
wire MEM_sll = `MEM_OP_COMMON(`FUNCT_SLL);
wire MEM_srl = `MEM_OP_COMMON(`FUNCT_SRL);
wire MEM_sra = `MEM_OP_COMMON(`FUNCT_SRA);
wire MEM_sllv = `MEM_OP_COMMON(`FUNCT_SLLV);
wire MEM_srlv = `MEM_OP_COMMON(`FUNCT_SRLV);
wire MEM_srav = `MEM_OP_COMMON(`FUNCT_SRAV);
wire MEM_jr = `MEM_OP_COMMON(`FUNCT_JR);

// ME stage Immediate instructions
wire MEM_addi = `MEM_OP(`OP_ADDI);
wire MEM_addiu = `MEM_OP(`OP_ADDIU);
wire MEM_andi = `MEM_OP(`OP_ANDI);
wire MEM_ori = `MEM_OP(`OP_ORI);
wire MEM_xori = `MEM_OP(`OP_XORI);
wire MEM_lw = `MEM_OP(`OP_LW);
wire MEM_sw = `MEM_OP(`OP_SW);
wire MEM_beq = `MEM_OP(`OP_BEQ);
wire MEM_bne = `MEM_OP(`OP_BNE);
wire MEM_slti = `MEM_OP(`OP_SLTI);
wire MEM_sltiu = `MEM_OP(`OP_SLTIU);
wire MEM_lui = `MEM_OP(`OP_LUI);

// ME stage Jump instructions
wire MEM_j = `MEM_OP(`OP_J);
wire MEM_jal = `MEM_OP(`OP_JAL);

//new here
wire MEM_mul = (MEM_op == `OP_MUL) && (MEM_func ==`FUNCT_MUL) ;
wire MEM_break = `MEM_OP_COMMON(`FUNCT_BREAK);


// WBack ��
wire [5:0] WBack_op = WBack_ir[31:26];
wire [4:0] WBack_shamt = WBack_ir[10:6];
wire [5:0] WBack_func = WBack_ir[5:0];
wire [15:0] WBack_imm16 = WBack_ir[15:0];
wire [4:0] WBack_Rsc = WBack_ir[25:21];
wire [4:0] WBack_Rtc = WBack_ir[20:16];
wire [4:0] WBack_Rdc = WBack_ir[15:11];

`define WBack_OP_COMMON(func) (WBack_op == 6'b000000 && WBack_func == func)
`define WBack_OP(op) (WBack_op == op)

// WBack stage ALU instructions
wire WBack_add = `WBack_OP_COMMON(`FUNCT_ADD);
wire WBack_addu = `WBack_OP_COMMON(`FUNCT_ADDU);
wire WBack_sub = `WBack_OP_COMMON(`FUNCT_SUB);
wire WBack_subu = `WBack_OP_COMMON(`FUNCT_SUBU);
wire WBack_and = `WBack_OP_COMMON(`FUNCT_AND);
wire WBack_or = `WBack_OP_COMMON(`FUNCT_OR);
wire WBack_xor = `WBack_OP_COMMON(`FUNCT_XOR);
wire WBack_nor = `WBack_OP_COMMON(`FUNCT_NOR);
wire WBack_slt = `WBack_OP_COMMON(`FUNCT_SLT);
wire WBack_sltu = `WBack_OP_COMMON(`FUNCT_SLTU);
wire WBack_sll = `WBack_OP_COMMON(`FUNCT_SLL);
wire WBack_srl = `WBack_OP_COMMON(`FUNCT_SRL);
wire WBack_sra = `WBack_OP_COMMON(`FUNCT_SRA);
wire WBack_sllv = `WBack_OP_COMMON(`FUNCT_SLLV);
wire WBack_srlv = `WBack_OP_COMMON(`FUNCT_SRLV);
wire WBack_srav = `WBack_OP_COMMON(`FUNCT_SRAV);
wire WBack_jr = `WBack_OP_COMMON(`FUNCT_JR);

// 18-29 WBack_op2-4 bits
wire WBack_addi = `WBack_OP(6'b001000);
wire WBack_addiu = `WBack_OP(6'b001001);
wire WBack_andi = `WBack_OP(6'b001100);
wire WBack_ori = `WBack_OP(6'b001101);
wire WBack_xori = `WBack_OP(6'b001110);
wire WBack_lw = `WBack_OP(6'b100011);
wire WBack_sw = `WBack_OP(6'b101011);
wire WBack_beq = `WBack_OP(6'b000100);
wire WBack_bne = `WBack_OP(6'b000101);
wire WBack_slti = `WBack_OP(6'b001010);
wire WBack_sltiu = `WBack_OP(6'b001011);
wire WBack_lui = `WBack_OP(6'b001111);

// 30-31 WBack_op 2 bits
wire WBack_j = `WBack_OP(6'b000010);
wire WBack_jal = `WBack_OP(6'b000011);

//new here
wire WBack_mul = (WBack_op == `OP_MUL) && (WBack_func ==`FUNCT_MUL) ;
wire WBack_break = `WBack_OP_COMMON(`FUNCT_BREAK);

//�ж�д��������ݳ�ͻ ǰһָ�ûд�루��ǰMEM�Σ���һָ���п��ܶ�����ǰID�Σ���
//����MEM�����п���д���ָ��
wire Reg_ID_W ;
assign Reg_ID_W = ID_addi || ID_addiu || ID_andi || ID_ori || ID_sltiu || ID_lui || ID_xori || ID_slti || ID_sltiu || ID_lui ||
                   ID_add || ID_addu || ID_sub || ID_subu || ID_or || ID_xor || ID_nor || ID_slt || ID_sltu || ID_sll || ID_sllv || 
                   ID_sra || ID_srl || ID_subu || ID_and || ID_sub || ID_srlv || ID_srav || ID_mul;

reg [4:0]Reg_ID_W_address;
always @ (*) begin
    if(ID_add || ID_addu || ID_sub || ID_subu || ID_and || ID_or || ID_xor || ID_nor || ID_slt || ID_sltu || ID_sll || ID_srl || ID_sra ||
       ID_sllv || ID_srlv|| ID_srav || ID_mul)
        Reg_ID_W_address <= ID_Rdc;
    else if (ID_addi || ID_addiu || ID_andi || ID_ori || ID_xori || ID_lw || ID_slti || ID_sltiu || ID_lui)
        Reg_ID_W_address <= ID_Rtc;
    else if (ID_jal)
        Reg_ID_W_address = 5'd31;
    
end

wire Reg_MEM_W ;
assign Reg_MEM_W = MEM_addi || MEM_addiu || MEM_andi || MEM_ori || MEM_sltiu || MEM_lui || MEM_xori || MEM_slti || MEM_sltiu || MEM_lui ||
                   MEM_add || MEM_addu || MEM_sub || MEM_subu || MEM_or || MEM_xor || MEM_nor || MEM_slt || MEM_sltu || MEM_sll || MEM_sllv || 
                   MEM_sra || MEM_srl || MEM_subu || MEM_and || MEM_sub || MEM_srlv || MEM_srav || MEM_mul;

reg [4:0]Reg_MEM_W_address;
always @ (*) begin
    if(MEM_add || MEM_addu || MEM_sub || MEM_subu || MEM_and || MEM_or || MEM_xor || MEM_nor || MEM_slt || MEM_sltu || MEM_sll || MEM_srl || MEM_sra ||
       MEM_sllv || MEM_srlv|| MEM_srav || MEM_mul)
        Reg_MEM_W_address <= MEM_Rdc;
    else if (MEM_addi || MEM_addiu || MEM_andi || MEM_ori ||MEM_xori || MEM_lw || MEM_slti || MEM_sltiu || MEM_lui )
        Reg_MEM_W_address <= MEM_Rtc;
    else if (MEM_jal)
        Reg_MEM_W_address = 5'd31;
    
end

wire Reg_EX_W ;
assign Reg_EX_W = EX_addi || EX_addiu || EX_andi || EX_ori || EX_sltiu || EX_lui || EX_xori || EX_slti || EX_sltiu || EX_lui ||
                   EX_add || EX_addu || EX_sub || EX_subu || EX_or || EX_xor || EX_nor || EX_slt || EX_sltu || EX_sll || EX_sllv || 
                   EX_sra || EX_srl || EX_subu || EX_and || EX_sub || EX_srlv || EX_srav || EX_mul ;

reg [4:0]Reg_EX_W_address;
always @ (*) begin
    if(EX_add || EX_addu || EX_sub || EX_subu || EX_and || EX_or || EX_xor || EX_nor || EX_slt || EX_sltu || EX_sll || EX_srl || EX_sra ||
       EX_sllv || EX_srlv|| EX_srav || EX_mul)
        Reg_EX_W_address <= EX_Rdc;
    else if (EX_addi || EX_addiu || EX_andi || EX_ori ||EX_xori || EX_lw || EX_slti || EX_sltiu || EX_lui )
        Reg_EX_W_address <= EX_Rtc;
    else if (MEM_jal)
        Reg_EX_W_address = 5'd31;
    
end


wire Reg_ID_RS;  
wire  Reg_ID_RT;
                 
assign Reg_ID_RS = ID_addi || ID_addiu || ID_andi || ID_ori || ID_slti || ID_lui || ID_xori || ID_sltiu || ID_lui || ID_lw ||ID_sw ||
                   ID_add || ID_addu ||ID_sub || ID_subu || ID_and|| ID_or || ID_xor ||  ID_nor || ID_slt || ID_sltu || ID_sll || ID_sllv ||   
                   ID_sra || ID_srl || ID_subu || ID_sub || ID_srlv || ID_srav || ID_beq || ID_bne ||ID_jr || ID_mul ;
        
assign Reg_ID_RT = ID_sw || ID_add || ID_addu ||ID_sub || ID_subu || ID_and|| ID_or || ID_xor ||  ID_nor 
                   || ID_slt || ID_sltu || ID_sllv ||   
                  ID_subu || ID_sub || ID_srlv || ID_srav || ID_beq|| ID_bne || ID_bne || ID_srl || ID_mul ;              

wire [4:0] RT_ID_R_address;
wire [4:0] RS_ID_R_address;
assign  RT_ID_R_address =Reg_ID_RT ? ID_Rtc :5'hz  ;
assign  RS_ID_R_address =Reg_ID_RS ? ID_Rsc : 5'hz;

always @ (*) begin
   
end

//��תָ��
//IF��ʱ�����֪������תָ�Ҫ����һָ���������ID,EX,MEM�ε�ָ��᲻���޸���תָ����صļĴ���ֵ��
wire jump_inst = if_jr||if_bne||if_beq ;
//jr��������ת�Ƶ�rs��

//halt
always @ (*) begin
    JUMP_halt = 0 ;
    RAW_halt = 0;
  
    if(jump_inst) begin   //��תָ���ͻ
        if(Reg_ID_W ==1) begin
                if(Reg_ID_W_address == if_Rsc) begin
                  
                   JUMP_halt = 1;end
                if((if_bne||if_beq) && Reg_ID_W_address == if_Rtc) begin
                  
                    JUMP_halt = 1;end
        end
        if(Reg_EX_W ==1) begin
                        if(Reg_EX_W_address == if_Rsc) begin
                          
                           JUMP_halt = 1;end
                        if((if_bne||if_beq) && Reg_EX_W_address == if_Rtc) begin
                           
                            JUMP_halt = 1;end
                end
       if(Reg_MEM_W ==1) begin
                         if(Reg_MEM_W_address == if_Rsc) begin
                              
                               JUMP_halt = 1;end
                          if((if_bne||if_beq) && Reg_MEM_W_address == if_Rtc) begin
                              
                               JUMP_halt = 1;end
              end

         
    end
end

// IF
// pc
wire [31:0] If_Pc_MUX_Out;
wire [31:0] IF_Pc_Out_Final;
assign pc_out = IF_Pc_Out_Final;
assign IFInstruction = IMEM_instruction;
//wire pc_ena = 1'b1;

pc_reg pc_reg(
    .clk(clk),
    .rst(rst),
    .ena(1'b1),
    .in_data(If_Pc_MUX_Out),
    .out_data(IF_Pc_Out_Final)
);

//ID_jr  ->   ID_regfile_d1
//ID_bne  ID_beq  ->  IF_ID_NPC+ID_EXT18,
//ID_jal||ID_j  ->  {IF_ID_NPC[31:28],ifID_ir[25:0],2'b0}
//���� IF_ID_NPC

//mux_PC
// IF/ID ���źţ����Ӷζ��ǼĴ���
wire [31:0]IF_ID_NPC;
wire [31:0] ID_regfile_d1; // RegFile ��һ�����ݣ�Rs��
wire [31:0] ID_regfile_d2; // RegFile �ڶ������ݣ�Rt��
assign If_Pc_MUX_Out= ID_jr ? ID_regfile_d1 : (((ID_bne & !ID_EQUAL)||(ID_beq & ID_EQUAL)) ? IF_ID_NPC+ID_EXT18 :(( (ID_jal||ID_j) ? {IF_ID_NPC[31:28],ifID_ir[25:0],2'b0} : IF_ID_NPC)));

// �����֮����ź����ӣ�reg ���Ӹ�ֵ
// IF/ID ��

IF_ID if_ID_module (
  .clk(clk),
  .rst(rst),
  .if_break(if_break),
  .JUMP_halt(JUMP_halt),
  .RAW_halt(RAW_halt),
  .If_instruction(IFInstruction),
  .If_PC(IF_Pc_Out_Final),
  .IfId_Npc(IF_ID_NPC),  // Connect to your existing signal
  .IfId_Ir(ifID_ir)    // Connect to your existing signal
);

//����ǰ�ƣ��� ID �εģ���Ҫ�ж�һ���Ƿ���Ҫǰ�ƣ��Լ��� EX ���� MEM ǰ������
reg [31:0] data_forward_rs;
reg [31:0] data_forward_rt;
wire [63:0]exme_mul_out;
wire [63:0]ex_mul_out;

wire [31:0]EX_MEM_my_ALU_out;
wire [31:0]EX_my_ALU_out;   //�ӷ���
//����ǰ��
//MUL �� rd
always @(*)
begin

  if( Reg_MEM_W)
  begin
    if(Reg_MEM_W_address == ID_Rsc &&  Reg_ID_RS )
    begin
      if(MEM_mul == 1 )
        data_forward_rs = exme_mul_out[31:0];
      else
        data_forward_rs = EX_MEM_my_ALU_out;
    end
    else if (Reg_MEM_W_address == ID_Rtc && Reg_ID_RT)
    begin
      if(MEM_mul == 1)
        data_forward_rt = exme_mul_out[31:0];
      else
        data_forward_rt = EX_MEM_my_ALU_out;
    end
  end

  if (Reg_EX_W)
  begin
    if (Reg_EX_W_address == ID_Rsc && Reg_ID_RS )
    begin
      if(EX_mul == 1 )
        data_forward_rs = ex_mul_out[31:0];
      else
        data_forward_rs = EX_my_ALU_out;
    end
    else if ( Reg_EX_W_address == ID_Rtc && Reg_ID_RT )
    begin
      if(EX_mul == 1)
        data_forward_rt = ex_mul_out[31:0];
      else
        data_forward_rt = EX_my_ALU_out;
    end
  end
end


// WBack ���ź�
  wire [31:0]WBack_mux_data_out;
  wire [4:0]WBack_mux_addr_out;
  wire WBack_rf_wena;


// regfile
assign ena=1'b1;
cpu_regfile cpu_regfile(
  .reg_clk(clk),        // ʱ��
  .reg_rst(rst),        // ��λ
  .reg_ena(ena),        // ʹ���ź�
  .reg_wena(WBack_rf_wena),      // дʹ���ź�
  .raddr1(ID_Rsc),  // ����ַ1
  .raddr2(ID_Rtc),  // ����ַ2
  .waddr(WBack_mux_addr_out),   // д��ַ
  .wdata(WBack_mux_data_out),   // д����
  .rdata1(ID_regfile_d1), // ������1
  .rdata2(ID_regfile_d2)  // ������2
);


wire ID_EQUAL; 
assign ID_EQUAL = (ID_regfile_d1 == ID_regfile_d2);

//alua alub
wire [2:0] ID_mux_my_ALUa_selector;
assign ID_mux_my_ALUa_selector[0]=ID_sra||ID_srl||ID_sll;  //data0   ->ID_EXT5
assign ID_mux_my_ALUa_selector[1]=ID_jal;  //data1 -> IF_ID_NPC
assign ID_mux_my_ALUa_selector[2]=!(ID_sra||ID_srl||ID_sll||ID_jal);  // data2 ->ID_regfile_d1

 wire [31:0] ID_EXT5;
 wire [31:0] ID_EXT16;
 wire [31:0] ID_EXT18;
wire [31:0]EXT16;
wire [31:0] EXT16_sign;

assign EXT16_sign = {{16{ifID_ir[15]}},ifID_ir[15:0]}; //�з�����չ
assign EXT16 = { {16{1'b0}}, ifID_ir[15:0]};
assign ID_EXT16= (ID_addi||ID_addiu||ID_slti||ID_sltiu||ID_lw) ? EXT16_sign : EXT16;

wire [31:0] EXT5;
wire [31:0] EXT18;
assign ID_EXT5 = { 27'b0,ifID_ir[10:6]}; 

assign ID_EXT18 = {{14{ifID_ir[15]}},{ifID_ir[15:0],2'b00}}; 



 wire [31:0] ID_mux_my_ALUa_out; 
 wire [31:0] ID_mux_my_ALUb_out; 


//
wire [2:0] ID_mux_my_ALUb_selector;
assign ID_mux_my_ALUb_selector[0] = ID_jal;  //data0 -> 4 
assign ID_mux_my_ALUb_selector[1] = ID_addi||ID_addiu||ID_andi||ID_ori||ID_sltiu||ID_lui||ID_xori||ID_slti||ID_lw||ID_sw;  //data1 ->ID_EXT16
assign ID_mux_my_ALUb_selector[2] = !(ID_addi||ID_addiu||ID_andi||ID_ori||ID_sltiu||ID_lui||ID_xori||ID_slti||ID_lw||ID_sw||ID_jal); //data2 -> ID_regfile_d2


//����ǰ�Ƶ���ʱ����
wire [31:0]temp_rs,temp_rt;

assign temp_rs = ((Reg_MEM_W && Reg_ID_RS && Reg_MEM_W_address == ID_Rsc)||
(Reg_EX_W && Reg_ID_RS && Reg_EX_W_address == ID_Rsc))?data_forward_rs:
ID_regfile_d1;
assign temp_rt = ((Reg_MEM_W && Reg_ID_RT && Reg_MEM_W_address == ID_Rtc)||
(Reg_EX_W && Reg_ID_RT && Reg_EX_W_address == ID_Rtc))? data_forward_rt:
ID_regfile_d2;
ThreeInputSelector MUX_ALUA(ID_EXT5,IF_ID_NPC,temp_rs,
                            ID_mux_my_ALUa_selector,
                            ID_mux_my_ALUa_out);
                            
ThreeInputSelector MUX_my_ALUB(4,ID_EXT16,temp_rt,
                            ID_mux_my_ALUb_selector,
                            ID_mux_my_ALUb_out);

assign ID_pass_data = (ID_sw)?temp_rt:32'bz;

// ID_EX
wire [31:0]IDEX_my_ALUa;
wire [31:0]IDEX_my_ALUb;

wire [31:0] ID_EX_pass_data; 

 ID_EX ID_ex_instance(
    .clk(clk),
    .rst(rst),
    .RAW_halt(RAW_halt),
    .id_mux_alua_out(ID_mux_my_ALUa_out),
    .id_mux_alub_out(ID_mux_my_ALUb_out),
    .id_pass_data(ID_pass_data),
    .ifid_ir(ifID_ir),
    .IdExAluA(IDEX_my_ALUa),
    .IdExAluB(IDEX_my_ALUb),
    .IdEx_transfer(ID_EX_pass_data),
    .IdEx_Ir(IDEX_ir)
  );
  
// EX
wire negative,overflow,carry,zero;


wire [3:0] my_ALUC;

// Use conditional assignments to set individual bits
assign my_ALUC[3] = (EX_slt || EX_sltu || EX_sllv || EX_srlv || EX_srav || EX_sll || EX_srl || EX_sra || EX_slti || EX_sltiu || EX_lui) ? 1'b1 : 1'b0;
assign my_ALUC[2] = (EX_and || EX_or || EX_xor || EX_nor || EX_sllv || EX_srlv || EX_srav || EX_sll || EX_srl || EX_sra || EX_andi || EX_ori || EX_xori) ? 1'b1 : 1'b0;
assign my_ALUC[1] = (EX_add || EX_sub || EX_xor || EX_nor || EX_slt || EX_sltu || EX_sllv || EX_addi || EX_xori || EX_slti || EX_sltiu || EX_beq || EX_bne) ? 1'b1 : 1'b0;
assign my_ALUC[0] = (EX_sub || EX_subu || EX_or || EX_nor || EX_slt || EX_srlv || EX_srl || EX_ori || EX_slti || EX_beq || EX_bne) ? 1'b1 : 1'b0;


my_ALU ALU_instance(
    .operator_a(IDEX_my_ALUa),
    .operator_b(IDEX_my_ALUb),
    .alu_controller(my_ALUC),
    .result(EX_my_ALU_out),
    .zero(zero),
    .carry(carry),
    .negative(negative),
    .overflow(overflow)
);



   
MUL MUL(
 .clk(clk),
 .rst(rst),
 .MUL_controller(1'b1),
 .a(IDEX_my_ALUa),
 .b(IDEX_my_ALUb),
 .z(ex_mul_out)
);

// EX_MEM
 wire EX_MEM_overflowFlag;
 wire [31:0] EX_MEM_pass_data; 
 
 wire [31:0]EX_MEM_my_ALUb;
 
EX_MEM EX_MEM_inst (
  .clk(clk),
  .rst(rst),
  .ExAluOut(EX_my_ALU_out),          // Connect to the appropriate signal
  .IdExPassData(ID_EX_pass_data),
  .IdExIr(IDEX_ir),
  .overflow(overflow),
  .IdExAlub(IDEX_my_ALUb),           
  .ex_mul_out(ex_mul_out),
  
  .EX_mul (EX_mul),
  .ExMeAluOut(EX_MEM_my_ALU_out),
  .ExMePassData(EX_MEM_pass_data),
  .ExMeIr(EX_MEM_ir),
  .ExMeOverflowFlag(EX_MEM_overflowFlag),
  .ExMeAlub(EX_MEM_my_ALUb),
  .exme_mul_out(exme_mul_out)
);


//MEM
assign DM_W = MEM_sw;
assign DM_R = MEM_lw;
assign DM_wdata = EX_MEM_pass_data;
assign DM_addr = EX_MEM_my_ALU_out;

//MEM_WB
// MEM ���ź�
// WBack ���ź�

  wire [31:0]MEM_dmem_out;
  wire [31:0]MEM_dm_wdata;
  wire [31:0]MEM_dm_addr;
 
  wire [31:0]MEM_WBack_my_ALU_out;
 
  wire [31:0]MEM_WBack_my_ALUb;
  reg [31:0]MEM_WBack_mdr;

  wire MEM_WBack_overflowFlag;
  wire [31:0] MEM_WBack_pass_data;
  
  wire [63:0] MemWb_mul_out;


  
MEM_WB mem_wb_inst (
  .clk(clk),
  .rst(rst),
  .MeLw(MEM_lw),
  .MeDmemOut(MEM_dmem_out),
  .ExMeAluOut(EX_MEM_my_ALU_out),
  .ExMePassData(EX_MEM_pass_data),
  .ExMeIr(EX_MEM_ir),
  .exme_mul_out(exme_mul_out),
  
  .ExMeOverflowFlag(EX_MEM_overflowFlag),
  .ExMeAlub(EX_MEM_my_ALUb),
  .MemWbAluOut(MEM_WBack_my_ALU_out),
  .MeWbPassData(MEM_WBack_pass_data),
  .MemWbIr(MEM_WBack_ir),
  .MemWbOverflowFlag(MEM_WBack_overflowFlag),
  .MemWbAlub( MEM_WBack_my_ALUb),
  . MemWb_mul_out( MemWb_mul_out)
);


//WBack
assign WBack_rf_wena = ((!WBack_sw)&&(!WBack_beq)&&(!WBack_bne)&&(!WBack_j)&&(!WBack_jr)&&(!WBack_break)) ? 1'b1 : 1'b0;  //��regfileдʹ���ź�

assign WBack_mux_data_out = WBack_lw ? MEM_WBack_mdr :( WBack_mul ?MemWb_mul_out : MEM_WBack_my_ALU_out);

assign M1 = (WBack_addi||WBack_addiu||WBack_andi||WBack_ori||WBack_sltiu||WBack_lui||WBack_xori||WBack_lw||WBack_slti) ? 2'b00 : ( (WBack_jal) ? 2'b10 : 2'b01);
assign WBack_mux_addr_out = (M1 ==2'b00) ? MEM_WBack_ir[20:16] : ((M1 == 2'b01) ? MEM_WBack_ir[15:11] : 5'd31);

wire [31:0] dm_addr;
assign dm_addr = ( DM_addr - 32'h1001_0000);

  my_DMEM my_dmem_inst (
    .clk(clk),             // ����ʱ���ź�
    .DM_CS(1'b1),         // ���� DM_CS �ź�
    .DM_W(DM_W),           // ���� DM_W �ź�
    .DM_R(DM_R),           // ���� DM_R �ź�
    .DM_addr(dm_addr),  // ���� ALU �������Ϊ DMEM ��ַ
    .DM_wdata(DM_wdata),  // ����һЩ�����ź�
    .DM_rdata(DM_rdata) // ������������ź�
  );

endmodule





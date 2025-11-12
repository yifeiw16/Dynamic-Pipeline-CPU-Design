`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 19:41:35
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
  input wire clk,
  input wire rst,
  input wire if_break,
  input wire JUMP_halt,
  input wire RAW_halt,
  input wire [31:0] If_instruction,
  input wire [31:0] If_PC,
  output reg [31:0] IfId_Npc,
  output reg [31:0] IfId_Ir
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
     IfId_Ir <= 32'hffffffff;
     IfId_Npc <= 32'b0;
  end
  else if (JUMP_halt == 1 && RAW_halt == 0) begin
    IfId_Ir <= 32'hffffffff;
  end
  else if (JUMP_halt == 0 && RAW_halt == 0) begin
    if(if_break==1)
        IfId_Npc <= 32'h00400004;
    else
        IfId_Npc <= If_PC + 32'h4;
    IfId_Ir <= If_instruction;
  end
end

endmodule


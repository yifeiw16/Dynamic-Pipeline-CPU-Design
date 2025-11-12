`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 19:50:01
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB (
  input wire clk,
  input wire rst,
  input wire MeLw,
  input wire [31:0] MeDmemOut,
  input wire [31:0] ExMeAluOut,
  input wire [31:0] ExMePassData,
  input wire [31:0] ExMeIr,
  input wire ExMeOverflowFlag,
  input wire [31:0] ExMeAlub,
  input wire [63:0] exme_mul_out,
  
  output reg [31:0] MemWbAluOut,
  output reg [31:0] MeWbPassData,
  output reg [31:0] MemWbIr,
  output reg MemWbOverflowFlag,
  output reg [31:0] MemWbAlub,
  output reg [63:0] MemWb_mul_out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        MemWbAluOut <= 32'b0000;
        MemWbOverflowFlag <= 32'b00000;
        MemWbAlub <= 32'b00000;
        MemWbIr <= 32'hffffffff;
        MeWbPassData <= 32'b00000;
        MemWb_mul_out <= 32'b0;
    end
    else  begin
        MemWbAluOut <= ExMeAluOut;
        MemWbIr <= ExMeIr;
        MemWbOverflowFlag <= ExMeOverflowFlag;
        MemWbAlub <= ExMeAlub;
        MemWb_mul_out <= exme_mul_out;
        if (MeLw) 
            MeWbPassData <= MeDmemOut;
        else 
            MeWbPassData <= ExMePassData;
    end
end

endmodule


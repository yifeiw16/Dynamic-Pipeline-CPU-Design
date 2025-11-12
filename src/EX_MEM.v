`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 19:50:54
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM (
  input wire clk,
  input wire rst,
  input wire [31:0] ExAluOut,
  input wire [31:0] IdExPassData,
  input wire [31:0] IdExIr,
  input wire overflow,
  input wire [31:0] IdExAlub,  
  input wire [63:0] ex_mul_out,
  input wire EX_mul,
  
  output reg [31:0] ExMeAluOut,
  output reg [31:0] ExMePassData,
  output reg [31:0] ExMeIr,
  output reg ExMeOverflowFlag,
  output reg [31:0] ExMeAlub,
  output reg [63:0] exme_mul_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ExMeAluOut <= 32'b00000000;
        ExMePassData <= 32'b00000000;
        ExMeIr <= 32'hffffffff;
        ExMeOverflowFlag <= 1'b00000000;
        ExMeAlub <= 32'b00000000;
        exme_mul_out <= 32'b00000000;
    end
    else begin
        ExMeAluOut <= ExAluOut;
        ExMePassData <= IdExPassData;
        ExMeIr <= IdExIr;
        ExMeOverflowFlag <= overflow;
        ExMeAlub <= IdExAlub;  // Update to use IdExAlub as input
        exme_mul_out <= EX_mul ? ex_mul_out : 64'b0;
    end
end

endmodule



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 17:41:42
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
  input wire clk,
  input wire rst,
  input wire RAW_halt,
  input wire [31:0] id_mux_alua_out,
  input wire [31:0] id_mux_alub_out,
  input wire [31:0] id_pass_data,
  input wire [31:0] ifid_ir,
  output reg [31:0] IdExAluA,
  output reg [31:0] IdExAluB,
  output reg [31:0] IdEx_transfer,
  output reg [31:0] IdEx_Ir
);

always @(posedge clk or posedge rst) begin
  if (rst||RAW_halt ) begin
    IdExAluA <= 32'b0;
    IdExAluB <= 32'b0;
    IdEx_transfer <= 32'b0;
    IdEx_Ir <= 32'hffffffff;
  end
 
  else begin
    IdExAluA <= id_mux_alua_out;
    IdExAluB <= id_mux_alub_out;
    IdEx_transfer <= id_pass_data;
    IdEx_Ir <= ifid_ir;
  end
end

endmodule



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/24 23:09:35
// Design Name: 
// Module Name: Selectorthree
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


module ThreeInputSelector (
    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [2:0] selector,
    output reg [31:0] output_data
);

always @*
begin
    case (selector)
        3'b001: output_data = data0;
        3'b010: output_data = data1;
        3'b100: output_data = data2;
        
        default: output_data = 32'hffffffff; // 默认情况下输出全1
    endcase
end

endmodule


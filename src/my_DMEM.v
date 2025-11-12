`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/24 21:43:15
// Design Name: 
// Module Name: my_DMEM
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


module my_DMEM(
    input clk,
    input DM_CS,
    input DM_W,
    input DM_R,
    input [10:0] DM_addr,  //ALU��result��Ϊ����
    input [31:0] DM_wdata,
    output [31:0] DM_rdata //DMEM�����
    );
    
    reg [31:0] DMEM_dataset[31:0];
    assign DM_rdata = (DM_R && DM_CS && !DM_W) ? DMEM_dataset[DM_addr] : 32'bz;
    
    always @(negedge clk )  //�˴���ʱ����Ҫ�ٿ���
        begin
         if (DM_W && DM_CS && !DM_R) begin
            DMEM_dataset[DM_addr] <= DM_wdata;
        end
    end
    
    
endmodule


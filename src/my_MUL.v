`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/16 17:59:16
// Design Name: 
// Module Name: my_MUL
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


`timescale 1ns / 1ps

module MUL(
    input clk,
    input rst,
    input MUL_controller,
    input [31:0]a,
    input [31:0]b,
    output [63:0]z
    );
    reg [32:0]partial_product;     
    reg [32:0]product;    
    reg [32:0]reg_a_pos;     
    reg [32:0]reg_a_neg;     
      
    integer i;
    always@(*)
    begin
        if(rst)
        begin
            reg_a_neg=(a[31]==0)?{1'b1,~a+1'b1}:{1'b0,~(a-1'b1)};
            reg_a_pos=(a[31]==0)?{1'b0,a}:{1'b1,a};
            product={b,1'b0};
            partial_product=33'h00000000; 
        end
    end
    always@(*)
    begin
        if(MUL_controller==1)
        begin
            if(a==0 || b==0)
            begin
                partial_product=33'b0;
                product=33'b0;
            end
            else
            begin
                reg_a_neg=(a[31]==0)?{1'b1,~a+1'b1}:{1'b0,~(a-1'b1)};
                reg_a_pos=(a[31]==0)?{1'b0,a}:{1'b1,a};   
                product={b,1'b0};
                partial_product=33'h00000000; 
                for(i=0;i<32;i=i+1)
                begin
                    if({product[1],product[0]}==2'b10)
                    begin
                        partial_product=partial_product+reg_a_neg;
                    end
                    else if({product[1],product[0]}==2'b01)
                    begin
                        partial_product=partial_product+reg_a_pos;
                    end
                    product={partial_product[0],product[32:1]};
                    partial_product={partial_product[32],partial_product[32:1]};        
                end
            end
        end
    end
    assign z={partial_product[31:0],product[32:1]};
endmodule



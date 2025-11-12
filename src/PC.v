`timescale 1ns / 1ps
module pc_reg(
    input clk,
    input rst,
    input ena,
    input [31:0] in_data,
    output [31:0] out_data
);
    reg [31:0]temp_out;

    always@(negedge clk or posedge rst) begin

        if(ena)
            temp_out <= in_data;
        else if(rst==1)
            temp_out <= 32'h0040_0000;
    end

    assign out_data = ena?temp_out:32'hz;
endmodule

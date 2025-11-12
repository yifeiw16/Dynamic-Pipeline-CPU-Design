`timescale 1ns / 1ps

// 给定 pc 就会立即返回对应的 instr
module IMEM(
  input [10:0] addr,
  output [31:0] output_data
);

  dist_mem_gen_0 dist_mem_gen_0(
    .a(addr),
    .spo(output_data)
  );

endmodule

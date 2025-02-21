`timescale 1ns / 1ps
module Relu#(
    parameter BITWIDTH = 16,
    parameter THRESSHOLD = 0
    )
    (
    input signed [BITWIDTH - 1:0] data,
    output signed [BITWIDTH - 1:0] result
    );
    
    assign result = data > THRESSHOLD ? data : THRESSHOLD;
endmodule
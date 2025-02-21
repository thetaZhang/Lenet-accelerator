`timescale 1ns / 1ps
module Relu_activation#(
    parameter integer BITWIDTH = 16,
    parameter integer DATAWIDTH = 7,
    parameter integer DATAHEIGHT = 7,
    parameter integer DATACHANNEL = 4
    )
    (
    
    input [BITWIDTH * DATAHEIGHT * DATAWIDTH * DATACHANNEL - 1:0] data,
    output wire [BITWIDTH * DATAHEIGHT * DATAWIDTH * DATACHANNEL - 1:0] result
    );
    
    genvar i, j, k;
    generate
        for(i = 0; i < DATACHANNEL; i = i + 1) begin
            for(j = 0; j < DATAHEIGHT; j = j + 1) begin
                for(k = 0; k < DATAWIDTH; k = k + 1) begin
                    Relu#(BITWIDTH) relu(data[(i * DATAHEIGHT * DATAWIDTH + j * DATAWIDTH + k) * BITWIDTH + BITWIDTH - 1:(i * DATAHEIGHT * DATAWIDTH + j * DATAWIDTH + k) * BITWIDTH], result[(i * DATAHEIGHT * DATAWIDTH + j * DATAWIDTH + k) * BITWIDTH + BITWIDTH - 1:(i * DATAHEIGHT * DATAWIDTH + j * DATAWIDTH + k) * BITWIDTH]);
                end
            end
        end
    endgenerate  
    
endmodule

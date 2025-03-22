// PEarray.v
//  systolic array 

module PEarray#(
    parameter integer DATA_WIDTH = 8,
    parameter integer PE_CHANNEL = 8,
    parameter integer PE_DIM = 8
)(
    input clk,
    input rst_n,

    input [DATA_WIDTH * PE_DIM - 1:0] data_in,
    input [DATA_WIDTH * PE_CHANNEL - 1:0] weight_in,
    
    output [DATA_WIDTH * PE_CHANNEL - 1:0] res_out

);

// one more for the last PE output
wire [DATA_WIDTH - 1 : 0] data_path[0 : PE_DIM][0 : PE_CHANNEL - 1];
wire [DATA_WIDTH - 1 : 0] weight_sum_path[0 : PE_DIM - 1][0 : PE_CHANNEL];

genvar i, j;

// input and output for array
generate
    for (i = 0; i < PE_DIM; i = i + 1) begin : gen_PE_INPUT_horizonal
       assign data_path[i][0] = data_in[DATA_WIDTH * (i + 1) - 1 : DATA_WIDTH * i];
    end
    for (i = 0; i < PE_CHANNEL; i = i + 1) begin : gen_PE_INPUT_vertical
       assign weight_sum_path[0][i] = weight_in[DATA_WIDTH * (i + 1) - 1 : DATA_WIDTH * i];
    end
    for (i = 0; i < PE_DIM; i = i + 1) begin : gen_PE_OUTPUT_horizonal
       assign res_out[DATA_WIDTH * (i + 1) - 1 : DATA_WIDTH * i] = data_path[i][PE_CHANNEL - 1];
    end
endgenerate


// generate PE array
generate
    for (i = 0; i < PE_DIM; i = i + 1) begin : gen_PE_DIM_horizonal
        for (j = 0; j < PE_CHANNEL; j = j + 1) begin : gen_PE_CHANNEL_vertical
            PE #(
                .DATA_WIDTH(DATA_WIDTH)
            ) pe (
                .clk(clk),
                .rst_n(rst_n),
                .data_in(data_path[i][j]),
                .weight_sum_in(weight_sum_path[i][j]),
                .data_out(data_path[i+1][j]),
                .weight_sum_out(weight_sum_path[i][j+1])
            );
        end
    end
endgenerate





endmodule
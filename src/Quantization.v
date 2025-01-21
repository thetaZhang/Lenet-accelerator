// Quantization.v
// quantization module

module Quantization#(
    parameter INPUT_DATA_WIDTH = 16,
    parameter OUTPUT_DATA_WIDTH = 8
)(
    input [INPUT_DATA_WIDTH - 1 : 0] data_in,
    output [OUTPUT_DATA_WIDTH - 1 : 0] data_out
);

endmodule
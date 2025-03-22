// Round.v
// round module
// if overflow, saturate to max 

module Round#(
    parameter INPUT_DATA_WIDTH = 16,
    parameter OUTPUT_DATA_WIDTH = 8
)(
    input [INPUT_DATA_WIDTH - 1 : 0] data_in,
    output [OUTPUT_DATA_WIDTH - 1 : 0] data_out
);

assign data_out = (|data_in[INPUT_DATA_WIDTH - 1 : OUTPUT_DATA_WIDTH]) ? {OUTPUT_DATA_WIDTH{1'b1}} : data_in;


endmodule
// Mac.v
// Mac and quantization module

module Mac#(
    parameter INPUT_DATA_WIDTH = 8,
    parameter OUTPUT_DATA_WIDTH = 8
)(
    input [INPUT_DATA_WIDTH-1:0] data_in,
    input [INPUT_DATA_WIDTH-1:0] weight_in,
    input [INPUT_DATA_WIDTH-1:0] bias_in,
    output [OUTPUT_DATA_WIDTH-1:0] res_out
);

    wire [INPUT_DATA_WIDTH * 2 + 1 - 1 : 0] mac_res; // mac result without quantization

    assign mac_res = data_in * weight_in + bias_in;

    // Round
    Round#(
        .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH * 2 + 1),
        .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH)
    ) RoundUnit(
        .data_in(mac_res),
        .data_out(res_out)
    );

endmodule
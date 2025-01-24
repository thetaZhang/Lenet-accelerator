// PE.v
// processing element of systolic array
// data flow:WS

module PE#(
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst_n,

    input [1 : 0] mode_ctrl, // 00: idle, 01: load weight, 10 or 11: compute

    input [DATA_WIDTH-1:0] data_in,
    input [DATA_WIDTH-1:0] weight_sum_in,

    output [DATA_WIDTH-1:0] data_out, // horizontal out 
    output [DATA_WIDTH-1:0] weight_sum_out //vertical  out
);

    wire [DATA_WIDTH-1:0] weight_in, partial_sum_in, weight_out, partial_sum_out;

    assign weight_in = weight_sum_in; 
    assign partial_sum_in = weight_sum_in;
    assign weight_sum_out = (mode_ctrl[1]) ? partial_sum_out : weight_out;

    // input data horizontal brodcast
    DffNegRstEn#(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({DATA_WIDTH{1'b0}})
    ) DataReg(
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[1]),
        .d(data_in),
        .q(data_out)
    );

    // weight load
    DffNegRstEn#(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({(DATA_WIDTH){1'b0}})
    ) WeightReg(
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[0]&~mode_ctrl[1]),
        .d(weight_in),
        .q(weight_out)
    );

    wire [DATA_WIDTH - 1 : 0] mac_res; 

    Mac#(
        .INPUT_DATA_WIDTH(DATA_WIDTH),
        .OUTPUT_DATA_WIDTH(DATA_WIDTH)
    ) MacUnit(
        .data_in(data_in),
        .weight_in(weight_out),
        .bias_in(partial_sum_in),
        .res_out(mac_res)
    );

    // partial sum vertical brodcast
    DffNegRstEn#(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({DATA_WIDTH{1'b0}})
    ) SumReg(
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[1]),
        .d(mac_res),
        .q(partial_sum_out)
    );

    

endmodule


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
    input [DATA_WIDTH-1:0] weight_in,// only use when load weight
    input [DATA_WIDTH-1:0] partial_sum_in,

    // flag of is weight has been loaded
    input weight_ready_in,
    output weight_ready, 

    output [DATA_WIDTH-1:0] data_out, // horizontal out
    output [DATA_WIDTH-1:0] weight_out, // vertical weight out, only use when load weight
    output [DATA_WIDTH-1:0] partial_sum_out //vertical partial sum out

);
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
        .DATA_WIDTH(DATA_WIDTH+1),
        .RST_VALUE({(DATA_WIDTH+1){1'b0}})
    ) WeightReg(
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[0]&~mode_ctrl[1]),
        .d({weight_ready_in,weight_in}),
        .q({weight_ready,weight_out})
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


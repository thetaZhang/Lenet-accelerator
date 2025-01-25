// PE.v
// processing element of systolic array
// dataflow reconfigurable : WS & OS

module PE#(
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst_n,

    input [1 : 0] mode_ctrl, // 00: idle, 01: WS load weight, 10: OS compute, 11: WS compute

    input weight_clr,

    input [DATA_WIDTH - 1 : 0] data_in,
    input [DATA_WIDTH - 1 : 0] weight_sum_in,

    output [DATA_WIDTH - 1 : 0] data_out, // horizontal out 
    output [DATA_WIDTH - 1 : 0] weight_sum_out, //vertical  out

    output [DATA_WIDTH - 1 : 0] acc_out // output of the accumulator
);

    localparam OS = 2'b10;
    localparam WS_COMPUTE = 2'b11;
    localparam WS_LOAD = 2'b01;
    localparam IDLE = 2'b00;

    wire [DATA_WIDTH - 1 : 0] weight_sum_reg_in;
    wire [DATA_WIDTH - 1 : 0] weight_sum_reg_out;

    assign weight_sum_reg_in = (mode_ctrl === OS) ? mac_res_out : weight_sum_in;

    // weight reg in WS, partial sum reg in OS
   DffNegRstEnClr #(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({DATA_WIDTH{1'b0}})
   ) weight_acc_reg (
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl === WS_LOAD || mode_ctrl === OS),
        .clr(weight_clr),
        .d(weight_sum_reg_in),
        .q(weight_sum_reg_out)
   );

    wire [DATA_WIDTH - 1 : 0] mac_data_in;
    wire [DATA_WIDTH - 1 : 0] mac_weight_in;
    wire [DATA_WIDTH - 1 : 0] mac_bias_in;
    wire [DATA_WIDTH - 1 : 0] mac_res_out;

    assign mac_data_in = data_in;
    assign mac_weight_in = (mode_ctrl === OS) ? weight_sum_in : weight_sum_reg_out;
    assign mac_bias_in = (mode_ctrl === OS) ? weight_sum_reg_out : weight_sum_in;

    // mac
    Mac #(
        .INPUT_DATA_WIDTH(DATA_WIDTH),
        .OUTPUT_DATA_WIDTH(DATA_WIDTH)
    ) mac_unit(
        .data_in(mac_data_in),
        .weight_in(mac_weight_in),
        .bias_in(mac_bias_in),
        .res_out(mac_res_out)
    );

    // horizontal out
    DffNegRstEn #(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({DATA_WIDTH{1'b0}})
    ) horizontal_reg (
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[1]),
        .d(data_in),
        .q(data_out)
    );


    wire [DATA_WIDTH - 1 : 0] vertical_reg_in;
    wire [DATA_WIDTH - 1 : 0] vertical_reg_out;

    assign vertical_reg_in = (mode_ctrl === OS) ? weight_sum_in : mac_res_out;

    // vertical out
    DffNegRstEn #(
        .DATA_WIDTH(DATA_WIDTH),
        .RST_VALUE({DATA_WIDTH{1'b0}})
    ) vertical_reg (
        .clk(clk),
        .rst_n(rst_n),
        .en(mode_ctrl[1]),
        .d(vertical_reg_in),
        .q(vertical_reg_out)
    );


   assign weight_sum_out = (mode_ctrl === WS_LOAD) ? weight_sum_reg_out : vertical_reg_out;


endmodule


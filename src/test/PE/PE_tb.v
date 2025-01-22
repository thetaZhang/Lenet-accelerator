// PE_tb.v
// Testbench for PE

//`include "PE.v"

module PE_tb();


reg clk;
reg rst_n;
reg [1 : 0] mode_ctrl;
reg [7 : 0] data_in;
reg [7 : 0] weight_in;
reg [7 : 0] partial_sum_in;
wire [7 : 0] data_out;
wire [7 : 0] weight_out;
wire [7 : 0] partial_sum_out;

PE#(
    .DATA_WIDTH(8)
) DUT(
    .clk(clk),
    .rst_n(rst_n),
    .mode_ctrl(mode_ctrl),
    .data_in(data_in),
    .weight_in(weight_in),
    .partial_sum_in(partial_sum_in),
    .data_out(data_out),
    .weight_out(weight_out),
    .partial_sum_out(partial_sum_out)
);    

initial begin
    clk = 0;
    rst_n = 0;
    mode_ctrl = 2'b00;

    #5 rst_n = 1;

    mode_ctrl = 2'b01;
    weight_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    mode_ctrl = 2'b10;
    data_in = 8'd5;
    partial_sum_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    mode_ctrl = 2'b10;
    data_in = 8'd10;
    partial_sum_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, PE_tb);
end

endmodule
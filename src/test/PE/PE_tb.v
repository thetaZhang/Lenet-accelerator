// PE_tb.v
// Testbench for PE

//`include "PE.v"

module PE_tb();


reg clk;
reg rst_n;
reg [1 : 0] mode_ctrl;
reg [7 : 0] data_in;
reg weight_clr;
reg [7 : 0] weight_sum_in;
wire [7 : 0] data_out;
wire [7 : 0] weight_sum_out;

PE#(
    .DATA_WIDTH(8)
) DUT(
    .clk(clk),
    .rst_n(rst_n),
    .mode_ctrl(mode_ctrl),
    .data_in(data_in),
    .weight_clr(weight_clr),
    .weight_sum_in(weight_sum_in),
    .data_out(data_out),
    .weight_sum_out(weight_sum_out)
);    

initial begin
    weight_clr = 0;
    clk = 0;
    rst_n = 0;
    mode_ctrl = 2'b00;

    #5 rst_n = 1;

    mode_ctrl = 2'b01;
    weight_sum_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    mode_ctrl = 2'b11;
    data_in = 8'd5;
    weight_sum_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    mode_ctrl = 2'b11;
    data_in = 8'd10;
    weight_sum_in = 8'd10;

    #5
    clk = 1;
    #5
    clk = 0;

    weight_clr = 1;

    #5
    clk = 1;
    #5
    clk = 0;

    weight_clr = 0;
    mode_ctrl = 2'b10;
    data_in = 8'd2;
    weight_sum_in = 8'd2;

    #5 
    clk = 1;
    #5
    clk = 0;

    data_in = 8'd3;
    weight_sum_in = 8'd3;

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
//FCWeightRom.v
// FC layer weight ROM

module FCWeightRom #(
    //parameter PARALLEL_CHANNEL = 1,
    parameter NEURON_NUM = 10,
    parameter WEIGHT_DIM = 100,
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst_n,

    input en, 
    input [$clog2(WEIGHT_DIM * NEURON_NUM) - 1 : 0] addr,
    
    output [DATA_WIDTH - 1:0] weight_out 
);

`define INIT_FILE 

localparam ADDR_WIDTH = $clog2(WEIGHT_DIM * NEURON_NUM);

Rom #(
    .DATA_WIDTH(DATA_WIDTH),
    .DATA_DEPTH(WEIGHT_DIM * NEURON_NUM),
    .INIT_FILE(`INIT_FILE)
) RomUnit(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .addr(addr),
    .data_out(weight_out)
);

endmodule
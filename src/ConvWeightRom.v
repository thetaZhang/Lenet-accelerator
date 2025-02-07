// ConvWeightRom.v

module ConvWeightRom#(
    parameter CONV_CHANNEL = 4,
    parameter KERNEL_SIZE = 25,
    parameter DATA_WIDTH = 8

)(
    input clk,
    input rst_n,

    input en,
    input [$clog2(KERNEL_SIZE) - 1 : 0] addr,

    //output data format:
    // (MSB)[data of channel n, ... , data of channel 1, data of channel 0](LSB)
    output [DATA_WIDTH * CONV_CHANNEL - 1:0] weight_out
);

localparam ADDR_WIDTH = $clog2(KERNEL_SIZE);

genvar i;
generate
    for(i = 0; i < KERNEL_SIZE; i = i + 1) begin
        `define INIT_FILE ({"cov_weight_init_rom_", i+ 8'h30,".txt"}) 
        Rom #(
            .DATA_WIDTH(DATA_WIDTH),
            .DATA_DEPTH(KERNEL_SIZE),
            .INIT_FILE(`INIT_FILE)
        ) RomUnit(
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .addr(addr),
            .data_out(weight_out[DATA_WIDTH * (i + 1) - 1 : DATA_WIDTH * i])
        );
    end
endgenerate

endmodule
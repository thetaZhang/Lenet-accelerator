// Sram.v
// A parameterized SRAM with configurable channel count, capacity, data width, and address width.

`include "Dffs.v" // if include modules is not be added in the compile command, the module should be included here

module Sram#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter CHANNEL = 1,
    parameter SIZE = 256

)(
    input clk, 
    
    // data, addr and enable signal format:
    // (MSB)[channel n, ... , channel 1, channel 0](LSB)

    input [CHANNEL - 1 : 0]wr_en,
    input [ADDR_WIDTH * CHANNEL - 1 : 0] wr_addr,
    input [DATA_WIDTH * CHANNEL - 1 : 0] wr_data,

    
    input [CHANNEL - 1 : 0] rd_en,
    input [ADDR_WIDTH * CHANNEL - 1 : 0] rd_addr,
    output [DATA_WIDTH * CHANNEL - 1 : 0] rd_data 
);

reg [DATA_WIDTH - 1 : 0] mem [CHANNEL - 1 : 0][SIZE - 1 : 0];

reg [DATA_WIDTH * CHANNEL - 1 : 0] rd_data_reg;

assign rd_data = rd_data_reg;

genvar i;
generate
    for (i = 0; i < CHANNEL; i = i + 1) begin : channel
        always @(posedge clk) begin
            if (wr_en[i]) 
                mem[i][wr_addr] <= wr_data[(i + 1) * DATA_WIDTH - 1 : i * DATA_WIDTH];
        end

        always @(posedge clk) begin
            if (rd_en[i]) 
                rd_data_reg[(i + 1) * DATA_WIDTH - 1 : i * DATA_WIDTH] <= mem[i][rd_addr];
        end
        
    end
endgenerate


endmodule
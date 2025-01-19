// Sram.v
// A parameterized SRAM with 1 read and 1 write port, low asynchronous rst, synchronous wr and rd, high active csen


module Sram#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)(
    input clk,
    input rst_n, 
    input csen, //chip select enable

    input wr_en,
    input [ADDR_WIDTH - 1 : 0] wr_addr,
    input [DATA_WIDTH - 1 : 0] wr_data,

    
    input rd_en,
    input [ADDR_WIDTH - 1 : 0] rd_addr,
    output [DATA_WIDTH - 1 : 0] rd_data 
);

localparam DATA_DEPTH = 2 ** ADDR_WIDTH;

reg [DATA_WIDTH - 1 : 0] mem [0 : DATA_DEPTH - 1];

reg [DATA_WIDTH - 1 : 0] rd_data_reg;

assign rd_data = rd_data_reg;

integer i;

// input
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < DATA_DEPTH; i = i + 1) begin: memory_init
            mem[i] <= {DATA_WIDTH{1'b0}};
        end
    end 
    else if (csen && wr_en) begin
        mem[wr_addr] <= wr_data;
    end
end

// output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rd_data_reg <= {DATA_WIDTH{1'bz}};
    end 
    else if (rd_en && csen) begin
        rd_data_reg <= mem[rd_addr];
    end
end

endmodule
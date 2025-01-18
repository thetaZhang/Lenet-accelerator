module Sram_tb();


    reg clk;
    reg [1:0] wr_en;
    reg [15:0] wr_addr;
    reg [15:0] wr_data;
    reg [1:0] rd_en;
    reg [15:0] rd_addr;
    wire [15:0] rd_data;



    Sram #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(8),
        .CHANNEL(2),
        .SIZE(16)
    ) sram(
        .clk(clk),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

endmodule
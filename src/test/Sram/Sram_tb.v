`timescale 1ns / 1ns
`include "../../Sram.v"

module Sram_tb();

    reg clk;
    reg rst_n;
    reg csen;
    reg wr_en;
    reg [8 - 1 : 0] wr_addr;
    reg [8 - 1 : 0] wr_data;
    reg rd_en;
    reg [8 - 1 : 0] rd_addr;
    wire [8 - 1 : 0] rd_data;
  

    Sram#(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(8)
    ) sram(
        .clk(clk),
        .rst_n(rst_n),
        .csen(csen),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    initial begin
        #5 rst_n = 0;
        #5 rst_n = 1;

        #5 
        clk = 0;
        wr_en = 1;
        wr_addr = 0;
        wr_data = 8'hFF;
        csen = 1;
        rd_en = 0;
        rd_addr = 0;
        #5
        clk = 1;
        
        #5
;
        clk = 0;
        wr_en = 0;
        rd_en = 1;
        rd_addr = 0;
        #5
        clk = 1;
        
        #5
   
        $finish;

    end

    initial begin
        $dumpfile("wave.vcd"); 
        $dumpvars(0, Sram_tb); 
    end


endmodule
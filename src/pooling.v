`timescale 1ns / 1ps
module Max_pool#(
    parameter integer BITWIDTH = 16,
    parameter integer DATAWIDTH = 28,
    parameter integer DATAHEIGHT = 28,
    parameter integer DATACHANNEL = 4,
    parameter integer KWIDTH = 4,
    parameter integer KHEIGHT = 4
    )
    (
    input clk,
    input [BITWIDTH * DATAWIDTH * DATAHEIGHT * DATACHANNEL - 1 : 0] data,
    output reg done,
    output wire [BITWIDTH * DATAWIDTH / KWIDTH * DATAHEIGHT / KHEIGHT * DATACHANNEL - 1 : 0] result
    );
    
    wire [BITWIDTH - 1 : 0] dataArray[0 : DATACHANNEL - 1][0 : DATAHEIGHT-1][0 : DATAWIDTH - 1];
    wire [BITWIDTH * KHEIGHT * KWIDTH - 1 : 0]paramArray [0: DATACHANNEL - 1][0: DATAHEIGHT / KHEIGHT - 1][0: DATAWIDTH / KWIDTH - 1];
    
    genvar i, j, k;
    generate       
        for(i = 0; i < DATACHANNEL; i = i + 1) begin
            for(j = 0; j < DATAHEIGHT; j = j + 1) begin
                for(k = 0; k < DATAWIDTH; k = k + 1) begin
                    assign dataArray[i][j][k] = data[(i * DATAHEIGHT * DATAWIDTH + j * DATAHEIGHT + k) * BITWIDTH + BITWIDTH - 1:(i * DATAHEIGHT * DATAWIDTH + j * DATAHEIGHT + k) * BITWIDTH];
                end
            end
        end      
    endgenerate
    genvar m, n;
    generate 
        for(i = 0; i < DATACHANNEL; i = i + 1) begin
            for(j = 0; j < DATAHEIGHT / KHEIGHT; j = j + 1) begin
                for(k = 0; k < DATAWIDTH / KWIDTH; k = k + 1) begin
                    for(m = j * 2; m < j * 2 + KHEIGHT; m = m + 1) begin
                        for(n = k * 2; n < k * 2 + KWIDTH; n = n + 1) begin
                            assign paramArray[i][j][k][((m - j * 2) * KWIDTH + n - k * 2) * BITWIDTH + BITWIDTH - 1:((m - j * 2) * KWIDTH + n - k * 2) * BITWIDTH] = dataArray[i][m][n];
                        end
                    end                   
                end
            end
        end
    endgenerate
    

    generate
        for(i = 0; i < DATACHANNEL; i = i + 1) begin
            for(j = 0; j < DATAHEIGHT / KHEIGHT; j = j + 1) begin
                for(k = 0; k < DATAWIDTH / KWIDTH; k = k + 1) begin
                    Max#(BITWIDTH, KHEIGHT * KWIDTH) max(paramArray[i][j][k], result[(i * DATAHEIGHT / KHEIGHT * DATAWIDTH / KWIDTH + j * DATAWIDTH / KWIDTH + k) * BITWIDTH + BITWIDTH - 1:(i * DATAHEIGHT / KHEIGHT * DATAWIDTH / KWIDTH + j * DATAWIDTH / KWIDTH + k) * BITWIDTH]);
                end
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        done <= 1;  // 模拟所有计算完成时将done信号设置为1
    end
    
endmodule
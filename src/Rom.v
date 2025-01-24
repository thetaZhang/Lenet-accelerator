// Rom.v

module Rom#(
    parameter DATA_WIDTH = 8,
    parameter DATA_DEPTH = 256,
    parameter INIT_FILE = "rom_init.txt"
)(
    input clk,
    input rst_n,

    input csen,
    input [$clog2(DATA_DEPTH)-1:0] addr,
    output [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] mem[0:DATA_DEPTH-1];

    reg [DATA_WIDTH-1:0] data_reg;

    assign data = data_reg;

    initial begin
        $readmemh(INIT_FILE, mem);
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_reg <= {DATA_WIDTH{1'bz}};
        end 
        else if (csen) begin
            data_reg <= mem[addr];
        end
    end


endmodule
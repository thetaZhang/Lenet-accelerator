// Dffs.v


// Dff with asynchronous negative edge reset
module DffNegRst #(
    parameter DATA_WIDTH = 1,
    parameter RST_VALUE = 1'b0
) (
    input clk,
    input rst_n,

    input  [DATA_WIDTH - 1 : 0] d,
    output [DATA_WIDTH - 1 : 0] q
);

  reg [DATA_WIDTH - 1 : 0] q_reg;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) q_reg <= {DATA_WIDTH{RST_VALUE}};
    else q_reg <= d;
  end

  assign q = q_reg;

endmodule

// Dff with asynchronous positive edge reset
module DffPosRst #(
    parameter DATA_WIDTH = 1,
    parameter RST_VALUE = 1'b0
) (
    input clk,
    input rst,

    input  [DATA_WIDTH - 1 : 0] d,
    output [DATA_WIDTH - 1 : 0] q
);

  reg [DATA_WIDTH - 1 : 0] q_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) q_reg <= {DATA_WIDTH{RST_VALUE}};
    else q_reg <= d;
  end

  assign q = q_reg;
endmodule

// Dff without reset
module DffnoRst #(
    parameter DATA_WIDTH = 1
) (
    input clk,

    input  [DATA_WIDTH - 1 : 0] d,
    output [DATA_WIDTH - 1 : 0] q
);

  reg [DATA_WIDTH - 1 : 0] q_reg;

  always @(posedge clk) begin
    q_reg <= d;
  end

  assign q = q_reg;
endmodule
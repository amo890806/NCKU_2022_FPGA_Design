module PG(
    input [31:0] in,
    output parity
);

assign parity = ^in;

endmodule
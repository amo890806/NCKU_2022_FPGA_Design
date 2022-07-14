module Arithmetic(
    input signed [7:0] din1,
    input signed [7:0] din2,
    input [1:0] op,
    output sign_ed,
    output [6:0] dout,
    output reg overflow
);

reg signed [31:0] result;
assign dout = result[6:0];
assign sign_ed = result[31];

always @(*) begin
    case(op)
        0: begin // +
            result = din1 + din2;
            overflow = ~(din1[7] ^ din2[7]) & (din1[7] ^ result[7]);
        end
        1: begin // -
            result = din1 - din2;
            overflow = (din1[7] ^ din2[7]) & (din1[7] ^ result[7]);
        end
        2: begin // *
            result = din1 * din2;
            if(result[31])begin
                overflow = (result[7:0] > 128) ? 1 : 0;
            end
            else begin
                overflow = (result[7:0] > 127) ? 1 : 0;
            end
        end
        default: begin
            result = 0;
            overflow = 0;
        end
    endcase
end

endmodule
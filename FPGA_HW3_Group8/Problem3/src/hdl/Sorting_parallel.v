module Sorting_P(
    input [31:0] din,
    output reg [31:0] dout
);

    integer i, j;
    reg [3:0] temp;
    reg [3:0] array [0:7];

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            array[i] = din[i*4+3-:4];
        end

        for (i = 7; i > 0; i = i - 1) begin
            for (j = 0; j < i; j = j + 1) begin
                if (array[j] < array[j + 1]) begin
                    temp         = array[j];
                    array[j]     = array[j + 1];
                    array[j + 1] = temp;
                end
            end
        end
        dout = {array[7], array[6], array[5], array[4], array[3], array[2], array[1], array[0]};
    end

endmodule
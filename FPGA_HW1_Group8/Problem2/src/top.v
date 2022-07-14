module top(
    input   clk,
    input   rst,
    input  [1:0] sw,
    input  [2:0] BTN,
    output [2:0] led4,
    output [2:0] led5,
    output [3:0] led
    );
    
    wire    clk_div ;
    
    traffic_light tl_0(
    .clk    (clk_div),
    .rst    (rst),
    .sw     (sw),
    .BTN    (BTN),
    .led4   (led4),
    .led5   (led5),
    .led    (led)
    );
    
    divider div_0(
    .clk    (clk),
    .rst    (rst),
    .clk_div    (clk_div)
    );


    
endmodule

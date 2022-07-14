module LED(
    input   clk,
    input   rst,
    input   [1:0] sw,
    output  reg  [2:0] rgb
    );
    
always@(*)begin
    case(sw)
        2'b00:  rgb = 3'b111;
        2'b01:  rgb = 3'b100;
        2'b10:  rgb = 3'b010;
        2'b11:  rgb = 3'b110;
    endcase
end 
   
    
endmodule

module PWM_Decoder (
  input  [1:0] sw,
  output reg [7:0] R_time_out,
  output reg [7:0] G_time_out,
  output reg [7:0] B_time_out
);

  always @ ( * ) begin
    case (sw)
      2'b00: begin
        R_time_out = 8'h7f;
        G_time_out = 8'h1f;
        B_time_out = 8'hff;
      end
      2'b01: begin
        R_time_out = 8'h00;
        G_time_out = 8'hff;
        B_time_out = 8'hff;
      end
      2'b10: begin
        R_time_out = 8'hff;
        G_time_out = 8'hff;
        B_time_out = 8'h00;
      end
      2'b11: begin
        R_time_out = 8'hff;
        G_time_out = 8'h00;
        B_time_out = 8'hff;
      end
      default: begin
        R_time_out = 8'd0;
        G_time_out = 8'd0;
        B_time_out = 8'd0;
      end
    endcase
  end

endmodule // Decoder
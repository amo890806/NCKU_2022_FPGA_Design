module PWM_Decoder (
  input  [2:0] state,
  output reg [7:0] R_time_out,
  output reg [7:0] G_time_out,
  output reg [7:0] B_time_out
);



  always @ (*) begin
    case (state)
      0: begin
        R_time_out = 8'hff;
        G_time_out = 8'h00;
        B_time_out = 8'h00;
      end
      1: begin
        R_time_out = 8'hff;
        G_time_out = 8'h61;
        B_time_out = 8'h00;
      end
      2: begin
        R_time_out = 8'hff;
        G_time_out = 8'hff;
        B_time_out = 8'h00;
      end
      3: begin
        R_time_out = 8'h00;
        G_time_out = 8'hff;
        B_time_out = 8'h00;
      end
      4: begin
        R_time_out = 8'h00;
        G_time_out = 8'h00;
        B_time_out = 8'hff;
      end
      5: begin
        R_time_out = 8'h7f;
        G_time_out = 8'h1f;
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
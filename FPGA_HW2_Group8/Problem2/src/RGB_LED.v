module	RGB_LED(
	input			   clk,	
	input			   rst,
	input	 [7:0]	 R_time_in,
	input	 [7:0]	 G_time_in,
	input	 [7:0]	 B_time_in,
	output reg [2:0] rgb4,
  output reg [2:0] state
);

parameter R = 0;
parameter O = 1;
parameter Y = 2;
parameter G = 3;
parameter B = 4;
parameter P = 5;

reg	[7:0]	counter_256;
reg flag;
reg [6:0] cnt_08us; // 128
reg [9:0] cnt_08ms, cnt_08s; // 1024
reg [2:0] n_state;
wire state_flag;

always @(posedge clk or posedge rst) begin
	if(rst)
		counter_256	<= 8'd0;
	else 
		counter_256	<= counter_256 + 1;
end

always @(posedge clk or posedge rst) begin
  if(rst) state <= 0;
  else state <= n_state;
end

assign state_flag = (flag && cnt_08s == 1023 && cnt_08ms == 10'd1023 && cnt_08us == 7'd127);

always @(*) begin
  case (state)
    0: n_state = (state_flag) ? 1: 0;
    1: n_state = (state_flag) ? 2: 1;
    2: n_state = (state_flag) ? 3: 2;
    3: n_state = (state_flag) ? 4: 3;
    4: n_state = (state_flag) ? 5: 4;
    5: n_state = (state_flag) ? 0: 5; 
    default: n_state = 0;
  endcase
end


always@(posedge clk or posedge rst)begin
  if(rst)
    rgb4 <= 0;
  else begin
    if(!flag && cnt_08s >= cnt_08ms) begin
      rgb4[0] <= (counter_256 < R_time_in)? 1'd1 : 1'd0;
      rgb4[1] <= (counter_256 < G_time_in)? 1'd1 : 1'd0;
      rgb4[2] <= (counter_256 < B_time_in)? 1'd1 : 1'd0;    
    end
    else if(!flag && cnt_08s < cnt_08ms)
      rgb4 <= 0;
    else if(flag && cnt_08s >= cnt_08ms)
      rgb4 <= 0;
    else if(flag && cnt_08s < cnt_08ms) begin
      rgb4[0] <= (counter_256 < R_time_in)? 1'd1 : 1'd0;
      rgb4[1] <= (counter_256 < G_time_in)? 1'd1 : 1'd0;
      rgb4[2] <= (counter_256 < B_time_in)? 1'd1 : 1'd0;       
    end
  end
end

always @(posedge clk or posedge rst) begin  //flag
  if(rst)
    flag <= 0;
  else begin
    if(cnt_08s == 10'd1023 && cnt_08ms == 10'd1023 && cnt_08us == 7'd127)
      flag <= ~flag;
  end
end

always @(posedge clk or posedge rst) begin  //cnt_08us
  if(rst) cnt_08us <= 0;
  else begin
    cnt_08us <= cnt_08us + 1;
  end
end

always @(posedge clk or posedge rst) begin  //cnt_08ms
  if(rst) cnt_08ms <= 0;
  else begin
    if(cnt_08us == 7'd127) cnt_08ms <= cnt_08ms + 1;
  end
end

always @(posedge clk or posedge rst) begin  //cnt_08s
  if(rst) cnt_08s <= 0;
  else begin
    if(cnt_08us == 7'd127 && cnt_08ms == 10'd1023) cnt_08s <= cnt_08s + 1;
  end
end

endmodule
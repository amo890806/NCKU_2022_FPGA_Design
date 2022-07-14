module	RGB_LED(
	input			   clk,		
	input			   rst,
	input	[7:0]	 R_time_in,
	input	[7:0]	 G_time_in,
	input	[7:0]	 B_time_in,
	output [2:0] rgb4,
	output reg [2:0] rgb5
);

reg	[7:0]	counter_256;
reg flag;
reg [6:0] cnt_08us; // 128 // 8ns*100=800ns=800*10^-9=0.8us
reg [9:0] cnt_08ms, cnt_08s; // 1024 // 0.8ms, 0.8s

assign	rgb4[0] = (counter_256 < R_time_in)? 1'd1 : 1'd0;
assign	rgb4[1] = (counter_256 < G_time_in)? 1'd1 : 1'd0;
assign	rgb4[2] = (counter_256 < B_time_in)? 1'd1 : 1'd0;

always @(posedge clk or posedge rst) begin
	if(rst)
		counter_256	<= 8'd0;
	else begin
		counter_256	<= counter_256 + 1;
	end
end

always@(posedge clk or posedge rst)begin
  if(rst)
    rgb5 <= 0;
  else begin
    if(!flag && cnt_08s >= cnt_08ms) begin
      rgb5[0] <= (counter_256 < R_time_in)? 1'd1 : 1'd0;
      rgb5[1] <= (counter_256 < G_time_in)? 1'd1 : 1'd0;
      rgb5[2] <= (counter_256 < B_time_in)? 1'd1 : 1'd0;    
    end
    else if(!flag && cnt_08s < cnt_08ms)
      rgb5 <= 0;
    else if(flag &&  cnt_08s >= cnt_08ms)
      rgb5 <= 0;
    else if(flag && cnt_08s < cnt_08ms) begin
      rgb5[0] <= (counter_256 < R_time_in)? 1'd1 : 1'd0;
      rgb5[1] <= (counter_256 < G_time_in)? 1'd1 : 1'd0;
      rgb5[2] <= (counter_256 < B_time_in)? 1'd1 : 1'd0;       
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
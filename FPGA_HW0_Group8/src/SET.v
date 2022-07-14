module SET ( clk,rst,en,central,radius,mode,busy,valid,candidate);
input clk;
input rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0]  mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [3:0] c_x1, c_y1, c_x2, c_y2, c_x3, c_y3, r_1, r_2, r_3;
reg [3:0] x_cnt, y_cnt;
reg [1:0] mode_reg;

wire [3:0] sub_x1 = (x_cnt > c_x1) ? x_cnt - c_x1 : c_x1 - x_cnt;
wire [3:0] sub_y1 = (y_cnt > c_y1) ? y_cnt - c_y1 : c_y1 - y_cnt;
wire [3:0] sub_x2 = (x_cnt > c_x2) ? x_cnt - c_x2 : c_x2 - x_cnt;
wire [3:0] sub_y2 = (y_cnt > c_y2) ? y_cnt - c_y2 : c_y2 - y_cnt;
wire [3:0] sub_x3 = (x_cnt > c_x3) ? x_cnt - c_x3 : c_x3 - x_cnt;
wire [3:0] sub_y3 = (y_cnt > c_y3) ? y_cnt - c_y3 : c_y3 - y_cnt;

wire [7:0] sqr_x1 = sub_x1 * sub_x1;
wire [7:0] sqr_y1 = sub_y1 * sub_y1;
wire [7:0] sqr_x2 = sub_x2 * sub_x2;
wire [7:0] sqr_y2 = sub_y2 * sub_y2;
wire [7:0] sqr_x3 = sub_x3 * sub_x3;
wire [7:0] sqr_y3 = sub_y3 * sub_y3;
wire [7:0] sqr_r1 = r_1 * r_1;
wire [7:0] sqr_r2 = r_2 * r_2;
wire [7:0] sqr_r3 = r_3 * r_3;

wire [7:0] sum1 = sqr_x1 + sqr_y1;
wire [7:0] sum2 = sqr_x2 + sqr_y2;
wire [7:0] sum3 = sqr_x3 + sqr_y3;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        c_x1 <= 0;
        c_y1 <= 0;
        c_x2 <= 0;
        c_y2 <= 0;
        c_x3 <= 0;
        c_y3 <= 0;
        r_1 <= 0;
        r_2 <= 0;
        r_3 <= 0;
        x_cnt <= 1;
        y_cnt <= 1;
        busy <= 0;
        valid <= 0;
        candidate <= 0;
        mode_reg <= 0;
    end
    else begin
        if(busy)begin
            if(valid)begin
                busy <= 0;
                valid <= 0;
            end
            else begin
                case(mode_reg)
                    2'd0: begin
                        if (sum1 <= sqr_r1)  
                            candidate <= candidate + 1;
                    end
                    2'd1: begin
                        if ((sum1 <= sqr_r1) && (sum2 <= sqr_r2))  
                            candidate <= candidate + 1;
                    end
                    2'd2: begin
                        if (((sum1 <= sqr_r1) && (sum2 > sqr_r2))
                         || ((sum2 <= sqr_r2) && (sum1 > sqr_r1)))
                            candidate <= candidate + 1;
                     end
                    2'd3: begin
                        if (((sum1 <= sqr_r1) && (sum2 <= sqr_r2) && (sum3 > sqr_r3)) 
                         || ((sum2 <= sqr_r2) && (sum3 <= sqr_r3) && (sum1 > sqr_r1)) 
                         || ((sum3 <= sqr_r3) && (sum1 <= sqr_r1) && (sum2 > sqr_r2))) 
                            candidate <= candidate + 1;
                    end
                endcase
                if(x_cnt == 4'd8)begin
                    x_cnt <= 1;
                    if(y_cnt == 4'd8)begin
                        y_cnt <= 1;
                        valid <= 1;
                    end
                    else
                        y_cnt <= y_cnt + 1;
                end
                else
                    x_cnt <= x_cnt + 1;
            end
        end
        else begin
            if(en) begin
                c_x1 <= central[23:20];
                c_y1 <= central[19:16];
                c_x2 <= central[15:12];
                c_y2 <= central[11:8];
                c_x3 <= central[7:4];
                c_y3 <= central[3:0];
                r_1  <= radius[11:8];
                r_2  <= radius[7:4];
                r_3  <= radius[3:0];
                busy <= 1;
                candidate <= 0;
                mode_reg <= mode;
            end
        end
    end
end

endmodule
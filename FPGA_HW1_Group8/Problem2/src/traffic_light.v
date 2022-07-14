module traffic_light(
    input clk,
    input rst,
    input [1:0] sw,
    input [2:0] BTN,
    output reg [2:0] led4,
    output reg [2:0] led5,
    output [3:0] led
);

reg [2:0] state, n_state;
reg [3:0] red5;
reg [3:0] red1;
reg [3:0] yellow;
reg [3:0] max;
reg [3:0] led_;
reg sw_flag;

parameter GR  = 0;
parameter YR  = 1;
parameter RR1 = 2;
parameter RG  = 3;
parameter RY  = 4;
parameter RR2 = 5;

always @(posedge clk or posedge rst) begin
    if(rst) state <= GR;
    else state <= n_state;
end

// state transition
always @(*) begin
    if(sw == 2'b00) begin
        case (state)
            0: n_state = (led_ == red5 && !sw_flag) ? 1 : 0; 
            1: n_state = (led_ == yellow) ? 2 : 1;
            2: n_state = (led_ == red1)   ? 3 : 2;
            3: n_state = (led_ == red5)   ? 4 : 3;
            4: n_state = (led_ == yellow) ? 5 : 4;
            5: n_state = (led_ == red1)   ? 0 : 5;
            default: n_state = 0;
        endcase 
    end
    else n_state = 0;
end


always @(posedge clk or posedge rst) begin // red5
    if(rst) 
        red5 <= 5;
    else begin
        if(sw == 2'b01) begin
            if(BTN[0])
                red5 <= 5;
            else if(BTN[1])
                red5 <= (red5 == 15) ? 15 : red5 + 1;
            else if(BTN[2]) 
                red5 <= (red5 == 1) ? 1 : red5 - 1;       
        end
    end
end

always @(posedge clk or posedge rst) begin // red1
    if(rst)
        red1 <= 1;
    else begin
        if(sw == 2'b11) begin
            if(BTN[0]) 
                red1 <= 1;
            else if(BTN[1]) 
                red1 <= (red1 == 15) ? 15 : red1 + 1;
            else if(BTN[2]) 
                red1 <= (red1 == 1) ? 1 : red1 - 1;   
        end
    end
end

always @(posedge clk or posedge rst) begin // yellow
    if(rst) 
        yellow <= 1;
    else begin
        if(sw == 2'b10) begin
            if(BTN[0]) 
                yellow <= 1;
            else if(BTN[1]) 
                yellow <= (yellow == 15) ? 15 : yellow + 1;
            else if(BTN[2]) 
                yellow <= (yellow == 1) ? 1 : yellow - 1;
        end
    end
end

wire flag = ((state == 0 || state == 3) && led_ == red5) 
         || ((state == 1 || state == 4) && led_ == yellow) 
		 || ((state == 2 || state == 5) && led_ == red1) 
         || sw_flag; 

always @(posedge clk or posedge rst) begin // led_
    if(rst) led_ <= 4'b0000;
    else begin
        case (sw)
            0: led_ <= (flag) ? 0 : led_ + 1;
            1: led_ <= red5;
            2: led_ <= yellow;
            3: led_ <= red1;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) sw_flag <= 0;
    else begin
        if(sw != 0) sw_flag <= 1;
        else sw_flag <= 0;
    end
end

always @(*) begin
    max = red5;
    if(sw == 0) begin
        case (state)
            0, 3: max = red5;
            1, 4: max = yellow;
            2, 5: max = red1;
        endcase
    end
end

assign led = (sw == 0) ? max - led_ : led_;


// led4 T1
always@(*)begin
    case(sw)
        0: begin
            case (state)
                0: led4 = 3'b010;
                1: led4 = 3'b110;
                2, 3, 4, 5: led4 = 3'b100;
                default led4 = 3'b000;
            endcase
        end 
        1: led4 = 3'b100;
        2: led4 = 3'b110;
        3: led4 = 3'b111;
    endcase
end

// led5 T2
always@(*)begin
    case(sw)
        0: begin
            case (state)
                0, 1, 2, 5: led5 = 3'b100;
                3: led5 = 3'b010;
                4: led5 = 3'b110;
                default led5 = 3'b000;
            endcase
        end 
        1: led5 = 3'b010;
        2: led5 = 3'b110;
        3: led5 = 3'b111;
    endcase
end

endmodule
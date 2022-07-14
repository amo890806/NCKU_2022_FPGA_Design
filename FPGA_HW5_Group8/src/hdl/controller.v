module controller #(
  parameter Delay = 3
) (
  input  clk,
  input  rst_n,
  input  en,
  output valid,

  input [31:0] inst,

  output reg [9:0] bram0_raddrb,
  output reg       bram0_enb,
  output reg [9:0] bram1_addrb,
  output reg [3:0] bram1_web,
  output reg       bram1_enb,

  output reg [3:0] dsp_alumode,
  output reg [6:0] dsp_opmode,
  output reg [4:0] dsp_inmode
);

  parameter IDLE  = 0;
  parameter READ  = 1;
  parameter EXE   = 2;
  parameter WRITE = 3;
  parameter DONE  = 4;
  
  reg [30:0] inst_reg;
  reg [2:0] cs, ns;
  reg [1:0] cnt;

  assign valid = cs == DONE;

  always @(posedge clk) begin
    if (!rst_n) begin
      inst_reg <= 31'd0;
    end 
    else begin
      if (cs == IDLE && en)
        inst_reg <= inst[30:0];
    end
  end

  always @(posedge clk) begin
    if (!rst_n) 
      cs <= 0;
    else 
      cs <= ns;
  end

  always @(*) begin
    case (cs)
      IDLE:  ns = (en) ? (inst[31] ? READ : DONE) : IDLE;
      READ:  ns = EXE;
      EXE:   ns = (cnt == Delay - 1) ? WRITE : EXE;
      WRITE: ns = DONE;
      DONE:  ns = (!en) ? IDLE : DONE;
      default: ns = 0;
    endcase
  end

  always @(posedge clk) begin
    if(!rst_n) begin
      cnt <= 0;
    end
    else begin
      if(cs == EXE) 
        cnt <= (cnt == Delay - 1) ? 0 : cnt + 1;
    end
  end

  // BRAM0
  always @(*) begin
    if (cs == READ) begin
      bram0_raddrb = {5'd0, inst_reg[4:0]};
      bram0_enb   = 1'b1;
    end 
    else begin
      bram0_raddrb = 10'd0;
      bram0_enb   = 1'b0;
    end
  end

  // BRAM1
  always @(*) begin
    if (cs == READ) begin
      bram1_addrb = {5'd0, inst_reg[9:5]};
      bram1_web   = 4'h0;
      bram1_enb   = 1'b1;
    end 
    else if (cs == WRITE) begin
      bram1_addrb = {5'd0, inst_reg[14:10]};
      bram1_web   = 4'hf;
      bram1_enb   = 1'b1;
    end 
    else begin
      bram1_addrb = 10'd0;
      bram1_web   = 4'h0;
      bram1_enb   = 1'b0;
    end
  end

  // DSP decode
  always @(*) begin
    if (cs == EXE) begin
      dsp_inmode  = inst_reg[19:15];
      dsp_opmode  = inst_reg[26:20];
      dsp_alumode = inst_reg[30:27];
    end 
    else begin
      dsp_inmode  = 5'd0;
      dsp_opmode  = 7'd0;
      dsp_alumode = 4'd0;
    end
  end

endmodule
//For actual synthesys in xilinx
module sha2_tb(
    input clk,              // 100MHz clock
    input rst_n,            // reset button (active low)
    output [7:0] led       // 8 user controllable LEDs

    );

    wire rst;
    reset_conditioner reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));

    assign led = 8'h0F;      // turn LEDs off

    reg write_en;

    reg [255:0] do_reg;
    reg vo_reg;

    wire [255:0] dii;
    wire [255:0] di;
    wire [127:0] bi;
    wire [255:0] do;
    wire vo;

    assign dii = 256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
    assign di  = 256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
    assign bi  = 127'h252db801130dae516461011a3aeb9bb8;

    sha256_2_pipeline foo(.CLK(clk),
                          .RST(rst),
                          .write_en(write_en),
                          .digest_intial(dii),
                          .digest_in(di),
                          .block_in(bi),
                          .digest_out(do),
                          .valid_out(vo) );


    initial begin
        write_en=1;
    end

    always @(posedge clk)
	begin
        do_reg <= do;
        vo_reg <= vo;
	end


endmodule
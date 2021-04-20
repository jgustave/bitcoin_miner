//For actual synthesys in xilinx


module main_driver(
    input clk,              // 100MHz clock
    input rst_n,            // reset button (active low)
    output [7:0] led       // 8 user controllable LEDs

    );

    wire rst;
    reset_conditioner reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));

    reg [7:0] status_reg;

    wire valid_out;
    wire [31:0] time_out;
    wire [31:0] nonce_out;
    wire [255:0] result_out;

    wire [255:0] digest_initial_in;
    wire [255:0] digest_in;
    wire [31:0]  merkle_in;
    wire [31:0]  time_in;
    wire [31:0]  target_in;
    wire [31:0]  nonce_in;


    //Temp Hack.. these will all get loaded in to registers from serial input
    assign digest_initial_in=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
    assign digest_in =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;
    assign merkle_in = 32'h252db801;
    assign time_in = 32'h130dae51;
    assign target_in = 32'h6461011a;
    assign nonce_in = 32'h3aeb9bb0;

    //Board LED outputs
    assign led = status_reg;

    sha_hasher foo( .CLK(clk),
                    .RST(rst),
                    .write_en(1),
                    .digest_intial(digest_initial_in),
                    .digest_in(digest_in),
                    .merkle_in(merkle_in),
                    .time_in(time_in),
                    .target_in(target_in),
                    .nonce_in(nonce_in),

                    .valid_out(valid_out),
                    .time_out(time_out),
                    .nonce_out(nonce_out),
                    .result_out(result_out)
                    );



    always @(posedge clk)
	begin
	    if( rst ) begin
	        //active low.. normal op
	        status_reg <= status_reg | 8'b10000000;
	    end
	    else begin
	        //resetting
	        status_reg <= 8'b00000000;
	    end

	    if( valid_out ) begin
	        //found solution
	        status_reg <= status_reg | 8'b00000010;
	    end
	    else begin
	        //no solution yet.
	        status_reg <= status_reg & 8'b11111101;
	    end

	    //led <= status_reg;
	end


endmodule
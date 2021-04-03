
//This is the main module for our mining process
//Maybe change it to just be the combined pipeline
//includes itteration, just watch for status out.
//That way we can put the interface in another module.

module sha_hasher(
            input 	wire 			CLK,
            input	wire			RST,
            input	wire			write_en,

            input	wire	[255:0]	digest_intial, //This gets added to result of MC at end. This is the normal SHA256 result of previous run.
            input	wire	[255:0]	digest_in, //This is used to continue input to he MC stage (midState) It is clocked ahead by 1 W.

            input	wire	[32:0] merkle_in,
            input	wire	[32:0] time_in,
            input	wire	[32:0] target_in,
            input	wire	[32:0] nonce_in,
            output  wire           valid_out, //flag when solution found
            output  wire    [32:0] time_out,  //Time of solution
            output	wire	[32:0] nonce_out  //nonce of solution
);

//TODO: counter on nonce and time
//comparator for result
//write_en
//time part
//nonce part.

    wire [255:0] digest_out_2;
    wire [255:0] digest_out_3;

    wire         valid_out_2;
    wire         valid_out_3;

    reg [32:0]   time_counter_reg;
    reg [32:0]   nonce_counter_reg;


    sha256_2_pipeline sha2(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en),
                          .digest_intial(digest_initial), //TODO: typo
                          .digest_in(digest_in),
                          .block_in({merkle_in,time_counter_reg,target_in,nonce_counter_reg}),
                          .digest_out(digest_out_2),
                          .valid_out(valid_out_2) );

    sha256_3_pipeline sha3(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en),
                          .block_in(digest_out_2),
                          .digest_out(digest_out_3),
                          .valid_out(valid_out_3) );


    assign valid_out = valid_out_3;

	always @(posedge CLK or negedge RST)
	begin
		if(RST == 1'b0) begin
		    //###RESET
			//digest_out_reg <= 256'b0;
			valid_out <= 1'b0;
			nonce_counter_reg <= nonce_in;
			time_counter_reg <= time_in;
			write_en <= 1'b1;
		end
		else begin
			if(write_en == 1'b1 ) begin

                //Check results set flags, set outputs
                {time_counter_reg,nonce_counter_reg} <= {time_counter_reg,nonce_counter_reg} + 1;

			end
			else begin
			    //#### Do nothing. No Changes to all outputs
                time_counter_reg <= time_counter_reg;
                nonce_counter_reg <= nonce_counter_reg;
                valid_counter_reg <= valid_counter_reg;
                valid_out <= valid_out;
                nonce_out <= nonce_out;
                time_out <= time_out;

            end
		end
	end


endmodule
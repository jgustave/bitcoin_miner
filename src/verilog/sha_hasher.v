
//This is the main module for our mining process
//Maybe change it to just be the combined pipeline
//includes itteration, just watch for status out.
//That way we can put the interface in another module.

//Note [7:0] means little endian. [0:7] is big endian

module sha_hasher(
            input 	wire 			CLK,
            input	wire			RST,
            input	wire			write_en,

            input	wire	[255:0]	digest_intial, //This gets added to result of MC at end. This is the normal SHA256 result of previous run.
            input	wire	[255:0]	digest_in, //This is used to continue input to he MC stage (midState) It is clocked ahead by 1 W.

            input	wire	[31:0] merkle_in,
            input	wire	[31:0] time_in,
            input	wire	[31:0] target_in,
            input	wire	[31:0] nonce_in,
            output  wire           valid_out, //flag when solution found
            output  wire    [31:0] time_out,  //Time of solution
            output	wire	[31:0] nonce_out,  //nonce of solution
            output	wire	[255:0] result_out  //nonce of solution
);

    wire [255:0] digest_out_2;
    //wire [255:0] digest_out_3;

    wire         write_enable_2;
    wire         valid_out_2;
    wire         valid_out_3;

    reg [31:0]   time_counter_reg;
    reg [31:0]   nonce_counter_reg;

    wire [255:0] difficulty;
    reg [255:0]  difficulty_reg;

    wire [255:0]  difficulty_swap;
    wire [255:0]  result_swap;

    reg valid_out_reg;
    wire valid_out_wire;

    sha256_2_pipeline sha2(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en),
                          .digest_intial(digest_intial),
                          .digest_in(digest_in),
                          .block_in({merkle_in,time_counter_reg,target_in,nonce_counter_reg}),
                          .digest_out(digest_out_2),
                          .valid_out(valid_out_2) );

    sha256_3_pipeline sha3(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_enable_2),
                          .block_in(digest_out_2),
                          .digest_out(result_out),
                          .valid_out(valid_out_3) );

    assign valid_out = valid_out_3;
    //assign nonce_out = nonce_counter_reg;
    //assign time_out = time_counter_reg;
    //assign result_out = digest_out_3;
    assign write_enable_2 = write_en & valid_out_2;

    assign difficulty_swap2 = difficulty_reg;
    //Change endianness for comparison.

    assign difficulty_swap = {{difficulty_reg[7:0]},
                              {difficulty_reg[15:8]},
                              {difficulty_reg[23:16]},
                              {difficulty_reg[31:24]},
                              {difficulty_reg[39:32]},
                              {difficulty_reg[47:40]},
                              {difficulty_reg[55:48]},
                              {difficulty_reg[63:56]},
                              {difficulty_reg[71:64]},
                              {difficulty_reg[79:72]},
                              {difficulty_reg[87:80]},
                              {difficulty_reg[95:88]},
                              {difficulty_reg[103:96]},
                              {difficulty_reg[111:104]},
                              {difficulty_reg[119:112]},
                              {difficulty_reg[127:120]},
                              {difficulty_reg[135:128]},
                              {difficulty_reg[143:136]},
                              {difficulty_reg[151:144]},
                              {difficulty_reg[159:152]},
                              {difficulty_reg[167:160]},
                              {difficulty_reg[175:168]},
                              {difficulty_reg[183:176]},
                              {difficulty_reg[191:184]},
                              {difficulty_reg[199:192]},
                              {difficulty_reg[207:200]},
                              {difficulty_reg[215:208]},
                              {difficulty_reg[223:216]},
                              {difficulty_reg[231:224]},
                              {difficulty_reg[239:232]},
                              {difficulty_reg[247:240]},
                              {difficulty_reg[255:248]}
                              };
    assign result_swap = {{result_out[7:0]},
                              {result_out[15:8]},
                              {result_out[23:16]},
                              {result_out[31:24]},
                              {result_out[39:32]},
                              {result_out[47:40]},
                              {result_out[55:48]},
                              {result_out[63:56]},
                              {result_out[71:64]},
                              {result_out[79:72]},
                              {result_out[87:80]},
                              {result_out[95:88]},
                              {result_out[103:96]},
                              {result_out[111:104]},
                              {result_out[119:112]},
                              {result_out[127:120]},
                              {result_out[135:128]},
                              {result_out[143:136]},
                              {result_out[151:144]},
                              {result_out[159:152]},
                              {result_out[167:160]},
                              {result_out[175:168]},
                              {result_out[183:176]},
                              {result_out[191:184]},
                              {result_out[199:192]},
                              {result_out[207:200]},
                              {result_out[215:208]},
                              {result_out[223:216]},
                              {result_out[231:224]},
                              {result_out[239:232]},
                              {result_out[247:240]},
                              {result_out[255:248]}
                              };
    assign valid_out_wire = result_swap < difficulty_swap;


    //assign {time_out,nonce_out} <= {time_out,nonce_out} - 64

	always @(posedge CLK or negedge RST)
	begin
		if(RST == 1'b0) begin
		    difficulty_reg <= (256'b0 | target_in[31:8]) << (8 * ( 32 - target_in[7:0] ));

		    //###RESET
			//digest_out_reg <= 256'b0;
			//valid_out <= 1'b0;
			nonce_counter_reg <= nonce_in;
			time_counter_reg <= time_in;
			//write_en <= 1'b1;
			valid_out_reg = 0;
		end
		else begin
			if(write_en == 1'b1 ) begin
			    //Normal operation. Increment and check
                //Check results set flags, set outputs
                {time_counter_reg,nonce_counter_reg} <= {time_counter_reg,nonce_counter_reg} + 1;
                //nonce_counter_reg <= nonce_counter_reg +1;
                //{time_out,nonce_out} <= {time_out,nonce_out} - 64;

                valid_out_reg <= result_swap < difficulty_swap;
			end
			else begin
			    //Write disabled. Do Nothing.
			    //#### Do nothing. No Changes to all outputs
                time_counter_reg <= time_counter_reg;
                nonce_counter_reg <= nonce_counter_reg;
            end
		end
	end


endmodule
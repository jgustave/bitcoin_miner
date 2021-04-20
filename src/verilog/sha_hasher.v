
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

    //Connection from 2nd to 3rd stage
    wire [255:0] digest_out_2;


    wire         write_enable_3; //Start clocking the third stage
    wire         valid_out_2; //Second stage pipeline output valid
    wire         valid_out_3; //third...

    reg [31:0]   time_counter_reg;
    reg [31:0]   nonce_counter_reg;

    wire [255:0]  difficulty;
    wire [255:0]  difficulty_swap;
    wire [255:0]  result_swap;

    wire [63:0]   reverse_wire; //solution.
    wire [255:0]  result_out_internal;

    reg stop_all_reg;

    //second stage
    sha256_2_pipeline sha2(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en & !valid_out),
                          .digest_intial(digest_intial),
                          .digest_in(digest_in),
                          .block_in({merkle_in,time_counter_reg,target_in,nonce_counter_reg}),
                          .digest_out(digest_out_2),
                          .valid_out(valid_out_2) );

    //third stage
    sha256_3_pipeline sha3(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_enable_3 & !valid_out),
                          .block_in(digest_out_2),
                          .digest_out(result_out_internal),
                          .valid_out(valid_out_3) );

    assign difficulty = (256'b0 | target_in[31:8]) << (8 * ( 32 - target_in[7:0] ));
    assign write_enable_3 = write_en & valid_out_2;

    //Change endianness for comparison.
    assign difficulty_swap = {{difficulty[7:0]},
                              {difficulty[15:8]},
                              {difficulty[23:16]},
                              {difficulty[31:24]},
                              {difficulty[39:32]},
                              {difficulty[47:40]},
                              {difficulty[55:48]},
                              {difficulty[63:56]},
                              {difficulty[71:64]},
                              {difficulty[79:72]},
                              {difficulty[87:80]},
                              {difficulty[95:88]},
                              {difficulty[103:96]},
                              {difficulty[111:104]},
                              {difficulty[119:112]},
                              {difficulty[127:120]},
                              {difficulty[135:128]},
                              {difficulty[143:136]},
                              {difficulty[151:144]},
                              {difficulty[159:152]},
                              {difficulty[167:160]},
                              {difficulty[175:168]},
                              {difficulty[183:176]},
                              {difficulty[191:184]},
                              {difficulty[199:192]},
                              {difficulty[207:200]},
                              {difficulty[215:208]},
                              {difficulty[223:216]},
                              {difficulty[231:224]},
                              {difficulty[239:232]},
                              {difficulty[247:240]},
                              {difficulty[255:248]}
                              };
    assign result_swap = {{result_out_internal[7:0]},
                              {result_out_internal[15:8]},
                              {result_out_internal[23:16]},
                              {result_out_internal[31:24]},
                              {result_out_internal[39:32]},
                              {result_out_internal[47:40]},
                              {result_out_internal[55:48]},
                              {result_out_internal[63:56]},
                              {result_out_internal[71:64]},
                              {result_out_internal[79:72]},
                              {result_out_internal[87:80]},
                              {result_out_internal[95:88]},
                              {result_out_internal[103:96]},
                              {result_out_internal[111:104]},
                              {result_out_internal[119:112]},
                              {result_out_internal[127:120]},
                              {result_out_internal[135:128]},
                              {result_out_internal[143:136]},
                              {result_out_internal[151:144]},
                              {result_out_internal[159:152]},
                              {result_out_internal[167:160]},
                              {result_out_internal[175:168]},
                              {result_out_internal[183:176]},
                              {result_out_internal[191:184]},
                              {result_out_internal[199:192]},
                              {result_out_internal[207:200]},
                              {result_out_internal[215:208]},
                              {result_out_internal[223:216]},
                              {result_out_internal[231:224]},
                              {result_out_internal[239:232]},
                              {result_out_internal[247:240]},
                              {result_out_internal[255:248]}
                              };

    //detect solution found
    assign valid_out = valid_out_3 & result_swap < difficulty_swap;
    assign result_out = !valid_out? 255'b0 : result_out_internal;
    assign reverse_wire = !valid_out? 64'b0 : {time_counter_reg,nonce_counter_reg}-131;
    assign nonce_out = reverse_wire[31:0];
    assign time_out = reverse_wire[63:32];


	always @(posedge CLK or negedge RST)
	begin
		if(RST == 1'b0) begin
            stop_all_reg=0;

		    //###RESET
			nonce_counter_reg <= nonce_in;
			time_counter_reg <= time_in;
		end
		else begin
			if(!stop_all_reg & write_en == 1'b1 ) begin
			    if ( valid_out ) begin
			        stop_all_reg=1; //TODO: needed?
			    end
			    else begin
                    //Normal operation. Increment and check
                    //Check results set flags, set outputs
                    {time_counter_reg,nonce_counter_reg} <= {time_counter_reg,nonce_counter_reg} + 1;
                end
			end
			else begin
			    //Write disabled. Do Nothing.
			    //#### Do nothing. No Changes to all outputs
                time_counter_reg <= time_counter_reg;
                nonce_counter_reg <= nonce_counter_reg;
                stop_all_reg <= stop_all_reg;
                //TODO: assign other floating outputs.
            end
		end
	end


endmodule
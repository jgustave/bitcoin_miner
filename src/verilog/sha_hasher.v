
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

    //wire [255:0] difficulty;
    wire [255:0]  difficulty;

    wire [255:0]  difficulty_swap;
    wire [255:0]  result_swap;

    wire valid_out_wire;

    wire [63:0]   reverse_wire;

    reg stop_all_reg;
    wire write_en_out;

    wire result_found;

    //second stage
    sha256_2_pipeline sha2(.CLK(CLK),
                          .RST(RST),
                          .write_en(!stop_all_reg & write_en),
                          .digest_intial(digest_intial),
                          .digest_in(digest_in),
                          .block_in({merkle_in,time_counter_reg,target_in,nonce_counter_reg}),
                          .digest_out(digest_out_2),
                          .valid_out(valid_out_2) );

    //third stage
    sha256_3_pipeline sha3(.CLK(CLK),
                          .RST(RST),
                          .write_en(!stop_all_reg & write_enable_3),
                          .block_in(digest_out_2),
                          .digest_out(result_out),
                          .valid_out(valid_out_3) );



    //back out the solution TODO: make conditional on solved.
    //assign reverse_wire = !valid_out_wire? 64'b0 : {time_counter_reg,nonce_counter_reg}-131;
    assign reverse_wire = {time_counter_reg,nonce_counter_reg}-131;

    assign difficulty = (256'b0 | target_in[31:8]) << (8 * ( 32 - target_in[7:0] ));

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

    //detect solution found
    assign valid_out = valid_out_3;
    assign write_enable_3 = write_en & valid_out_2;
    assign valid_out_wire = result_swap < difficulty_swap;

    //assign

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
			    if ( valid_out_3 & valid_out_wire ) begin
			        $display("################# %h %h", !stop_all_reg, write_enable_3 );
			        //write_foo=0;
			        stop_all_reg=1;
			        $display(". %h %h", !stop_all_reg, write_enable_3 );
			    end
			    else begin
			        $display("x %h %h", !stop_all_reg, write_enable_3 );
                    //Normal operation. Increment and check
                    //Check results set flags, set outputs
                    {time_counter_reg,nonce_counter_reg} <= {time_counter_reg,nonce_counter_reg} + 1;
                end
			end
			else begin
			    $display("PASS %h %h", !stop_all_reg, write_enable_3 );
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
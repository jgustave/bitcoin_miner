//-------------------------------------------------------------------------------------------------//
//  File name	: sha256_Core_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA256 Core for Blockchain 				    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_2_pipeline(
						input 	wire 			CLK,
						input	wire			RST,
						input	wire			write_en,


						input	wire	[255:0]	digest_intial, //This gets added to result of MC at end. This is the normal SHA256 result of previous run.
						input	wire	[255:0]	digest_in, //This is used to continue input to he MC stage (midState) It is clocked ahead.

						input	wire	[127:0] block_in, //This is 4 ints that we can control in Message part 2
						output	wire	[255:0]	digest_out,
						output  wire            valid_out
);
    //These wires are inputs between message expander stages.. These contain the data that each expander stage needs
    //to calculate the input the the MC, the result of each ME stage is stored in w_X (via an assign statement below)
    //They have varying sizes because we don't need to forward all the data
    //wire [127:0] block_loop_0; not needed.
    wire [127:0] block_loop_1;
    wire [127:0] block_loop_2;
    wire [127:0] block_loop_3;
    wire [127:0] block_loop_4;
	wire [127:0] block_loop_5;
	wire [127:0] block_loop_6;
	wire [127:0] block_loop_7;
	wire [127:0] block_loop_8;
	wire [127:0] block_loop_9;
	wire [127:0] block_loop_10;
	wire [127:0] block_loop_11;
	wire [127:0] block_loop_12;
	wire [127:0] block_loop_13;
	wire [127:0] block_loop_14;
	wire [127:0] block_loop_15;
	wire [127:0] block_loop_16;
	wire [127:0] block_loop_17;
	wire [127:0] block_loop_18;
	wire [127:0] block_loop_19;
	wire [159:0] block_loop_20;
	wire [191:0] block_loop_21;
	wire [223:0] block_loop_22;
	wire [255:0] block_loop_23;
	wire [287:0] block_loop_24;
	wire [319:0] block_loop_25;
	wire [351:0] block_loop_26;
	wire [383:0] block_loop_27;
	wire [415:0] block_loop_28;
	wire [447:0] block_loop_29;
	wire [479:0] block_loop_30;
	wire [511:0] block_loop_31;
	wire [511:0] block_loop_32;
	wire [511:0] block_loop_33;
	wire [511:0] block_loop_34;
	wire [511:0] block_loop_35;
	wire [511:0] block_loop_36;
	wire [511:0] block_loop_37;
	wire [511:0] block_loop_38;
	wire [511:0] block_loop_39;
	wire [511:0] block_loop_40;
	wire [511:0] block_loop_41;
	wire [511:0] block_loop_42;
	wire [511:0] block_loop_43;
	wire [511:0] block_loop_44;
	wire [511:0] block_loop_45;
	wire [511:0] block_loop_46;
	wire [511:0] block_loop_47;
	wire [511:0] block_loop_48;
	wire [511:0] block_loop_49;
	wire [511:0] block_loop_50;
	wire [511:0] block_loop_51;
	wire [511:0] block_loop_52;
	wire [511:0] block_loop_53;
	wire [511:0] block_loop_54;
	wire [511:0] block_loop_55;
	wire [511:0] block_loop_56;
	wire [479:0] block_loop_57;
	wire [415:0] block_loop_58;
	wire [351:0] block_loop_59;
	wire [287:0] block_loop_60;
	wire [223:0] block_loop_61;
	wire [159:0] block_loop_62;
	wire [31:0]  block_loop_63;

	// Digest_wires

    //Digest 0 is pre-calculated and passed in
    //wire [255:0] digest_loop_0;
    wire [255:0] digest_loop_1;
    wire [255:0] digest_loop_2;
    wire [255:0] digest_loop_3;
	wire [255:0] digest_loop_4;
	wire [255:0] digest_loop_5;
	wire [255:0] digest_loop_6;
	wire [255:0] digest_loop_7;
	wire [255:0] digest_loop_8;
	wire [255:0] digest_loop_9;
	wire [255:0] digest_loop_10;
	wire [255:0] digest_loop_11;
	wire [255:0] digest_loop_12;
	wire [255:0] digest_loop_13;
	wire [255:0] digest_loop_14;
	wire [255:0] digest_loop_15;
	wire [255:0] digest_loop_16;
	wire [255:0] digest_loop_17;
	wire [255:0] digest_loop_18;
	wire [255:0] digest_loop_19;
	wire [255:0] digest_loop_20;
	wire [255:0] digest_loop_21;
	wire [255:0] digest_loop_22;
	wire [255:0] digest_loop_23;
	wire [255:0] digest_loop_24;
	wire [255:0] digest_loop_25;
	wire [255:0] digest_loop_26;
	wire [255:0] digest_loop_27;
	wire [255:0] digest_loop_28;
	wire [255:0] digest_loop_29;
	wire [255:0] digest_loop_30;
	wire [255:0] digest_loop_31;
	wire [255:0] digest_loop_32;
	wire [255:0] digest_loop_33;
	wire [255:0] digest_loop_34;
	wire [255:0] digest_loop_35;
	wire [255:0] digest_loop_36;
	wire [255:0] digest_loop_37;
	wire [255:0] digest_loop_38;
	wire [255:0] digest_loop_39;
	wire [255:0] digest_loop_40;
	wire [255:0] digest_loop_41;
	wire [255:0] digest_loop_42;
	wire [255:0] digest_loop_43;
	wire [255:0] digest_loop_44;
	wire [255:0] digest_loop_45;
	wire [255:0] digest_loop_46;
	wire [255:0] digest_loop_47;
	wire [255:0] digest_loop_48;
	wire [255:0] digest_loop_49;
	wire [255:0] digest_loop_50;
	wire [255:0] digest_loop_51;
	wire [255:0] digest_loop_52;
	wire [255:0] digest_loop_53;
	wire [255:0] digest_loop_54;
	wire [255:0] digest_loop_55;
	wire [255:0] digest_loop_56;
	wire [255:0] digest_loop_57;
	wire [255:0] digest_loop_58;
	wire [255:0] digest_loop_59;
	wire [255:0] digest_loop_60;
	wire [255:0] digest_loop_61;
	wire [255:0] digest_loop_62;
	wire [255:0] digest_loop_63;

	// wi


    //Known values of w since they are constant.
	parameter [31:0] w_i_loop_4 = 32'h80000000;
	parameter [31:0] w_i_loop_5 = 32'h0;
	parameter [31:0] w_i_loop_6 = 32'h0;
	parameter [31:0] w_i_loop_7 = 32'h0;
	parameter [31:0] w_i_loop_8 = 32'h0;
	parameter [31:0] w_i_loop_9 = 32'h0;
	parameter [31:0] w_i_loop_10 = 32'h0;
	parameter [31:0] w_i_loop_11 = 32'h0;
	parameter [31:0] w_i_loop_12 = 32'h0;
	parameter [31:0] w_i_loop_13 = 32'h0;
	parameter [31:0] w_i_loop_14 = 32'h0;
	parameter [31:0] w_i_loop_15 = 32'h00000280;

//Message Expander outputs that are input in the the Message Compressor.
//Each stage of MC only uses 32bits from the ME work
//First 16 are just copies of the input.
    //wire [31:0] w_i_loop_0; not used (Stage 0 is pre calculated in software since it repeats)
    wire [31:0] w_i_loop_1; //timestamp
    wire [31:0] w_i_loop_2; //target(difficulty)
    wire [31:0] w_i_loop_3; //nonce
	wire [31:0] w_i_loop_16;
	wire [31:0] w_i_loop_17;
	wire [31:0] w_i_loop_18;
	wire [31:0] w_i_loop_19;
	wire [31:0] w_i_loop_20;
	wire [31:0] w_i_loop_21;
	wire [31:0] w_i_loop_22;
	wire [31:0] w_i_loop_23;
	wire [31:0] w_i_loop_24;
	wire [31:0] w_i_loop_25;
	wire [31:0] w_i_loop_26;
	wire [31:0] w_i_loop_27;
	wire [31:0] w_i_loop_28;
	wire [31:0] w_i_loop_29;
	wire [31:0] w_i_loop_30;
	wire [31:0] w_i_loop_31;
	wire [31:0] w_i_loop_32;
	wire [31:0] w_i_loop_33;
	wire [31:0] w_i_loop_34;
	wire [31:0] w_i_loop_35;
	wire [31:0] w_i_loop_36;
	wire [31:0] w_i_loop_37;
	wire [31:0] w_i_loop_38;
	wire [31:0] w_i_loop_39;
	wire [31:0] w_i_loop_40;
	wire [31:0] w_i_loop_41;
	wire [31:0] w_i_loop_42;
	wire [31:0] w_i_loop_43;
	wire [31:0] w_i_loop_44;
	wire [31:0] w_i_loop_45;
	wire [31:0] w_i_loop_46;
	wire [31:0] w_i_loop_47;
	wire [31:0] w_i_loop_48;
	wire [31:0] w_i_loop_49;
	wire [31:0] w_i_loop_50;
	wire [31:0] w_i_loop_51;
	wire [31:0] w_i_loop_52;
	wire [31:0] w_i_loop_53;
	wire [31:0] w_i_loop_54;
	wire [31:0] w_i_loop_55;
	wire [31:0] w_i_loop_56;
	wire [31:0] w_i_loop_57;
	wire [31:0] w_i_loop_58;
	wire [31:0] w_i_loop_59;
	wire [31:0] w_i_loop_60;
	wire [31:0] w_i_loop_61;
	wire [31:0] w_i_loop_62;
	wire [31:0] w_i_loop_63;



    //These are per SHA spec
    //k_0 not needed since we pre-calc
    //parameter [31:0] k_0 = 32'h428a2f98; //Not needed.
    parameter [31:0] k_1 = 32'h71374491;
    parameter [31:0] k_2 = 32'hb5c0fbcf;
    parameter [31:0] k_3 = 32'he9b5dba5;
    parameter [31:0] k_4 = 32'h3956c25b;
    parameter [31:0] k_5 = 32'h59f111f1;
    parameter [31:0] k_6 = 32'h923f82a4;
    parameter [31:0] k_7 = 32'hab1c5ed5;
    parameter [31:0] k_8 = 32'hd807aa98;
    parameter [31:0] k_9 = 32'h12835b01;
    parameter [31:0] k_10 = 32'h243185be;
    parameter [31:0] k_11 = 32'h550c7dc3;
    parameter [31:0] k_12 = 32'h72be5d74;
    parameter [31:0] k_13 = 32'h80deb1fe;
    parameter [31:0] k_14 = 32'h9bdc06a7;
    parameter [31:0] k_15 = 32'hc19bf174;
    parameter [31:0] k_16 = 32'he49b69c1;
    parameter [31:0] k_17 = 32'hefbe4786;
    parameter [31:0] k_18 = 32'h0fc19dc6;
    parameter [31:0] k_19 = 32'h240ca1cc;
    parameter [31:0] k_20 = 32'h2de92c6f;
    parameter [31:0] k_21 = 32'h4a7484aa;
    parameter [31:0] k_22 = 32'h5cb0a9dc;
    parameter [31:0] k_23 = 32'h76f988da;
    parameter [31:0] k_24 = 32'h983e5152;
    parameter [31:0] k_25 = 32'ha831c66d;
    parameter [31:0] k_26 = 32'hb00327c8;
    parameter [31:0] k_27 = 32'hbf597fc7;
    parameter [31:0] k_28 = 32'hc6e00bf3;
    parameter [31:0] k_29 = 32'hd5a79147;
    parameter [31:0] k_30 = 32'h06ca6351;
    parameter [31:0] k_31 = 32'h14292967;
    parameter [31:0] k_32 = 32'h27b70a85;
    parameter [31:0] k_33 = 32'h2e1b2138;
    parameter [31:0] k_34 = 32'h4d2c6dfc;
    parameter [31:0] k_35 = 32'h53380d13;
    parameter [31:0] k_36 = 32'h650a7354;
    parameter [31:0] k_37 = 32'h766a0abb;
    parameter [31:0] k_38 = 32'h81c2c92e;
    parameter [31:0] k_39 = 32'h92722c85;
    parameter [31:0] k_40 = 32'ha2bfe8a1;
    parameter [31:0] k_41 = 32'ha81a664b;
    parameter [31:0] k_42 = 32'hc24b8b70;
    parameter [31:0] k_43 = 32'hc76c51a3;
    parameter [31:0] k_44 = 32'hd192e819;
    parameter [31:0] k_45 = 32'hd6990624;
    parameter [31:0] k_46 = 32'hf40e3585;
    parameter [31:0] k_47 = 32'h106aa070;
    parameter [31:0] k_48 = 32'h19a4c116;
    parameter [31:0] k_49 = 32'h1e376c08;
    parameter [31:0] k_50 = 32'h2748774c;
    parameter [31:0] k_51 = 32'h34b0bcb5;
    parameter [31:0] k_52 = 32'h391c0cb3;
    parameter [31:0] k_53 = 32'h4ed8aa4a;
    parameter [31:0] k_54 = 32'h5b9cca4f;
    parameter [31:0] k_55 = 32'h682e6ff3;
    parameter [31:0] k_56 = 32'h748f82ee;
    parameter [31:0] k_57 = 32'h78a5636f;
    parameter [31:0] k_58 = 32'h84c87814;
    parameter [31:0] k_59 = 32'h8cc70208;
    parameter [31:0] k_60 = 32'h90befffa;
    parameter [31:0] k_61 = 32'ha4506ceb;
    parameter [31:0] k_62 = 32'hbef9a3f7;
    parameter [31:0] k_63 = 32'hc67178f2;


	mem_save_block_128 ins1_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_in),
		.block_out(block_loop_1)
	);
	mem_save_block_128 ins2_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_1),
		.block_out(block_loop_2)
	);
	mem_save_block_128 ins3_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_2),
		.block_out(block_loop_3)
	);
	mem_save_block_128 ins4_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_3),
		.block_out(block_loop_4)
	);
	mem_save_block_128 ins5_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_4),
		.block_out(block_loop_5)
	);
	mem_save_block_128 ins6_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_5),
		.block_out(block_loop_6)
	);
	mem_save_block_128 ins7_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_6),
		.block_out(block_loop_7)
	);
	mem_save_block_128 ins8_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_7),
		.block_out(block_loop_8)
	);
	mem_save_block_128 ins9_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_8),
		.block_out(block_loop_9)
	);
	mem_save_block_128 ins10_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_9),
		.block_out(block_loop_10)
	);
	mem_save_block_128 ins11_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_10),
		.block_out(block_loop_11)
	);
	mem_save_block_128 ins12_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_11),
		.block_out(block_loop_12)
	);
	mem_save_block_128 ins13_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_12),
		.block_out(block_loop_13)
	);
	mem_save_block_128 ins14_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_13),
		.block_out(block_loop_14)
	);
	mem_save_block_128 ins15_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.block_in(block_loop_14),
		.block_out(block_loop_15)
	);
	sha256_w_mem_for_pipeline_16_2 ins16_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_15),
		.block_out(block_loop_16)
	);
	sha256_w_mem_for_pipeline_17_2 ins17_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_16),
		.block_out(block_loop_17)
	);
	sha256_w_mem_for_pipeline_18_2 ins18_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_17),
		.block_out(block_loop_18)
	);
	sha256_w_mem_for_pipeline_19_2 ins19_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_18),
		.block_out(block_loop_19)
	);
	sha256_w_mem_for_pipeline_20_2 ins20_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_19),
		.block_out(block_loop_20)
	);
	sha256_w_mem_for_pipeline_21_2 ins21_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_20),
		.block_out(block_loop_21)
	);
	sha256_w_mem_for_pipeline_22_2 ins22_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_21),
		.block_out(block_loop_22)
	);
	sha256_w_mem_for_pipeline_23_2 ins23_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_22),
		.block_out(block_loop_23)
	);
	sha256_w_mem_for_pipeline_24_2 ins24_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_23),
		.block_out(block_loop_24)
	);
	sha256_w_mem_for_pipeline_25_2 ins25_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_24),
		.block_out(block_loop_25)
	);
	sha256_w_mem_for_pipeline_26_2 ins26_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_25),
		.block_out(block_loop_26)
	);
	sha256_w_mem_for_pipeline_27_2 ins27_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_26),
		.block_out(block_loop_27)
	);
	sha256_w_mem_for_pipeline_28_2 ins28_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_27),
		.block_out(block_loop_28)
	);
	sha256_w_mem_for_pipeline_29_2 ins29_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_28),
		.block_out(block_loop_29)
	);
	sha256_w_mem_for_pipeline_30_2 ins30_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_29),
		.block_out(block_loop_30)
	);
	sha256_w_mem_for_pipeline_31_2 ins31_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_30),
		.block_out(block_loop_31)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins32_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_31),
		.block_out(block_loop_32)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins33_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_32),
		.block_out(block_loop_33)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins34_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_33),
		.block_out(block_loop_34)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins35_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_34),
		.block_out(block_loop_35)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins36_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_35),
		.block_out(block_loop_36)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins37_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_36),
		.block_out(block_loop_37)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins38_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_37),
		.block_out(block_loop_38)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins39_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_38),
		.block_out(block_loop_39)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins40_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_39),
		.block_out(block_loop_40)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins41_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_40),
		.block_out(block_loop_41)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins42_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_41),
		.block_out(block_loop_42)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins43_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_42),
		.block_out(block_loop_43)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins44_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_43),
		.block_out(block_loop_44)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins45_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_44),
		.block_out(block_loop_45)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins46_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_45),
		.block_out(block_loop_46)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins47_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_46),
		.block_out(block_loop_47)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins48_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_47),
		.block_out(block_loop_48)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins49_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_48),
		.block_out(block_loop_49)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins50_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_49),
		.block_out(block_loop_50)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins51_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_50),
		.block_out(block_loop_51)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins52_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_51),
		.block_out(block_loop_52)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins53_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_52),
		.block_out(block_loop_53)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins54_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_53),
		.block_out(block_loop_54)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins55_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_54),
		.block_out(block_loop_55)
	);
	sha256_w_mem_for_pipeline_32to56_2 ins56_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_55),
		.block_out(block_loop_56)
	);
	sha256_w_mem_for_pipeline_57_2 ins57_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_56),
		.block_out(block_loop_57)
	);
	sha256_w_mem_for_pipeline_58_2 ins58_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_57),
		.block_out(block_loop_58)
	);
	sha256_w_mem_for_pipeline_59_2 ins59_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_58),
		.block_out(block_loop_59)
	);
	sha256_w_mem_for_pipeline_60_2 ins60_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_59),
		.block_out(block_loop_60)
	);
	sha256_w_mem_for_pipeline_61_2 ins61_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_60),
		.block_out(block_loop_61)
	);
	sha256_w_mem_for_pipeline_62_2 ins62_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_61),
		.block_out(block_loop_62)
	);
	sha256_w_mem_for_pipeline_63_2 ins63_w_mem(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.block_in(block_loop_62),
		.block_out(block_loop_63)
	);

//////////////////////////////////////////////////////////////////////////
//	Instance of all main_loops
//We skip the first stage since we pre-calc it and its constant
/*	main_loop_for_pipeline_0to63 ins_main_loop_0(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.k_i(k_0),
		.w_i(w_i_loop_0),
		.digest_in(digest_in),
		.digest_out(digest_loop_0)
	);
*/

	main_loop_for_pipeline_4to63 ins_main_loop_1(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_1),

		.w_i(w_i_loop_1),
		.digest_in(digest_in), //initial state, which is the usual initial state(abcdefgh) but clocked ahead 1 in the 2 message set.
		.digest_out(digest_loop_1)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_2(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_2),

		.w_i(w_i_loop_2),
		.digest_in(digest_loop_1),
		.digest_out(digest_loop_2)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_3(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_3),

		.w_i(w_i_loop_3),
		.digest_in(digest_loop_2),
		.digest_out(digest_loop_3)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_4(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_4),

		.w_i(w_i_loop_4),
		.digest_in(digest_loop_3),
		.digest_out(digest_loop_4)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_5(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_5),

		.w_i(w_i_loop_5),
		.digest_in(digest_loop_4),
		.digest_out(digest_loop_5)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_6(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_6),

		.w_i(w_i_loop_6),
		.digest_in(digest_loop_5),
		.digest_out(digest_loop_6)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_7(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_7),

		.w_i(w_i_loop_7),
		.digest_in(digest_loop_6),
		.digest_out(digest_loop_7)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_8(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_8),

		.w_i(w_i_loop_8),
		.digest_in(digest_loop_7),
		.digest_out(digest_loop_8)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_9(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_9),

		.w_i(w_i_loop_9),
		.digest_in(digest_loop_8),
		.digest_out(digest_loop_9)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_10(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_10),

		.w_i(w_i_loop_10),
		.digest_in(digest_loop_9),
		.digest_out(digest_loop_10)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_11(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_11),

		.w_i(w_i_loop_11),
		.digest_in(digest_loop_10),
		.digest_out(digest_loop_11)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_12(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_12),

		.w_i(w_i_loop_12),
		.digest_in(digest_loop_11),
		.digest_out(digest_loop_12)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_13(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_13),

		.w_i(w_i_loop_13),
		.digest_in(digest_loop_12),
		.digest_out(digest_loop_13)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_14(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_14),

		.w_i(w_i_loop_14),
		.digest_in(digest_loop_13),
		.digest_out(digest_loop_14)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_15(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_15),

		.w_i(w_i_loop_15),
		.digest_in(digest_loop_14),
		.digest_out(digest_loop_15)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_16(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_16),

		.w_i(w_i_loop_16),
		.digest_in(digest_loop_15),
		.digest_out(digest_loop_16)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_17(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_17),

		.w_i(w_i_loop_17),
		.digest_in(digest_loop_16),
		.digest_out(digest_loop_17)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_18(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_18),

		.w_i(w_i_loop_18),
		.digest_in(digest_loop_17),
		.digest_out(digest_loop_18)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_19(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_19),

		.w_i(w_i_loop_19),
		.digest_in(digest_loop_18),
		.digest_out(digest_loop_19)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_20(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_20),

		.w_i(w_i_loop_20),
		.digest_in(digest_loop_19),
		.digest_out(digest_loop_20)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_21(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_21),

		.w_i(w_i_loop_21),
		.digest_in(digest_loop_20),
		.digest_out(digest_loop_21)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_22(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_22),

		.w_i(w_i_loop_22),
		.digest_in(digest_loop_21),
		.digest_out(digest_loop_22)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_23(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_23),

		.w_i(w_i_loop_23),
		.digest_in(digest_loop_22),
		.digest_out(digest_loop_23)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_24(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_24),

		.w_i(w_i_loop_24),
		.digest_in(digest_loop_23),
		.digest_out(digest_loop_24)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_25(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_25),

		.w_i(w_i_loop_25),
		.digest_in(digest_loop_24),
		.digest_out(digest_loop_25)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_26(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_26),

		.w_i(w_i_loop_26),
		.digest_in(digest_loop_25),
		.digest_out(digest_loop_26)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_27(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_27),

		.w_i(w_i_loop_27),
		.digest_in(digest_loop_26),
		.digest_out(digest_loop_27)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_28(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_28),

		.w_i(w_i_loop_28),
		.digest_in(digest_loop_27),
		.digest_out(digest_loop_28)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_29(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_29),

		.w_i(w_i_loop_29),
		.digest_in(digest_loop_28),
		.digest_out(digest_loop_29)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_30(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_30),

		.w_i(w_i_loop_30),
		.digest_in(digest_loop_29),
		.digest_out(digest_loop_30)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_31(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_31),

		.w_i(w_i_loop_31),
		.digest_in(digest_loop_30),
		.digest_out(digest_loop_31)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_32(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_32),

		.w_i(w_i_loop_32),
		.digest_in(digest_loop_31),
		.digest_out(digest_loop_32)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_33(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_33),

		.w_i(w_i_loop_33),
		.digest_in(digest_loop_32),
		.digest_out(digest_loop_33)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_34(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_34),

		.w_i(w_i_loop_34),
		.digest_in(digest_loop_33),
		.digest_out(digest_loop_34)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_35(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_35),

		.w_i(w_i_loop_35),
		.digest_in(digest_loop_34),
		.digest_out(digest_loop_35)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_36(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_36),

		.w_i(w_i_loop_36),
		.digest_in(digest_loop_35),
		.digest_out(digest_loop_36)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_37(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_37),

		.w_i(w_i_loop_37),
		.digest_in(digest_loop_36),
		.digest_out(digest_loop_37)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_38(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_38),

		.w_i(w_i_loop_38),
		.digest_in(digest_loop_37),
		.digest_out(digest_loop_38)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_39(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_39),

		.w_i(w_i_loop_39),
		.digest_in(digest_loop_38),
		.digest_out(digest_loop_39)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_40(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_40),

		.w_i(w_i_loop_40),
		.digest_in(digest_loop_39),
		.digest_out(digest_loop_40)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_41(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_41),

		.w_i(w_i_loop_41),
		.digest_in(digest_loop_40),
		.digest_out(digest_loop_41)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_42(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_42),

		.w_i(w_i_loop_42),
		.digest_in(digest_loop_41),
		.digest_out(digest_loop_42)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_43(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_43),

		.w_i(w_i_loop_43),
		.digest_in(digest_loop_42),
		.digest_out(digest_loop_43)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_44(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_44),

		.w_i(w_i_loop_44),
		.digest_in(digest_loop_43),
		.digest_out(digest_loop_44)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_45(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_45),

		.w_i(w_i_loop_45),
		.digest_in(digest_loop_44),
		.digest_out(digest_loop_45)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_46(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_46),

		.w_i(w_i_loop_46),
		.digest_in(digest_loop_45),
		.digest_out(digest_loop_46)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_47(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_47),

		.w_i(w_i_loop_47),
		.digest_in(digest_loop_46),
		.digest_out(digest_loop_47)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_48(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_48),

		.w_i(w_i_loop_48),
		.digest_in(digest_loop_47),
		.digest_out(digest_loop_48)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_49(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_49),

		.w_i(w_i_loop_49),
		.digest_in(digest_loop_48),
		.digest_out(digest_loop_49)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_50(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_50),

		.w_i(w_i_loop_50),
		.digest_in(digest_loop_49),
		.digest_out(digest_loop_50)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_51(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_51),

		.w_i(w_i_loop_51),
		.digest_in(digest_loop_50),
		.digest_out(digest_loop_51)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_52(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_52),

		.w_i(w_i_loop_52),
		.digest_in(digest_loop_51),
		.digest_out(digest_loop_52)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_53(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_53),

		.w_i(w_i_loop_53),
		.digest_in(digest_loop_52),
		.digest_out(digest_loop_53)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_54(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_54),

		.w_i(w_i_loop_54),
		.digest_in(digest_loop_53),
		.digest_out(digest_loop_54)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_55(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_55),

		.w_i(w_i_loop_55),
		.digest_in(digest_loop_54),
		.digest_out(digest_loop_55)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_56(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_56),

		.w_i(w_i_loop_56),
		.digest_in(digest_loop_55),
		.digest_out(digest_loop_56)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_57(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.k_i(k_57),
		.w_i(w_i_loop_57),
		.digest_in(digest_loop_56),
		.digest_out(digest_loop_57)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_58(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_58),

		.w_i(w_i_loop_58),
		.digest_in(digest_loop_57),
		.digest_out(digest_loop_58)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_59(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_59),

		.w_i(w_i_loop_59),
		.digest_in(digest_loop_58),
		.digest_out(digest_loop_59)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_60(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_60),

		.w_i(w_i_loop_60),
		.digest_in(digest_loop_59),
		.digest_out(digest_loop_60)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_61(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_61),

		.w_i(w_i_loop_61),
		.digest_in(digest_loop_60),
		.digest_out(digest_loop_61)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_62(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_62),

		.w_i(w_i_loop_62),
		.digest_in(digest_loop_61),
		.digest_out(digest_loop_62)
	);
	main_loop_for_pipeline_4to63 ins_main_loop_63(
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),

		.k_i(k_63),

		.w_i(w_i_loop_63),
		.digest_in(digest_loop_62),
		.digest_out(digest_loop_63)
	);



    //assign w_i_loop_0 =  block_loop_1[127:96]; //Stays the same while we run and pre-calced in previous stage.
    assign w_i_loop_1 =  block_loop_1[95:64];
    assign w_i_loop_2 =  block_loop_2[63:32];
    assign w_i_loop_3 =  block_loop_3[31:0];

    //4-15 are known constants.

	assign w_i_loop_16 =  block_loop_16[31:0];
	assign w_i_loop_17 =  block_loop_17[31:0];
	assign w_i_loop_18 =  block_loop_18[31:0];
	assign w_i_loop_19 =  block_loop_19[31:0];
	assign w_i_loop_20 =  block_loop_20[31:0];
	assign w_i_loop_21 =  block_loop_21[31:0];
	assign w_i_loop_22 =  block_loop_22[31:0];
	assign w_i_loop_23 =  block_loop_23[31:0];
	assign w_i_loop_24 =  block_loop_24[31:0];
	assign w_i_loop_25 =  block_loop_25[31:0];
	assign w_i_loop_26 =  block_loop_26[31:0];
	assign w_i_loop_27 =  block_loop_27[31:0];
	assign w_i_loop_28 =  block_loop_28[31:0];
	assign w_i_loop_29 =  block_loop_29[31:0];
	assign w_i_loop_30 =  block_loop_30[31:0];
	assign w_i_loop_31 =  block_loop_31[31:0];
	assign w_i_loop_32 =  block_loop_32[31:0];
	assign w_i_loop_33 =  block_loop_33[31:0];
	assign w_i_loop_34 =  block_loop_34[31:0];
	assign w_i_loop_35 =  block_loop_35[31:0];
	assign w_i_loop_36 =  block_loop_36[31:0];
	assign w_i_loop_37 =  block_loop_37[31:0];
	assign w_i_loop_38 =  block_loop_38[31:0];
	assign w_i_loop_39 =  block_loop_39[31:0];
	assign w_i_loop_40 =  block_loop_40[31:0];
	assign w_i_loop_41 =  block_loop_41[31:0];
	assign w_i_loop_42 =  block_loop_42[31:0];
	assign w_i_loop_43 =  block_loop_43[31:0];
	assign w_i_loop_44 =  block_loop_44[31:0];
	assign w_i_loop_45 =  block_loop_45[31:0];
	assign w_i_loop_46 =  block_loop_46[31:0];
	assign w_i_loop_47 =  block_loop_47[31:0];
	assign w_i_loop_48 =  block_loop_48[31:0];
	assign w_i_loop_49 =  block_loop_49[31:0];
	assign w_i_loop_50 =  block_loop_50[31:0];
	assign w_i_loop_51 =  block_loop_51[31:0];
	assign w_i_loop_52 =  block_loop_52[31:0];
	assign w_i_loop_53 =  block_loop_53[31:0];
	assign w_i_loop_54 =  block_loop_54[31:0];
	assign w_i_loop_55 =  block_loop_55[31:0];
	assign w_i_loop_56 =  block_loop_56[31:0];
	assign w_i_loop_57 =  block_loop_57[31:0];
	assign w_i_loop_58 =  block_loop_58[31:0];
	assign w_i_loop_59 =  block_loop_59[31:0];
	assign w_i_loop_60 =  block_loop_60[31:0];
	assign w_i_loop_61 =  block_loop_61[31:0];
	assign w_i_loop_62 =  block_loop_62[31:0];
	assign w_i_loop_63 =  block_loop_63[31:0];


	reg [255:0] digest_out_reg;
	reg  		valid_out_reg;
	reg [6:0]   counter_reg;

	assign digest_out = digest_out_reg;
	assign valid_out  = valid_out_reg;


	///////
	always @(posedge CLK or negedge RST)
	begin
		if(RST == 1'b0) begin
			digest_out_reg <= 256'b0;
			valid_out_reg <= 1'b0;
			counter_reg <= 6'b0; //TODO: odd how do we get to 65 in 6 bits?
		end
		else begin
			if(write_en == 1'b1 & counter_reg==64) begin
                valid_out_reg <=1'b1;
                counter_reg <= counter_reg;
                //Last step of MC is to add results of 64 rounds to previous result
                //This is somewhat confusing, but the previous digest stays constant even though
                //we are getting new results every clock.
                digest_out_reg[255:224] <=  digest_intial[255:224] +digest_loop_63[255:224];
                digest_out_reg[223:192] <= digest_intial[223:192] + digest_loop_63[223:192];
                digest_out_reg[191:160] <= digest_intial[191:160] + digest_loop_63[191:160];
                digest_out_reg[159:128] <= digest_intial[159:128] + digest_loop_63[159:128];
                digest_out_reg[127:96] <= digest_intial[127:96] + digest_loop_63[127:96];
                digest_out_reg[95:64] <= digest_intial[95:64] + digest_loop_63[95:64];
                digest_out_reg[63:32] <= digest_intial[63:32] + digest_loop_63[63:32];
                digest_out_reg[31:0] <= digest_intial[31:0] + digest_loop_63[31:0];
			end
			else if(write_en == 1'b1) begin
				counter_reg <= counter_reg + 1;
				valid_out_reg <= 1'b0;
				digest_out_reg <= 256'b0;
			end
			else begin
                digest_out_reg <= digest_out_reg;
                valid_out_reg <=valid_out_reg ;
                counter_reg <= counter_reg;
            end
		end
	end



endmodule

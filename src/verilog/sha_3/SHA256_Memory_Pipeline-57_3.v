 //-------------------------------------------------------------------------------------------------//
//  File name	: SHA256_Memory_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA512 Memory for Blockchain 			    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_w_mem_for_pipeline_57_3(
									input 	wire			CLK,
									input	wire			RST,
									input	wire			write_en,
									input	wire	[511:0] block_in,
									output	wire	[479:0] block_out
);
	wire [479:0] block_out_wire;

	mem_save_block_480 mem_b(
							.CLK(CLK),
							.RST(RST),
							.write_en(write_en),
							.block_in(block_out_wire),
							.block_out(block_out)
	);


	wire [31:0] d0_256;
	wire [31:0] d1_256;

	wire 	[31:0]  w_i;

	wire 	[31:0]  w1;
	wire 	[31:0]  w2;
	wire 	[31:0]  w3;
	wire 	[31:0]  w4;
	wire 	[31:0]  w5;
	wire 	[31:0]  w6;
	wire 	[31:0]  w7;
	wire 	[31:0]  w8;
	wire 	[31:0]  w9;
	wire 	[31:0]  w10;
	wire 	[31:0]  w11;
	wire 	[31:0]  w12;
	wire 	[31:0]  w13;
	wire 	[31:0]  w14;
	wire 	[31:0]  w15;
	wire 	[31:0]  w16;

	assign w1 = block_in[511:480];
	assign w2 = block_in[479:448];
	assign w3 = block_in[447:416];
	assign w4 = block_in[415:384];
	assign w5 = block_in[383:352];
	assign w6 = block_in[351:320];
	assign w7 = block_in[319:288];
	assign w8 = block_in[287:256];
	assign w9 = block_in[255:224];
	assign w10 = block_in[223:192];
	assign w11 = block_in[191:160];
	assign w12 = block_in[159:128];
	assign w13 = block_in[127:96];
	assign w14 = block_in[95:64];
	assign w15 = block_in[63:32];
	assign w16 = block_in[31:0];


	assign d0_256 = {w2[6:0],w2[31:7],w2[6:0],w2[31:7]}^{w2[17:0],w2[31:18],w2[17:0],w2[31:18]}^{3'b000,w2[31:3],3'b000,w2[31:3]};
	assign d1_256 = {w15[16:0],w15[31:17],w15[16:0],w15[31:17]}^{w15[18:0],w15[31:19],w15[18:0],w15[31:19]}^{10'b0000000000,w15[31:10],10'b0000000000,w15[31:10]};


//////

	assign w_i = d0_256 + w10 + d1_256 + w1;

//////
	assign block_out_wire = {w2,w3,w4,w5,w6,w7,w8,w9,w11,w12,w13,w14,w15,w16,w_i};

endmodule

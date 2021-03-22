/**
    This is the pipeline for stage 2 (of 3) of bitcoin SHA-256d of the 2 part header
    As input it takes the already completed SHA-256 of the first half of the Bitcoin header. (stage 1)
    32 bits of Merkle root
    32 bits of timestamp
    32 bits of target (difficulty)
    32 bits of nonce
*/
module main_hasher(
                    input   wire            CLK,
                    input   wire            RST,
                    input   wire            write_en,
                    input   wire    [255:0] digest_1, //full digest of the first half of header
                    input   wire    [32:0]  merkle_tail, //second half of header ...
                    input   wire    [32:0]  timestamp,
                    input   wire    [32:0]  target,
                    input   wire    [32:0]  nonce,
                    output  wire            valid_out, //set to 1 once the pipeline is full and valid results are coming out
                    output  wire    [255:0] digest_out //
);

        reg [255:0]     digest_out_reg; //
        reg             valid_out_reg; //Set to 1 once pipeline full
        reg [7:0]       counter_reg;   //internal counts till pipeline is full


        //Connect wires from reg to output
        assign digest_out = digest_out_reg;
        assign valid_out = valid_out_reg;

        //connect sha_2 pipeline to sha_3 pipline.

        always @(posedge CLK or negedge RST)
        begin
            if(RST == 1'b0) begin
                digest_out_reg <= 256'b0;
                valid_out_reg <= 1'b0;
                counter_reg <= 7'b0;
            end
            else begin
                if(write_en == 1'b1 & counter_reg==128) begin
                        valid_out_reg <=1'b1;
                        counter_reg <= counter_reg;

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
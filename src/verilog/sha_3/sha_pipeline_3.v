/**
    This is the pipeline for stage 2 (of 3) of bitcoin SHA-256d of the 2 part header (we do stage 1 in software)
    As input it takes the already completed SHA-256 of the first half of the Bitcoin header. (stage 1)
    32 bits of Merkle root
    32 bits of timestamp
    32 bits of target (difficulty)
    32 bits of nonce
*/
module hasher_2(
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
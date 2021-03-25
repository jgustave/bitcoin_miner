#!/bin/bash

export SHA2_PATH=/Users/jerdavis/devhome/projects/miner/src/verilog/sha_2

#echo iverilog -o sha2pipe -I$SHA2_PATH sha2_tb.v Block_Memory_128.v Block_Memory_160.v Block_Memory_192.v Block_Memory_224.v Block_Memory_256.v Block_Memory_288.v Block_Memory_320.v Block_Memory_352.v Block_Memory_384.v Block_Memory_416.v Block_Memory_448.v Block_Memory_480.v Block_Memory_512.v

iverilog -o sha2pipe -s sha2_tb $SHA2_PATH/sha2_tb.v $SHA2_PATH/sha_pipeline_2.v $SHA2_PATH/Block_Memory_128.v $SHA2_PATH/Block_Memory_160.v $SHA2_PATH/Block_Memory_192.v $SHA2_PATH/Block_Memory_224.v $SHA2_PATH/Block_Memory_256.v $SHA2_PATH/Block_Memory_288.v $SHA2_PATH/Block_Memory_320.v $SHA2_PATH/Block_Memory_352.v $SHA2_PATH/Block_Memory_384.v $SHA2_PATH/Block_Memory_416.v $SHA2_PATH/Block_Memory_448.v $SHA2_PATH/Block_Memory_480.v $SHA2_PATH/Block_Memory_512.v $SHA2_PATH/SHA256_Memory_Pipeline-16_2.v $SHA2_PATH/SHA256_Memory_Pipeline-17_2.v $SHA2_PATH/SHA256_Memory_Pipeline-18_2.v $SHA2_PATH/SHA256_Memory_Pipeline-19_2.v $SHA2_PATH/SHA256_Memory_Pipeline-20_2.v $SHA2_PATH/SHA256_Memory_Pipeline-21_2.v $SHA2_PATH/SHA256_Memory_Pipeline-22_2.v $SHA2_PATH/SHA256_Memory_Pipeline-23_2.v $SHA2_PATH/SHA256_Memory_Pipeline-24_2.v $SHA2_PATH/SHA256_Memory_Pipeline-25_2.v $SHA2_PATH/SHA256_Memory_Pipeline-26_2.v $SHA2_PATH/SHA256_Memory_Pipeline-27_2.v $SHA2_PATH/SHA256_Memory_Pipeline-28_2.v $SHA2_PATH/SHA256_Memory_Pipeline-29_2.v $SHA2_PATH/SHA256_Memory_Pipeline-30_2.v $SHA2_PATH/SHA256_Memory_Pipeline-31_2.v $SHA2_PATH/SHA256_Memory_Pipeline-32to56_2.v $SHA2_PATH/SHA256_Memory_Pipeline-57_2.v $SHA2_PATH/SHA256_Memory_Pipeline-58_2.v $SHA2_PATH/SHA256_Memory_Pipeline-59_2.v $SHA2_PATH/SHA256_Memory_Pipeline-60_2.v $SHA2_PATH/SHA256_Memory_Pipeline-61_2.v $SHA2_PATH/SHA256_Memory_Pipeline-62_2.v $SHA2_PATH/SHA256_Memory_Pipeline-63_2.v $SHA2_PATH/Main_Loop_Pipeline-4to63_2.v $SHA2_PATH/Digest_Memory_2.v

#iverilog -o my_design pipeline_1.v smallreg.v counter_tb.v
#vvp my_design

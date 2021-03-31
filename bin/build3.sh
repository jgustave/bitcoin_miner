#!/bin/bash

export SHA2_PATH=/Users/jerdavis/devhome/projects/miner/src/verilog/sha_2
export SHA3_PATH=/Users/jerdavis/devhome/projects/miner/src/verilog/sha_3

#echo iverilog -o sha2pipe -I$SHA2_PATH sha2_tb.v Block_Memory_128.v Block_Memory_160.v Block_Memory_192.v Block_Memory_224.v Block_Memory_256.v Block_Memory_288.v Block_Memory_320.v Block_Memory_352.v Block_Memory_384.v Block_Memory_416.v Block_Memory_448.v Block_Memory_480.v Block_Memory_512.v

iverilog -o sha3pipe -s sha3_tb $SHA3_PATH/sha3_tb.v $SHA3_PATH/SHA256_Core_3_Pipeline.v $SHA2_PATH/Block_Memory_128.v $SHA2_PATH/Block_Memory_160.v $SHA2_PATH/Block_Memory_192.v $SHA2_PATH/Block_Memory_224.v $SHA2_PATH/Block_Memory_256.v $SHA2_PATH/Block_Memory_288.v $SHA2_PATH/Block_Memory_320.v $SHA2_PATH/Block_Memory_352.v $SHA2_PATH/Block_Memory_384.v $SHA2_PATH/Block_Memory_416.v $SHA2_PATH/Block_Memory_448.v $SHA2_PATH/Block_Memory_480.v $SHA2_PATH/Block_Memory_512.v $SHA3_PATH/SHA256_Memory_Pipeline-16_3.v $SHA3_PATH/SHA256_Memory_Pipeline-17_3.v $SHA3_PATH/SHA256_Memory_Pipeline-18to21_3.v $SHA3_PATH/SHA256_Memory_Pipeline-22_3.v $SHA3_PATH/SHA256_Memory_Pipeline-23_3.v $SHA3_PATH/SHA256_Memory_Pipeline-24_3.v $SHA3_PATH/SHA256_Memory_Pipeline-25_3.v $SHA3_PATH/SHA256_Memory_Pipeline-26_3.v $SHA3_PATH/SHA256_Memory_Pipeline-27_3.v $SHA3_PATH/SHA256_Memory_Pipeline-28_3.v $SHA3_PATH/SHA256_Memory_Pipeline-29_3.v $SHA3_PATH/SHA256_Memory_Pipeline-30_3.v $SHA3_PATH/SHA256_Memory_Pipeline-31_3.v $SHA3_PATH/SHA256_Memory_Pipeline-32to56_3.v $SHA3_PATH/SHA256_Memory_Pipeline-57_3.v $SHA3_PATH/SHA256_Memory_Pipeline-58_3.v $SHA3_PATH/SHA256_Memory_Pipeline-59_3.v $SHA3_PATH/SHA256_Memory_Pipeline-60_3.v $SHA3_PATH/SHA256_Memory_Pipeline-61_3.v $SHA3_PATH/SHA256_Memory_Pipeline-62_3.v $SHA3_PATH/SHA256_Memory_Pipeline-63_3.v $SHA3_PATH/Main_Loop_Pipeline-0to63.v $SHA3_PATH/Digest_Memory.v

#iverilog -o my_design pipeline_1.v smallreg.v counter_tb.v
#vvp my_design

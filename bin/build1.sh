#!/bin/bash

export SHA2_PATH=/Users/jerdavis/devhome/projects/miner/src/verilog/sha_1

#echo iverilog -o sha2pipe -I$SHA2_PATH sha2_tb.v Block_Memory_128.v Block_Memory_160.v Block_Memory_192.v Block_Memory_224.v Block_Memory_256.v Block_Memory_288.v Block_Memory_320.v Block_Memory_352.v Block_Memory_384.v Block_Memory_416.v Block_Memory_448.v Block_Memory_480.v Block_Memory_512.v

iverilog -o sha1pipe -s sha1_tb $SHA2_PATH/sha1_tb.v $SHA2_PATH/SHA256.v

#iverilog -o my_design pipeline_1.v smallreg.v counter_tb.v
#vvp my_design

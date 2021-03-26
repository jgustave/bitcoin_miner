//`timescale 1ns/1ps

`define assert(signal, value) if (signal !== value) begin $display("ASSERTION FAILED in %m: signal != value"); $finish; end

//`assert (RST,2);
//`assert (1,2);

module sha2_tb();
    reg CLK;
    reg RST;
    reg write_en;

    reg [255:0]	dii;
    reg [255:0]	di;
    reg [127:0] bi;

    wire [255:0]	do;
    wire vo;

    always begin
	    #1 CLK = !CLK;
    end


    sha256_2_pipeline foo(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en),
                          .digest_intial(dii), //TODO: typo
                          .digest_in(di),
                          .block_in(bi),
                          .digest_out(do),
                          .valid_out(vo) );

    initial begin
         $monitor("Hello World");


         $dumpfile("test.vcd");
         $dumpvars(0,sha2_tb);

        //Initialize clock
        CLK = 0;
        RST = 0;
        write_en=1;
        #4
        RST=1;


        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        di =256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        bi =127'h252db801130dae516461011a3aeb9bb8;

        $display("TESTW At time %t, value = %h %h %h",$time, foo.ins16_w_mem.w_i, foo.ins17_w_mem.w_i,foo.ins18_w_mem.w_i );

        $display("TEST1 At time %t, value = %h %h %h",$time, foo.block_loop_5, foo.block_loop_6,foo.block_loop_7 );
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );
        #2
        $display("TEST1 At time %t, value = %h %h %h",$time, foo.block_loop_5, foo.block_loop_6,foo.block_loop_7 );
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );

        #20
        $display("TEST1 At time %t, value = %h %h %h",$time, foo.block_loop_5, foo.block_loop_6,foo.block_loop_7 );
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );
        $display("TESTW At time %t, value = %h %h %h %h %h",$time, foo.ins16_w_mem.w_i, foo.ins17_w_mem.w_i,foo.ins18_w_mem.w_i,foo.ins19_w_mem.w_i,foo.ins20_w_mem.w_i );
        #2
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );
        $display("TESTW At time %t, value = %h %h %h %h %h",$time, foo.ins16_w_mem.w_i, foo.ins17_w_mem.w_i,foo.ins18_w_mem.w_i,foo.ins19_w_mem.w_i,foo.ins20_w_mem.w_i );
        #2
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );
        $display("TESTW At time %t, value = %h %h %h %h %h",$time, foo.ins16_w_mem.w_i, foo.ins17_w_mem.w_i,foo.ins18_w_mem.w_i,foo.ins19_w_mem.w_i,foo.ins20_w_mem.w_i );
        #2
        $display("TEST6 At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16,foo.block_loop_17,foo.block_loop_18 );
        $display("TESTW At time %t, value = %h %h %h %h %h",$time, foo.ins16_w_mem.w_i, foo.ins17_w_mem.w_i,foo.ins18_w_mem.w_i,foo.ins19_w_mem.w_i,foo.ins20_w_mem.w_i );
        #30
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #46
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        `assert(foo.ins63_w_mem.w_i,32'h7bd06b58); //TODO: This is correct value, but timing/clocking is off
        #2
        $display("TESTZ At time %t, value = %h %h %h %h %h",$time, foo.ins59_w_mem.w_i, foo.ins60_w_mem.w_i,foo.ins61_w_mem.w_i,foo.ins62_w_mem.w_i,foo.ins63_w_mem.w_i );
        $display("TESTA At time %t, %h %h %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire);

        #400
        $display("TESTA At time %t, %h %h %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire);
        $display("At time %t, value = %h valid %h",$time, do, vo);
        `assert(foo.ins63_w_mem.w_i,32'h7bd06b58);
        `assert(do,256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467);

        $finish;
    end

endmodule
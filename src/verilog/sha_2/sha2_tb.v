//`timescale 1ns/1ps

//Vivado build etc

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

    wire [255:0] do;
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


        //Actual result of msg1 Added on to the result at end of stage 63
        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;

        //Mid-state. clocked ahead 1
        di =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;

        bi =127'h252db801130dae516461011a3aeb9bb8;

        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
//        $display("MEa: At time %t, value = %h %h %h %h",$time, foo.block_loop_1, foo.block_loop_2, foo.block_loop_3, foo.block_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
        //$display("MCa: At time %t, value = %h %h %h %h",$time, foo.digest_loop_1, foo.digest_loop_2, foo.digest_loop_3, foo.digest_loop_4 );
        $display("MCc: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        #2
        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
//        $display("MEa: At time %t, value = %h %h %h %h",$time, foo.block_loop_1, foo.block_loop_2, foo.block_loop_3, foo.block_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
        //$display("MCa: At time %t, value = %h %h %h %h",$time, foo.digest_loop_1, foo.digest_loop_2, foo.digest_loop_3, foo.digest_loop_4 );
        $display("MCc: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MEa At time %t, value = %h %h %h %h",$time, foo.block_loop_1, foo.block_loop_2, foo.block_loop_3, foo.block_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
        //$display("MCa: At time %t, value = %h %h %h %h",$time, foo.digest_loop_1, foo.digest_loop_2, foo.digest_loop_3, foo.digest_loop_4 );
        $display("MCc: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        `assert(foo.ins_main_loop_1.digest_out_wire,256'h10F2957CF7A528B9F59007B57A2E561625BEF710F2C1816DF6F596588185BBAE);
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MEa At time %t, value = %h %h %h %h",$time, foo.block_loop_1, foo.block_loop_2, foo.block_loop_3, foo.block_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
        `assert(foo.ins_main_loop_2.digest_out_wire,256'h678CD63410F2957CF7A528B9F59007B58681540525BEF710F2C1816DF6F59658);
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.ins_main_loop_3.digest_out_wire,256'h79162787678CD63410F2957CF7A528B95BE8C28B8681540525BEF710F2C1816D);

//        $display("MEa At time %t, value = %h %h %h %h",$time, foo.block_loop_4, foo.block_loop_5, foo.block_loop_6, foo.block_loop_7);
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.digest_loop_1, foo.digest_loop_2, foo.digest_loop_3, foo.digest_loop_4 );

        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.ins_main_loop_4.digest_out_wire,256'h878B488079162787678CD63410F2957C52B97D515BE8C28B8681540525BEF710);

//        $display("MEa At time %t, value = %h %h %h %h",$time, foo.block_loop_4, foo.block_loop_5, foo.block_loop_6, foo.block_loop_7);
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_1, foo.w_i_loop_2, foo.w_i_loop_3, foo.w_i_loop_4 );
//        $display("MCa: At time %t, value = %h %h %h %h",$time, foo.digest_loop_1, foo.digest_loop_2, foo.digest_loop_3, foo.digest_loop_4 );

        #18
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h %h",$time, foo.ins_main_loop_11.digest_out_wire, foo.ins_main_loop_12.digest_out_wire, foo.ins_main_loop_13.digest_out_wire );
        //$display("MEb At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16, foo.block_loop_17, foo.block_loop_18);
        //$display("MCb: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_15, foo.w_i_loop_16, foo.w_i_loop_17, foo.w_i_loop_18 );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        //$display("MEb At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16, foo.block_loop_17, foo.block_loop_18);
        //$display("MCb: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_15, foo.w_i_loop_16, foo.w_i_loop_17, foo.w_i_loop_18 );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        //$display("MEb At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16, foo.block_loop_17, foo.block_loop_18);
        //$display("MCb: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_15, foo.w_i_loop_16, foo.w_i_loop_17, foo.w_i_loop_18 );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h %h",$time, foo.ins_main_loop_14.digest_out_wire, foo.ins_main_loop_15.digest_out_wire, foo.ins_main_loop_16.digest_out_wire );
        //$display("MEb At time %t, value = %h %h %h %h",$time, foo.block_loop_15, foo.block_loop_16, foo.block_loop_17, foo.block_loop_18);
        //$display("MCb: At time %t, value = %h %h %h %h",$time, foo.w_i_loop_15, foo.w_i_loop_16, foo.w_i_loop_17, foo.w_i_loop_18 );

        #86
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_60.digest_out_wire, foo.ins_main_loop_61.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.ins_main_loop_62.digest_out_wire, foo.ins_main_loop_63.digest_out_wire );

        `assert(foo.counter_reg,64);
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hE60E116DBB0F2D17486456C9776FD9E6E93412D5250EF7B412FB586039701CF6);

        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );

        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );

        `assert(foo.digest_out_reg,256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467);
        `assert(foo.valid_out,1);

        #2
        bi =127'h252db801130dae516461011a3aeb9bb9;
        #130
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );
        `assert(foo.digest_out_reg,256'hB677077F3EC92273F319D7C6217F79FE8A4A977D93E7A4BDF8EF1B0D6C936D6C);
        $finish;
    end

endmodule
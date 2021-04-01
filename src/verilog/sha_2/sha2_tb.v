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

        dii=256'h0;
        di =256'h0;
        bi =127'h0;

        CLK = 0;
        RST = 0;
        write_en=1;
        #4
        RST=1; //Normal operation


        //Actual result of msg1 Added on to the result at end of stage 63
        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        //Mid-state. clocked ahead 1
        di =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;
        //The bits that change
        bi =127'h252db801130dae516461011a3aeb9bb8;

//Pre:F59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771
//0x252DB801  :F7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776
//0x130DAE51  :10F2957CF7A528B9F59007B57A2E561625BEF710F2C1816DF6F596588185BBAE
//0x6461011A  :678CD63410F2957CF7A528B9F59007B58681540525BEF710F2C1816DF6F59658
//0x3AEB9BB8  :79162787678CD63410F2957CF7A528B95BE8C28B8681540525BEF710F2C1816D
//0x80000000  :878B488079162787678CD63410F2957C52B97D515BE8C28B8681540525BEF710

//0x11111111  :0EF5F83CF7A528B9F59007B57A2E561623C259D0F2C1816DF6F596588185BBAE
//0x22222222  :F9791C7C0EF5F83CF7A528B9F59007B56634503A23C259D0F2C1816DF6F59658
//0x33333333  :F55A38ECF9791C7C0EF5F83CF7A528B9B12C89336634503A23C259D0F2C1816D
//0x80000000  :DE4072E2F55A38ECF9791C7C0EF5F83C4599CBE0B12C89336634503A23C259D0

//0x44444444  :42292B6FF7A528B9F59007B57A2E561656F58D03F2C1816DF6F596588185BBAE
//0x55555555  :7E543BB042292B6FF7A528B9F59007B5D1837F6F56F58D03F2C1816DF6F59658
//0x66666666  :55F4594D7E543BB042292B6FF7A528B94266F795D1837F6F56F58D03F2C1816D
//0x80000000  :3A6CA88355F4594D7E543BB042292B6F8D2B09294266F795D1837F6F56F58D03

//0x77777777  :755C5EA2F7A528B9F59007B57A2E56168A28C036F2C1816DF6F596588185BBAE
//0x88888888  :8E11171E755C5EA2F7A528B9F59007B5F96D29E48A28C036F2C1816DF6F59658
//0x99999999  :751D65728E11171E755C5EA2F7A528B9146BFEF6F96D29E48A28C036F2C1816D
//0x80000000  :B24C55CF751D65728E11171E755C5EA27192EEF3146BFEF6F96D29E48A28C036


        //Clk 0
        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );

        #2
        //CLK 1
        bi =127'h252db801111111112222222233333333; //simulate a new input on the next clock

        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        `assert(foo.ins_main_loop_1.digest_out_wire,256'h10F2957CF7A528B9F59007B57A2E561625BEF710F2C1816DF6F596588185BBAE);


        #2
        //CLK 2
        bi =127'h252db801444444445555555566666666; //simulate a new input on the next clock

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        $display("MC2: At time %t, value = %h %h %h",$time, foo.ins_main_loop_2.digest_in, foo.ins_main_loop_2.w_i, foo.ins_main_loop_2.digest_out_wire );
        `assert(foo.ins_main_loop_1.digest_out_wire,256'h0EF5F83CF7A528B9F59007B57A2E561623C259D0F2C1816DF6F596588185BBAE);
        `assert(foo.ins_main_loop_2.digest_out_wire,256'h678CD63410F2957CF7A528B9F59007B58681540525BEF710F2C1816DF6F59658);


        #2
        //CLK 3
        bi =127'h252db801777777778888888899999999; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        $display("MC2: At time %t, value = %h %h %h",$time, foo.ins_main_loop_2.digest_in, foo.ins_main_loop_2.w_i, foo.ins_main_loop_2.digest_out_wire );
        $display("MC3: At time %t, value = %h %h %h",$time, foo.ins_main_loop_3.digest_in, foo.ins_main_loop_3.w_i, foo.ins_main_loop_3.digest_out_wire );
        `assert(foo.ins_main_loop_1.digest_out_wire,256'h42292B6FF7A528B9F59007B57A2E561656F58D03F2C1816DF6F596588185BBAE);
        `assert(foo.ins_main_loop_2.digest_out_wire,256'hF9791C7C0EF5F83CF7A528B9F59007B56634503A23C259D0F2C1816DF6F59658);
        `assert(foo.ins_main_loop_3.digest_out_wire,256'h79162787678CD63410F2957CF7A528B95BE8C28B8681540525BEF710F2C1816D);

        #2
        //CLK 4
        bi =127'h252db801AAAAAAAABBBBBBBBCCCCCCCC; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );
        `assert(foo.ins_main_loop_1.digest_out_wire,256'h755C5EA2F7A528B9F59007B57A2E56168A28C036F2C1816DF6F596588185BBAE);
        `assert(foo.ins_main_loop_2.digest_out_wire,256'h7E543BB042292B6FF7A528B9F59007B5D1837F6F56F58D03F2C1816DF6F59658);
        `assert(foo.ins_main_loop_3.digest_out_wire,256'hF55A38ECF9791C7C0EF5F83CF7A528B9B12C89336634503A23C259D0F2C1816D);
        `assert(foo.ins_main_loop_4.digest_out_wire,256'h878B488079162787678CD63410F2957C52B97D515BE8C28B8681540525BEF710);


        #2
        //CLK 5
        bi =127'h252db801DDDDDDDDEEEEEEEEFFFFFFFF; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W1-4: At time %t, value = %h %h %h %h",$time, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i );

        #2
        bi =127'h252db801202020203030303040404040; //new input just for fun.

        #16
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCo: At time %t, value = %h %h %h",$time, foo.ins_main_loop_11.digest_out_wire, foo.ins_main_loop_12.digest_out_wire, foo.ins_main_loop_13.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #86
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );

        #2
        //CLK 62
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC62: At time %t, value = %h %h %h",$time, foo.ins_main_loop_62.digest_in, foo.ins_main_loop_62.w_i, foo.ins_main_loop_62.digest_out_wire );
        $display("MC63: At time %t, value = %h %h %h",$time, foo.ins_main_loop_63.digest_in, foo.ins_main_loop_63.w_i, foo.ins_main_loop_63.digest_out_wire );

        #2
        //CLK 63
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC62: At time %t, value = %h %h %h",$time, foo.ins_main_loop_62.digest_in, foo.ins_main_loop_62.w_i, foo.ins_main_loop_62.digest_out_wire );
        $display("MC63: At time %t, value = %h %h %h",$time, foo.ins_main_loop_63.digest_in, foo.ins_main_loop_63.w_i, foo.ins_main_loop_63.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );
        `assert(foo.counter_reg,63);
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hE60E116DBB0F2D17486456C9776FD9E6E93412D5250EF7B412FB586039701CF6);
        //`assert(foo.digest_out,256'hE60E116DBB0F2D17486456C9776FD9E6E93412D5250EF7B412FB586039701CF6);

//TODO: valid_out

        #2
        //CLK 64
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC62: At time %t, value = %h %h %h",$time, foo.ins_main_loop_62.digest_in, foo.ins_main_loop_62.w_i, foo.ins_main_loop_62.digest_out_wire );
        $display("MC63: At time %t, value = %h %h %h",$time, foo.ins_main_loop_63.digest_in, foo.ins_main_loop_63.w_i, foo.ins_main_loop_63.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hD69C4CDA187EBD73AE0023363C9B48BC2EDFBEE00F21CEAD82FE11281A3D6E15);
        //`assert(foo.digest_out,256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467);
        `assert(foo.valid_out,0);

        #2
        //CLK 65
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );

        `assert(foo.valid_out,1);
        `assert(foo.digest_out,256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467);
        `assert(foo.ins_main_loop_63.digest_out_wire,256'h5E8383369890424E07F0FAF02B6175AA239F7FD163FD100C7232C9CBD62715C4);

        #2
        //CLK 66
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.digest_intial, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hB5E3E49077511333C7B39F2AEA0A057F9E08F28289FA0B17BF32FA350DFADB62);

//        `assert(foo.digest_out_reg,256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467);
//        `assert(foo.valid_out,1);

        #2
        //CLK 66
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        `assert(foo.digest_out_reg,256'hEBE0C4A39D8793BA31BD4202582D0FB11AB66A8FCEBEC29730AF727CAC1E9340);
        `assert(foo.ins_main_loop_63.digest_out_wire,256'h8058DF464B7A211ACCFEF1F3EA0D8C7A6FFE05D8D84931FEF6BEC4ED600E6C5A);

        #2
        //CLK 67
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.ins_main_loop_63.digest_out_wire,256'h7A6C969545BAFE2614A1C0F55C65274ABF5CBE6C55C4E4D9C7C8FF6C1E46938E);

        #2
        //CLK 68
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hE7727712627E99B35062E363E6D08D02AC2E168F64CE8E07E767F039662CD254);


        $finish;
    end

endmodule
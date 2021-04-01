`define assert(signal, value) if (signal !== value) begin $display("ASSERTION FAILED in %m: signal != value"); $finish; end


module sha3_tb();
    reg CLK;
    reg RST;
    reg write_en;

    reg [255:0] bi;

    wire [255:0] do;
    wire vo;

    always begin
	    #1 CLK = !CLK;
    end


    sha256_3_pipeline foo(.CLK(CLK),
                          .RST(RST),
                          .write_en(write_en),
                          .block_in(bi),
                          .digest_out(do),
                          .valid_out(vo) );

    initial begin
         $monitor("Hello World");


         $dumpfile("test3.vcd");
         $dumpvars(0,sha3_tb);

        //Initialize clock
        CLK = 0;
        RST = 0;
        bi  = 0;
        write_en=1;
        #4
        RST=1;


        //Mid-state. clocked ahead 1

        bi =256'hDB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467;

        //Clk 0
        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );

        #2
        //CLK 1
        //bi =127'h252db801111111112222222233333333; //simulate a new input on the next clock

        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h10F2957CF7A528B9F59007B57A2E561625BEF710F2C1816DF6F596588185BBAE);


        #2
        //CLK 2
        //bi =127'h252db801444444445555555566666666; //simulate a new input on the next clock

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        $display("MC2: At time %t, value = %h %h %h",$time, foo.ins_main_loop_2.digest_in, foo.ins_main_loop_2.w_i, foo.ins_main_loop_2.digest_out_wire );
        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h0EF5F83CF7A528B9F59007B57A2E561623C259D0F2C1816DF6F596588185BBAE);
        //`assert(foo.ins_main_loop_2.digest_out_wire,256'h678CD63410F2957CF7A528B9F59007B58681540525BEF710F2C1816DF6F59658);


        #2
        //CLK 3
        //bi =127'h252db801777777778888888899999999; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        $display("MC2: At time %t, value = %h %h %h",$time, foo.ins_main_loop_2.digest_in, foo.ins_main_loop_2.w_i, foo.ins_main_loop_2.digest_out_wire );
        $display("MC3: At time %t, value = %h %h %h",$time, foo.ins_main_loop_3.digest_in, foo.ins_main_loop_3.w_i, foo.ins_main_loop_3.digest_out_wire );
        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h42292B6FF7A528B9F59007B57A2E561656F58D03F2C1816DF6F596588185BBAE);
        //`assert(foo.ins_main_loop_2.digest_out_wire,256'hF9791C7C0EF5F83CF7A528B9F59007B56634503A23C259D0F2C1816DF6F59658);
        //`assert(foo.ins_main_loop_3.digest_out_wire,256'h79162787678CD63410F2957CF7A528B95BE8C28B8681540525BEF710F2C1816D);

        #2
        //CLK 4
        //bi =127'h252db801AAAAAAAABBBBBBBBCCCCCCCC; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC3: At time %t, value = %h %h %h",$time, foo.ins_main_loop_3.digest_in, foo.ins_main_loop_3.w_i, foo.ins_main_loop_3.digest_out_wire );

        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h755C5EA2F7A528B9F59007B57A2E56168A28C036F2C1816DF6F596588185BBAE);
        //`assert(foo.ins_main_loop_2.digest_out_wire,256'h7E543BB042292B6FF7A528B9F59007B5D1837F6F56F58D03F2C1816DF6F59658);
        //`assert(foo.ins_main_loop_3.digest_out_wire,256'hF55A38ECF9791C7C0EF5F83CF7A528B9B12C89336634503A23C259D0F2C1816D);
        //`assert(foo.ins_main_loop_4.digest_out_wire,256'h878B488079162787678CD63410F2957C52B97D515BE8C28B8681540525BEF710);


        #2
        //CLK 5
        //bi =127'h252db801DDDDDDDDEEEEEEEEFFFFFFFF; //new input just for fun.

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC4: At time %t, value = %h %h %h",$time, foo.ins_main_loop_4.digest_in, foo.ins_main_loop_4.w_i, foo.ins_main_loop_4.digest_out_wire );

        #2
        //CLK 6
        //bi =127'h252db801202020203030303040404040; //new input just for fun.
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC5: At time %t, value = %h %h %h",$time, foo.ins_main_loop_5.digest_in, foo.ins_main_loop_5.w_i, foo.ins_main_loop_5.digest_out_wire );

        #2
        //CLK 7
        //bi =127'h252db801202020203030303040404040; //new input just for fun.
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC6: At time %t, value = %h %h %h",$time, foo.ins_main_loop_6.digest_in, foo.ins_main_loop_6.w_i, foo.ins_main_loop_6.digest_out_wire );

        #2
        //CLK 8
        //bi =127'h252db801202020203030303040404040; //new input just for fun.
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC7: At time %t, value = %h %h %h",$time, foo.ins_main_loop_7.digest_in, foo.ins_main_loop_7.w_i, foo.ins_main_loop_7.digest_out_wire );

        #2
        //CLK 9
        //bi =127'h252db801202020203030303040404040; //new input just for fun.
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC8: At time %t, value = %h %h %h",$time, foo.ins_main_loop_8.digest_in, foo.ins_main_loop_8.w_i, foo.ins_main_loop_8.digest_out_wire );


        #10
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC13: At time %t, value = %h %h %h",$time, foo.ins_main_loop_13.digest_in, foo.ins_main_loop_13.w_i, foo.ins_main_loop_13.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC16: At time %t, value = %h %h %h",$time, foo.ins_main_loop_16.digest_in, foo.ins_main_loop_16.w_i, foo.ins_main_loop_16.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC17: At time %t, value = %h %h %h",$time, foo.ins_main_loop_17.digest_in, foo.ins_main_loop_17.w_i, foo.ins_main_loop_17.digest_out_wire );
        #20
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC27: At time %t, value = %h %h %h",$time, foo.ins_main_loop_27.digest_in, foo.ins_main_loop_27.w_i, foo.ins_main_loop_27.digest_out_wire );
        #20
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC37: At time %t, value = %h %h %h",$time, foo.ins_main_loop_37.digest_in, foo.ins_main_loop_37.w_i, foo.ins_main_loop_37.digest_out_wire );
        #20
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC47: At time %t, value = %h %h %h",$time, foo.ins_main_loop_47.digest_in, foo.ins_main_loop_47.w_i, foo.ins_main_loop_47.digest_out_wire );
        #24
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC59: At time %t, value = %h %h %h",$time, foo.ins_main_loop_59.digest_in, foo.ins_main_loop_59.w_i, foo.ins_main_loop_59.digest_out_wire );
        #2
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC60: At time %t, value = %h %h %h",$time, foo.ins_main_loop_60.digest_in, foo.ins_main_loop_60.w_i, foo.ins_main_loop_60.digest_out_wire );
        #2
        //CLK 62
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
//        $display("MC61: At time %t, value = %h %h %h",$time, foo.ins_main_loop_61.digest_in, foo.ins_main_loop_61.w_i, foo.ins_main_loop_61.digest_out_wire );
        #2
        //CLK 63
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC62: At time %t, value = %h %h %h",$time, foo.ins_main_loop_62.digest_in, foo.ins_main_loop_62.w_i, foo.ins_main_loop_62.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );

        #2
        //CLK 64
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MC63: At time %t, value = %h %h %h",$time, foo.ins_main_loop_63.digest_in, foo.ins_main_loop_63.w_i, foo.ins_main_loop_63.digest_out_wire );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );
        `assert(foo.ins_main_loop_63.digest_out_wire,256'hF280F11B04A01DD1031EC3C372BB40A067BB3152D7B015A0077D2655A41F32E7);
        `assert(foo.valid_out,0);

        #2
        //CLK 65
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.block_in, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );
        `assert(foo.valid_out,0);


        #2
        //CLK 66
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("MCf: At time %t, value = %h %h %h",$time, foo.digest_loop_63, foo.block_in, foo.digest_out_reg );
        $display("status: At time %t, write = %h valid = %h",$time, foo.write_en, foo.valid_out );
        $display("MCo: At time %t, value = %h %h",$time, foo.valid_out, foo.digest_out );
        `assert(foo.valid_out,1);
        `assert(foo.digest_out,256'h5c8ad782c007cc563f8db735180b35dab8c983d172b57e2c2701000000000000);

        #2
        //CLK 66
        $display("CNT At time %t, %d ",$time, foo.counter_reg );

        #2
        //CLK 67
        $display("CNT At time %t, %d ",$time, foo.counter_reg );

        #2
        //CLK 68
        $display("CNT At time %t, %d ",$time, foo.counter_reg );

        $finish;
    end

endmodule
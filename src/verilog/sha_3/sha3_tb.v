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
        bi =256'h1111111122222222333333334444444455555555666666667777777788888888;

        $display("CNT: At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h10F2957CF7A528B9F59007B57A2E561625BEF710F2C1816DF6F596588185BBAE);


        #2
        //CLK 2
        bi =256'h99999999AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF01010101;

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC1: At time %t, value = %h %h %h",$time, foo.ins_main_loop_1.digest_in, foo.ins_main_loop_1.w_i, foo.ins_main_loop_1.digest_out_wire );
        $display("MC2: At time %t, value = %h %h %h",$time, foo.ins_main_loop_2.digest_in, foo.ins_main_loop_2.w_i, foo.ins_main_loop_2.digest_out_wire );
        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h0EF5F83CF7A528B9F59007B57A2E561623C259D0F2C1816DF6F596588185BBAE);
        //`assert(foo.ins_main_loop_2.digest_out_wire,256'h678CD63410F2957CF7A528B9F59007B58681540525BEF710F2C1816DF6F59658);


        #2
        //CLK 3
        bi =256'h1A1A1A1A2A2A2A2A3A3A3A3A4A4A4A4A5A5A5A5A6A6A6A6A7A7A7A7A8A8A8A8A;

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
        bi =256'h1B1B1B1B2B2B2B2B3B3B3B3B4B4B4B4B5B5B5B5B6B6B6B6B7B7B7B7B8B8B8B8B;

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC3: At time %t, value = %h %h %h",$time, foo.ins_main_loop_3.digest_in, foo.ins_main_loop_3.w_i, foo.ins_main_loop_3.digest_out_wire );

        //`assert(foo.ins_main_loop_1.digest_out_wire,256'h755C5EA2F7A528B9F59007B57A2E56168A28C036F2C1816DF6F596588185BBAE);
        //`assert(foo.ins_main_loop_2.digest_out_wire,256'h7E543BB042292B6FF7A528B9F59007B5D1837F6F56F58D03F2C1816DF6F59658);
        //`assert(foo.ins_main_loop_3.digest_out_wire,256'hF55A38ECF9791C7C0EF5F83CF7A528B9B12C89336634503A23C259D0F2C1816D);
        //`assert(foo.ins_main_loop_4.digest_out_wire,256'h878B488079162787678CD63410F2957C52B97D515BE8C28B8681540525BEF710);


        #2
        //CLK 5
        bi =256'h1C1C1C1C2C2C2C2C3C3C3C3C4C4C4C4C5C5C5C5C6C6C6C6C7C7C7C7C8C8C8C8C;

        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC4: At time %t, value = %h %h %h",$time, foo.ins_main_loop_4.digest_in, foo.ins_main_loop_4.w_i, foo.ins_main_loop_4.digest_out_wire );

        #2
        //CLK 6
        bi =256'h1D1D1B1D2D2D2D2D3D3D3D3D4D4D4D4D5D5D5D5D6D6D6D6D7D7D7D7D8D8D8D8D;
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC5: At time %t, value = %h %h %h",$time, foo.ins_main_loop_5.digest_in, foo.ins_main_loop_5.w_i, foo.ins_main_loop_5.digest_out_wire );

        #2
        //CLK 7
        bi =256'h1E1E1E1E2E2E2E2E3E3E3E3E4E4E4E4E5E5E5E5E6E6E6E6E7E7E7E7E8E8E8E8E;
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC6: At time %t, value = %h %h %h",$time, foo.ins_main_loop_6.digest_in, foo.ins_main_loop_6.w_i, foo.ins_main_loop_6.digest_out_wire );

        #2
        //CLK 8
        bi =256'h1F1F1F1F2F2F2F2F3F3F3F3F4F4F4F4F5F5F5F5F6F6F6F6F7F7F7F7F8F8F8F8F;
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        $display("W0-9: At time %t, value = %h %h %h %h %h %h %h %h %h %h",$time, foo.ins_main_loop_0.w_i, foo.ins_main_loop_1.w_i, foo.ins_main_loop_2.w_i, foo.ins_main_loop_3.w_i, foo.ins_main_loop_4.w_i, foo.ins_main_loop_5.w_i, foo.ins_main_loop_6.w_i, foo.ins_main_loop_7.w_i, foo.ins_main_loop_8.w_i, foo.ins_main_loop_9.w_i );
        $display("MC7: At time %t, value = %h %h %h",$time, foo.ins_main_loop_7.digest_in, foo.ins_main_loop_7.w_i, foo.ins_main_loop_7.digest_out_wire );

        #2
        //CLK 9
        //bi =256'h1B1B1B1B2B2B2B2B3B3B3B3B4B4B4B4B5B5B5B5B6B6B6B6B7B7B7B7B8B8B8B8B;
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
        `assert(foo.digest_out,256'h1FB5FEB01B25BB7D54AF7767938152C7610485FCE20CA8C9D83A055ABB4BDF2E);

        #2
        //CLK 67
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.digest_out,256'hF56A912EA719D7337718913FA1F60D699E390C7B0B4664508AD7A19AEC6E209F);

        #2
        //CLK 68
        $display("CNT At time %t, %d ",$time, foo.counter_reg );
        `assert(foo.digest_out,256'h305338ACEF18024CDE324C26CFC970FC8390FDB5AC293A2600D159A2473CC674);

        $finish;
    end

endmodule
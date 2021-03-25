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

            //Midstate for all 0's +FF
            //583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397

        dii=256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
        di =256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
        bi =127'h00000000000000000000000000000011;
            //Result1:
            //68B3BB91DAEDBF4C540E53C6DC5F00ACB8C4805D6ED579AAA866B91D2DA26E4A

        #4


//        dii=256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
//        di =256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
//        bi =127'h00000000000000000000000000000022;
        //result2:
        //36578DF655FA49FED1504A0EAA4BE89E7ADA85F6E38D745C5F1BDFF1829D6ADA

        #126
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do, do, vo);
        #1
        $finish;
    end

endmodule
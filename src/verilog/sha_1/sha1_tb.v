module sha1_tb();
    reg CLK;
    reg RST;
    reg write_en;

    reg [255:0]	di;

    wire [639:0]	bi;
    wire [255:0]	do1;
    wire [255:0]	do2;
    wire vo;

    always begin
	    #1 CLK = !CLK;
    end

//						input	wire	[639:0]	block_in,
//						input	wire	[255:0]	digest_in,
//						output	wire	[255:0]	digest_out_1,
//						output	wire	[255:0]	digest_out_2,
//						output  wire            valid_out



    sha256_1 foo(.CLK(CLK),
                  .RST(RST),
                  .write_en(write_en),
                  .block_in(bi),
                  .digest_in(di),
                  .digest_out_1(do1),
                  .digest_out_2(do2),
                  .valid_out(vo) );

    initial begin
         $monitor("Hello World");
         $dumpfile("test.vcd");
         $dumpvars(0,sha1_tb);

        //Initialize clock
        CLK = 0;
        RST = 0;
        write_en=1;
        #4
        RST=1;

            //Midstate for all 0's +FF
            //583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397

        di=256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;

            //Result1:
            //68B3BB91DAEDBF4C540E53C6DC5F00ACB8C4805D6ED579AAA866B91D2DA26E4A

        #4


//        dii=256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
//        di =256'h583B37603E3276CB065F1DE4360714E305874C8EC03AF63C381792750278F397;
//        bi =127'h00000000000000000000000000000022;
        //result2:
        //36578DF655FA49FED1504A0EAA4BE89E7ADA85F6E38D745C5F1BDFF1829D6ADA

        #126
        $monitor("At time %t, value = %h (%0d) valid %h",$time, do1, do1, vo);
        #1
        $finish;
    end

endmodule
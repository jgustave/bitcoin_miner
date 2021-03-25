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
            //Result1:
            //DB9E1922353D832D0158CFEB6C16048BE029A92DA694B3620D053FD675377467
            //Final (after sha3 5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000)

        #4

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
//testing that it works if we get lucky on very first input.

`define assert(signal, value) if (signal !== value) begin $display("ASSERTION FAILED in %m: signal != value"); $finish; end

module sha_hasher_tb2();
    reg CLK;
    reg RST;
    reg write_en;

    reg [255:0]	dii;
    reg [255:0]	di;
    reg [31:0] mi;
    reg [31:0] ti;
    reg [31:0] tai;
    reg [31:0] ni;

    wire vo;
    wire [31:0] to;
    wire [31:0] no;
    wire [255:0] result_out;


    always begin
	    #1 CLK = !CLK;
    end

    sha_hasher foo( .CLK(CLK),
                    .RST(RST),
                    .write_en,
                    .digest_intial(dii),
                    .digest_in(di),
                    .merkle_in(mi),
                    .time_in(ti),
                    .target_in(tai),
                    .nonce_in(ni),
                    .valid_out(vo),
                    .time_out(to),
                    .nonce_out(no),
                    .result_out(result_out)
                    );


    initial begin
         $display("Hello World");
         $dumpfile("test.vcd");
         $dumpvars(0,sha_hasher_tb2);

        mi = 32'h252db801;
        ti = 32'h130dae51;
        tai = 32'h6461011a;
        ni = 32'h3aeb9bb8;
        //Actual result of msg1 Added on to the result at end of stage 63
        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        //Mid-state. clocked ahead 1
        di =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;
        CLK = 0;
        RST = 0;
        write_en=1;

        #2
        RST=1; //Normal operation
            //$display("D: At time %t, %h %h ",$time, foo.target_in, foo.difficulty );
            `assert(foo.time_counter_reg,32'h130dae51);
            `assert(foo.nonce_counter_reg,32'h3aeb9bb8);
        #300
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
            `assert(result_out,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);
            `assert(foo.result_out_internal,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);
            `assert(foo.time_out,32'h130dae51);
            `assert(foo.nonce_out,32'h3aeb9bb8);
        $display("TESTS PASSED");
        $finish;
    end

endmodule
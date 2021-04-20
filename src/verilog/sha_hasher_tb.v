
`define assert(signal, value) if (signal !== value) begin $display("ASSERTION FAILED in %m: signal != value"); $finish; end

module sha_hasher_tb();
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
         $dumpvars(0,sha_hasher_tb);

        //Initialize clock

        mi = 32'hEEEEEEEE;
        ti = 32'hAAAAAAA1;
        tai = 32'h99999999;
        ni = 32'hFFFFFFF0;

        //Actual result of msg1 Added on to the result at end of stage 63
        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        //Mid-state. clocked ahead 1
        di =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;


        CLK = 0;
        RST = 0;
        write_en=1;
        //$display("D: At time %t, %h %h ",$time, foo.target_in, foo.difficulty );

        #4
        RST=1; //Normal operation
            //$display("D: At time %t, %h %h ",$time, foo.target_in, foo.difficulty );
            `assert(foo.time_counter_reg,32'hAAAAAAA1);
            `assert(foo.nonce_counter_reg,32'hFFFFFFF0);
        #2
            //$display("D: At time %t, %h %h ",$time, foo.target_in, foo.difficulty );
            `assert(foo.time_counter_reg,32'hAAAAAAA1);
        #2
        #2
        #24
        #2
        #2
            `assert(foo.time_counter_reg,32'hAAAAAAA2);
            `assert(foo.nonce_counter_reg,32'h00000001);
            //NOTE: Tested that nonce counter rolls over in to time counter.
        #2
        RST=0;
            //NOTE: Now test with known solutions.
            mi = 32'h252db801;
            ti = 32'h130dae51;
            tai = 32'h6461011a;
            ni = 32'h3aeb9bb0; //3aeb9bb8 is the solution, so we need to search for 8.
            //       130dae51
            //       3aeb9bfb
        #4
            RST=1; //NORMAL operation
            `assert(foo.valid_out,0);
            `assert(foo.nonce_counter_reg,32'h3aeb9bb0);
        #2
            `assert(foo.nonce_counter_reg,32'h3aeb9bb1);
        #126
            `assert(foo.valid_out_2,0); //ODD This isn't what I expect
            `assert(foo.write_enable_3,0);
        #2
            //First clock where SHA2 output is good. this is the hash of the first input
            `assert(foo.valid_out_2,1);
            `assert(foo.digest_out_2,256'hD113D3BB65EAEED1EBA29A6E06640A8CFD2394C1672229D878D8CEACD8C824A2);
            `assert(foo.write_enable_3,1);
        #2
            `assert(foo.valid_out_2,1);
            `assert(foo.valid_out_3,0);
            `assert(foo.write_enable_3,1);
        #128
            `assert(foo.valid_out_3,0);
            `assert(foo.valid_out,0);
        #2
            `assert(foo.valid_out_3,1);
            `assert(foo.result_out_internal,256'h4FC234738E7F3AC09F4432A23EAB1E707578A6310F0EB320515D61001CB18E75);
        #2
            `assert(foo.result_out_internal,256'hCCA2649D234850E0FD84EDB32B06AE3E415E85F5D19A59622B91F8607B948287);
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
        #12
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
            `assert(foo.time_out,32'h0);
            `assert(foo.nonce_out,32'h0);
            `assert(result_out,256'h0);
        #2
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
            `assert(result_out,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);
            `assert(foo.result_out_internal,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);
            `assert(foo.time_out,32'h130dae51);
            `assert(foo.nonce_out,32'h3aeb9bb8);
        #2
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
            `assert(result_out,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);
            `assert(foo.result_out_internal,256'h5C8AD782C007CC563F8DB735180B35DAB8C983D172B57E2C2701000000000000);

            `assert(foo.time_out,32'h130dae51);
            `assert(foo.nonce_out,32'h3aeb9bb8);
        #2
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);
        #2
            //$display("ror: At time %t, %h %h %h %h",$time, foo.valid_out_3, foo.valid_out, foo.result_swap, foo.difficulty_swap );
            //$display("rev: At time %t, %h",$time, foo.reverse_wire);

            //TODO: need to calculate the rollback
            //`assert(foo.time_out,32'h130dae51);
            //`assert(foo.nonce_out,32'h3aeb9bb8);

        $display("TESTS PASSED");
        $finish;
    end

endmodule
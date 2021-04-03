
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
                    .nonce_out(no)
                    );


    initial begin
         $monitor("Hello World shtb");
         $dumpfile("test.vcd");
         $dumpvars(0,sha_hasher_tb);

        //Initialize clock

        dii=256'h0;
        di =256'h0;


        CLK = 0;
        RST = 0;
        write_en=1;
        #4
        RST=1; //Normal operation


        //Actual result of msg1 Added on to the result at end of stage 63
        dii=256'hF59007B57A2E5616B8F47922F4A62AA5F6F596588185BBAEFA09E7763BC75771;
        //Mid-state. clocked ahead 1
        di =256'hF7A528B9F59007B57A2E5616B8F47922F2C1816DF6F596588185BBAEFA09E776;



        #2

        #2

        #2


        $finish;
    end

endmodule
import javax.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.security.Provider;
import java.util.Random;

/**
 * Exploration of SHA-256
 */
public class ShaTest {
    public static void main(String[] args ) {

        foo();
//        //foo(input);
//        int[] input = makeInput1();
//        int[][] allRegisters = new int[64][64];
//        expander1(allRegisters,input);

    }

    private static void csatest() {
        Random rand = new Random();

        csa(0xF0000000,0xFFFFFFFF,0xFFFFFFFE );
        csa(0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF );
        csa(0xFFFFFFFF,0xFFFFFFFE,0xFFFFFFFE );
        csa(0xFFFFFFFE,0xFFFFFFFE,0xFFFFFFFE );

        csa(0x80000000,0x80000000,0x80000000 );
        csa(0x80000000,0x80000000,0x80000001 );
        csa(0x80000000,0x80000001,0x80000001 );
        csa(0x80000000,0x80000000,0xFFFFFFFF );

        while( true ) {

            int a = rand.nextInt();
            int b = rand.nextInt();
            int c = rand.nextInt();

            csa(a,b,c);
        }

    }
    private static int csa(int a, int b, int c){
        int save  = a ^ b ^ c;
        int carry = (a & b) | (a & c) | (b & c);
        carry = carry << 1;

        int result   = save + carry;
        int standard = a + b + c;

        if( result != standard ) {
            System.out.println(result + " " + standard);
            System.out.println(a);
            System.out.println(b);
            System.out.println(c);
            System.exit(-1);
        }
        return( result );
    }


    private static int[] makeInput1() {
        int[] input = new int[16];
        for( int x=0;x<16;x++) {
            input[x] = (int)x+1024;
        }

        //Known constants for padding. (1)
        input[4]=0x80000000;
        for( int x=5;x<15;x++) {
            input[x] =0;
        }
        input[15]=0x00000280;
        return(input);
    }


    private static void foo() {

        String version = "02000000"; //v2
        String hashPrevBlock = "0affed3fc96851d8c74391c2d9333168fe62165eb228bced7e00000000000000";
        String merkleRoot = "4277b65e3bd527f0ceb5298bdb06b4aacbae8a4a808c2c8aa414c20f252db801";
        String merkleRoot_a = "4277b65e3bd527f0ceb5298bdb06b4aacbae8a4a808c2c8aa414c20f";
        String merkleRoot_b = "252db801";
        String time = "130dae51";
        String difficulty = "6461011a";
        String successNonce = "3aeb9bb8"; //3097226042
        String padding = "80000000" + "0000000000" + "0000000000"+ "0000000000" + "0000000000" + "0000000000" + "0000000000"+ "0000000000" + "0000000000" + "00000280";
        String padding2 = "80000000" + "00000000" + "00000000" + "00000000" + "00000000" + "00000000" + "00000000" + "00000100";
        String hashResult = "5c8ad782c007cc563f8db735180b35dab8c983d172b57e2c2701000000000000"; //This is the resulting successfull hash.


        byte[] msg1 = DatatypeConverter.parseHexBinary(version + hashPrevBlock + merkleRoot_a );
        byte[] msg2 = DatatypeConverter.parseHexBinary(merkleRoot_b + time + difficulty + successNonce + padding );


        https://github.com/aseemgautam/bitcoin-sha256

        try {
            ShaHack digest = new ShaHack();
            byte[] out1 = digest.digest(msg1);
            byte[] out2 = digest.digest(msg2);

            String out2AsHex = DatatypeConverter.printHexBinary(out2);
            String msg3Str = out2AsHex + padding2;
            byte[] msg3 = DatatypeConverter.parseHexBinary(msg3Str);

            digest.implReset();
            byte[] out3 = digest.digest(msg3);

            System.out.println("#############################");
            System.out.println( DatatypeConverter.printHexBinary(out1) );
            System.out.println( DatatypeConverter.printHexBinary(out2) );
            System.out.println( DatatypeConverter.printHexBinary(out3) );

            if( !hashResult.equalsIgnoreCase( DatatypeConverter.printHexBinary(out3)) ) {
                throw new RuntimeException("didn't verify");
            }

        }catch(Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Attempt to unroll
     * @param input 16 - 32bit values
     */
    private static void bar(int[] input) {
        //Expand to 64 - 32 bit values
        int[][] allRegisters = new int[64][64];

        expander1(allRegisters, input );

    }

    /**
     * in 64 rounds, expands input of (int[16] to int[64])
     * This function encapsulates all expansion
     * Result of expander will be in the last stage
     */
    private static void expander1(int[][] allRegisters, int[] input) {

        //64-16 stages with 64 ints in each stage
        //[stage][data]


        //first 16 stages are just a copy in. do in 1

        loadInput(input, allRegisters[15]);
//        for( int x=0;x<16;x++) {
//            copyReg(allRegisters,x);
//            allRegisters[x] = allRegisters[1];
//        }

        //loadInput(input, allRegisters[0]);
        //me1(allRegisters[0],allRegisters[1]);

        for( int x=16;x<64;x++) {
            copyReg(allRegisters,x); //set output to be all inputs (which we will then modify)
            int temp = basicMe(allRegisters[x-1],x);

            allRegisters[x][x]=temp;
        }

    }


    private static void copyReg (int[][] allRegisters, int stage) {
        if( stage==0 )
            return;

        for( int x=0;x<64;x++) {
            allRegisters[stage][x] = allRegisters[stage-1][x];
        }
    }

    //Message expander (0)
    ////given a register input, do the transforms and place in the output.
    private static void loadInput( int[] input,int[] outRegister ) {
        //Just wires, no logic.
        for( int x=0;x<input.length;x++) {
            outRegister[x]=input[x];
        }
    }

    private static void me1(int[] inRegister, int[] outRegister){
        outRegister[123]=inRegister[0]+inRegister[1];
    }

    private static int basicMe(int[] inRegister, int offset){
        int a=offset-2;
        int b=offset-7;
        int c=offset-15;
        int d=offset-16;
        System.out.println(a+","+b+","+c+","+d);
        int out = lf_delta1(inRegister[a]) + inRegister[b] + lf_delta0(inRegister[c]) + inRegister[d];
        return( out );
    }


    /**
* logical function ch(x,y,z) as defined in spec:
        * @return (x and y) xor ((complement x) and z)
        * @param x int
        * @param y int
        * @param z int
        */
       private static int lf_ch(int x, int y, int z) {
           return (x & y) ^ ((~x) & z);
       }

       /**
        * logical function maj(x,y,z) as defined in spec:
        * @return (x and y) xor (x and z) xor (y and z)
        * @param x int
        * @param y int
        * @param z int
        */
       private static int lf_maj(int x, int y, int z) {
           return (x & y) ^ (x & z) ^ (y & z);
       }

       /**
        * logical function R(x,s) - right shift
        * @return x right shift for s times
        * @param x int
        * @param s int
        */
       private static int lf_R( int x, int s ) {
           return (x >>> s);
       }

       /**
        * logical function S(x,s) - right rotation
        * @return x circular right shift for s times
        * @param x int
        * @param s int
        */
       private static int lf_S(int x, int s) {
           return (x >>> s) | (x << (32 - s));
       }

             /**
              * logical function sigma0(x) - xor of results of right rotations
              * @return S(x,2) xor S(x,13) xor S(x,22)
              * @param x int
              */
             private static int lf_sigma0(int x) {
                 return lf_S(x, 2) ^ lf_S(x, 13) ^ lf_S(x, 22);
             }

             /**
              * logical function sigma1(x) - xor of results of right rotations
              * @return S(x,6) xor S(x,11) xor S(x,25)
              * @param x int
              */
             private static int lf_sigma1(int x) {
                 return lf_S( x, 6 ) ^ lf_S( x, 11 ) ^ lf_S( x, 25 );
             }

             /**
              * logical function delta0(x) - xor of results of right shifts/rotations
              * @return int
              * @param x int
              */
             private static int lf_delta0(int x) {
                 return lf_S(x, 7) ^ lf_S(x, 18) ^ lf_R(x, 3);
             }

             /**
              * logical function delta1(x) - xor of results of right shifts/rotations
              * @return int
              * @param x int
              */
             private static int lf_delta1(int x) {
                 return lf_S(x, 17) ^ lf_S(x, 19) ^ lf_R(x, 10);
             }
}

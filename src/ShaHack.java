
import javax.xml.bind.DatatypeConverter;
import java.nio.ByteBuffer;
import java.util.Arrays;


/**
 *
 */
public class ShaHack {

       // buffer used by implCompress()
       private final int[] W;

       // state of this object
       private final int[] state;

       private static final int ITERATION = 64;
       // Constants for each round
       private static final int[] ROUND_CONSTS = {
           0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
           0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
           0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
           0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
           0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
           0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
           0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
           0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
           0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
           0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
           0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
           0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
           0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
           0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
           0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
           0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
       };

    public ShaHack() {
       state = new int[8];
       W = new int[64];
       implReset();
   }
   public void implReset() {
       state[0] = 0x6a09e667;
       state[1] = 0xbb67ae85;
       state[2] = 0x3c6ef372;
       state[3] = 0xa54ff53a;
       state[4] = 0x510e527f;
       state[5] = 0x9b05688c;
       state[6] = 0x1f83d9ab;
       state[7] = 0x5be0cd19;

       Arrays.fill(W, 0);
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

    public byte[] digest(byte[] buf) {

        if( buf.length != 64 ) {
            throw new RuntimeException("invalid");
        }
        implCompress(buf);
        byte[] foo = new byte[32];
        ByteBuffer wrapped = ByteBuffer.wrap(foo) ;

        for( int x=0;x<8;x++) {
            wrapped.putInt(x*4,state[x]);
        }

        return( foo );
    }
    /**
    * Process the current block to update the state variable state.
    */
    void implCompress(byte[] buf) {


        for( int x=0;x<16;x++)  {
            ByteBuffer wrapped = ByteBuffer.wrap(buf,x*4,4);
            W[x] = wrapped.getInt();
        }

       // The first 16 ints are from the byte stream, compute the rest of
       // the W[]'s
       for (int t = 16; t < ITERATION; t++) {
           W[t] = lf_delta1(W[t-2]) + W[t-7] + lf_delta0(W[t-15])  + W[t-16];
       }

       int a = state[0];
       int b = state[1];
       int c = state[2];
       int d = state[3];
       int e = state[4];
       int f = state[5];
       int g = state[6];
       int h = state[7];

        System.out.println("Pre:" + dumpFoo(a,b,c,d,e,f,g,h));

       for (int i = 0; i < ITERATION; i++) {

           int T1 = h + lf_sigma1(e) + lf_ch(e,f,g) + ROUND_CONSTS[i] + W[i];
           int T2 = lf_sigma0(a) + lf_maj(a,b,c);

           h = g;
           g = f;
           f = e;
           e = d + T1;
           d = c;
           c = b;
           b = a;
           a = T1 + T2;


           System.out.println(String.format("0x%08X", W[i]) + "  :" + dumpFoo(a,b,c,d,e,f,g,h));
       }
       state[0] += a;
       state[1] += b;
       state[2] += c;
       state[3] += d;
       state[4] += e;
       state[5] += f;
       state[6] += g;
       state[7] += h;
    }

    public void setState (byte[] midState) {
        for( int x=0;x<8;x++)  {
            ByteBuffer wrapped = ByteBuffer.wrap(midState);
            state[x] = wrapped.getInt(x*4);
        }
    }
    public void dump() {

        String result = "";
        for (int i : W) {
            result += (i + " ");
        }
        System.out.println(result);
        result = "";
        for (int i : state) {
            result += (i + " ");
        }
        System.out.println(result);
    }
    public static String dumpFoo(int a, int b, int c, int d, int e, int f, int g, int h) {
        byte[] debugBuf = new byte[32];
        ByteBuffer wrapped = ByteBuffer.wrap(debugBuf);
        wrapped.putInt(0,a);
        wrapped.putInt(4,b);
        wrapped.putInt(8,c);
        wrapped.putInt(12,d);
        wrapped.putInt(16,e);
        wrapped.putInt(20,f);
        wrapped.putInt(24,g);
        wrapped.putInt(28,h);
        String hexdump = DatatypeConverter.printHexBinary(debugBuf) ;
        return( hexdump );
    }
}

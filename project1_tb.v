module adler32_tb;

  reg rst_n, clk, size_valid, data_start;
  reg [31:0] size;
  reg [ 7:0] data;
  
  wire checksum_valid;
  wire [31:0] checksum;

  adler32 DUT (
    rst_n.rst_n, clk.clock,
    size_valid.size_valid,
    size.size,
    data_start.data_start,
    data.data,
    checksum_valid.checksum_valid,
    checksum.checksum
  );

  always #5 clk = ~clk;

  initial
  begin

    $monitor( $time, ":  checksum presently %08h", checksum );

    rst_n = 0;
    clk   = 0;
    size  = 5;
    data  = 72;
    size_valid = 0;
    data_start = 0;

    #20
    rst_n = 1;

    #10
    size_valid = 1;

    #10
    size_valid = 0;

    #50
    data_start = 1;

    #10
    data_start = 0;

    #10 data = 101;
    #10 data = 108;
    #10 data = 108;
    #10 data = 111;

    #50 $stop;
  end

endmodule
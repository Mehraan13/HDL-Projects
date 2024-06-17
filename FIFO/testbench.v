module FIFO_tb;

  // Parameters
  parameter DEPTH = 16;
  parameter DATA_WIDTH = 8;
  parameter PTR_SIZE = 5;
  
  // Testbench signals
  reg clk;
  reg reset;
  reg write_en;
  reg read_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire empty;
  wire full;
  
  // Instantiate the FIFO module
  FIFO #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH),
    .PTR_SIZE(PTR_SIZE)
  ) uut(
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period (100MHz)
  end

  // Stimulus
  initial begin
    // Initialize signals
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;
    
    // Apply reset
    #10 reset = 0;

    // Write to the FIFO until full
    write_en = 1;
    for (int i = 0; i < DEPTH; i = i + 1) begin
      data_in = i;
      #10;
    end
    
    // Attempt to write when full
    data_in = 255;
    #10;
    write_en = 0;

    // Read from the FIFO until empty
    read_en = 1;
    #10;
    for (int i = 0; i < DEPTH; i = i + 1) begin
      #10;
    end
    
    // Attempt to read when empty
    read_en = 0;
    #10;

    // Re-initialize signals
    reset = 1;
    #10;
    reset = 0;

    // Interleaved read and write
    for (int i = 0; i < 10; i = i + 1) begin
      data_in = i;
      write_en = 1;
      read_en = 1;
      #10;
    end

    // Finish the simulation
    $stop;
  end

  // Monitor for observing the values
  initial begin
    $monitor("Time: %t, clk: %b, reset: %b, write_en: %b, read_en: %b, data_in: %h, data_out: %h, empty: %b, full: %b", 
              $time, clk, reset, write_en, read_en, data_in, data_out, empty, full);
  end

endmodule

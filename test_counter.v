module tb_counter;

	// Inputs
	reg clk;
	reg reset;
  reg increment;
  reg decrement;
  	

	// Outputs
	wire [3:0] count;

	// Instantiate the unit to be tested
	FourBitCounter counter_inst (
    // tie the input and output
		.clk(clk), 
		.reset(reset),
    .increment(increment),
    .decrement(decrement),
		.count(count)
	);
  
  // clock generation
  initial
  begin
    clk = 0;
    forever
      #5 clk = ~clk;
  end
  
  //main simulation
  

	initial 
    begin
		increment = 0;
      	decrement = 0;
      	reset = 0;
      @(posedge clk)
      	reset <= #1 1;
      @(posedge clk)
      	reset <= #1 0;
      @(posedge clk);
      	#1 increment = 1;
      repeat(2) @(posedge clk);
      	#1 increment = 0;
      	#1 decrement = 1;
      @(posedge clk);
      	#1 decrement = 0;
      repeat(20) @(posedge clk);
      $stop;
    end
   
	initial 
  begin
		$monitor("%d %d %d %d\n", count[3], count[2], count[1], count[0]);
	end
	
endmodule

// Code your design here
module FIFO(
  input wire clk,
  input wire reset,
  input wire write_en,
  input wire read_en,
  input wire [DATA_WIDTH-1:0] data_in,
  input wire [DATA_WIDTH-1:0] data_out,
  output wire empty,
  output wire full
);
  
  parameter DEPTH = 16;
  parameter DATA_WIDTH = 8;
  parameter PTR_SIZE = 5;
  
  reg [DATA_WIDTH-1:0] memory [0:DEPTH - 1];
  reg [PTR_SIZE-1:0] wr_ptr;
  reg [PTR_SIZE-1:0] rd_ptr;
  reg empty_reg;
  reg full_reg;
  //write process
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        wr_ptr <= 0;
      else if (write_en && !full_reg)
        wr_ptr <= wr_ptr + 1;
    end
	
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        empty_reg <= 1;
      else if (write_en && !full_reg && (wr_ptr != rd_ptr))
        empty_reg <= 0;
      else if (read_en && (wr_ptr == rd_ptr +1))
        empty_reg <= 1;
    end
       
      always @(posedge clk or posedge reset)
        begin
          if(reset)
            full_reg <= 0;
          else if(write_en && (wr_ptr == rd_ptr))
            full_reg <=1;
          else if (read_en && !empty_reg)
            full_reg <= 0;
        end
//read process
      always @(posedge clk or posedge reset)
        begin
          if(reset)
            rd_ptr <= 0;
          else if (read_en && !empty_reg)
            rd_ptr <= rd_ptr + 1;
        end
//data storage
      always @(posedge clk or posedge reset) begin
  if (reset) begin
    integer i;
    for (i = 0; i < DEPTH; i = i + 1) begin
      memory[i] <= {DATA_WIDTH{1'b0}}; // Initialize each element to zero
    end
  end else if (write_en && !full_reg) begin
    memory[wr_ptr] <= data_in; // Write data to the memory location
  end
end

  
//data retrieval
      assign data_out = (empty_reg)? 'hx:memory[rd_ptr];

      //status outputs
      assign empty = empty_reg;
      assign full = full_reg;
      
      endmodule
      
  
   

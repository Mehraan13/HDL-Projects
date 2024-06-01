
////////////////////////////////////////////////
//
// By:    Mehraan
// Module Name:    FourBitCounter 
//////////////////////////////////////////////

//create the module and initialize input and output variables
module FourBitCounter(
	 input clk,
	 input reset,
  	 input increment,
	 input decrement,
	 output reg [3:0] count
	 );

// declare variable to be used in the logic
  reg enable;
  reg [3:0] mux_out;

// model the OR for enable
  always @(*)
  enable = increment | decrement;

always @(*)
  begin
    case(increment)
      1'b0: mux_out = count - 1;
      1'b1: mux_out = count + 1;
    endcase
  end

// model the register to store the count
always @ (posedge clk)

begin
if (reset == 1'b1)
	count <= #1 4'b0000;
  else if(enable == 1'b1)
	count <= #1 mux_out;
end
endmodule

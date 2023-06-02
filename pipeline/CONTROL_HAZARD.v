`include "const.v"

// Instantiate in EX
module CONTROL_HAZARD (
  input  wire Branch,    // from ID_EX
  input  wire ALU_zero,  // from EX
  output wire IF_flush,  // output to IF/ID
  output wire ID_flush   // output to ID/EX
);

  assign IF_flush = Branch && ALU_zero;
  assign ID_flush = Branch && ALU_zero;

endmodule

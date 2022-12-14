`ifndef INTERFACES_SV
`define INTERFACES_SV

interface in_io (input clk);    // input interface;
  
  	logic [1:0] myMode;
    logic chip_en_lifo;
    logic chip_en_fifo;
    logic chip_en_buffer;
  	logic [7:0] din;
    logic push;
    logic pop;
    logic reset;
  
endinterface

interface out_io;   // output interface;
  
    logic empty;
    logic full;
    logic [7:0] dout;
  
endinterface

`endif

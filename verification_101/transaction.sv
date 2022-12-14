`ifndef TRANSACTION_SV
`define TRANSACTION_SV

// =============================================
// The transaction, the object randomized by the
// generator, sent to the driver, monitored by
// the monitor, and finally sent to the
// scoreboard to actually do all the checks
// =============================================

class reg_item;

    rand bit [7:0] din;
    rand bit [1:0] myMode;
    rand bit chip_en_lifo;
    rand bit chip_en_fifo;
    rand bit chip_en_buffer;
    rand bit push;
    rand bit pop;
  	rand bit reset;

    bit [7:0] dout;
    bit empty;
    bit full;
  
  	string tag;
  
    typedef enum {LIFO, FIFO, BUFFER, OTHER} mode;
    mode mod;

  function void print(string tag = "");
    	mod = mode'(myMode);
    	this.tag = tag;
    $display ("%0t [%s] din = %0d, myMode = %0s, chip_en(lifo/fifo/buffer) = %0b%0b%0b, push/pop = %0b%0b, dout = %0d, empty = %0b, full = %0b, reset = %0b", $time, tag, din, mod.name, chip_en_lifo, chip_en_fifo, chip_en_buffer, push, pop, dout, empty, full, reset);

    endfunction

endclass

`endif

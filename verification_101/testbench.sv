`include "interfaces.sv"
`include "test.sv"

module tb_RTL;

    reg clk;
  
    in_io in_if (clk);
  	out_io out_if ();

  RTL DUT 	( .clk(in_if.clk),
              .myMode(in_if.myMode),
              .chip_en_lifo(in_if.chip_en_lifo),
              .chip_en_fifo(in_if.chip_en_fifo),
              .chip_en_buffer(in_if.chip_en_buffer),
              .din(in_if.din),
              .push(in_if.push),
              .pop(in_if.pop),
              .reset(in_if.reset),
              .empty(out_if.empty),
              .full(out_if.full),
              .dout(out_if.dout) );
  
   		test t0;
  
  	initial begin
      
      clk = 0;
      forever #5 clk = ~clk;
      
    end

    initial begin

      t0 = new();
      t0.env.in_if = in_if;
      t0.env.out_if = out_if;
      
      t0.run();
      
      #300 $finish;

    end

    initial begin

      $dumpvars (0, tb_RTL);
      $dumpfile ("dump.vcd");

    end

endmodule


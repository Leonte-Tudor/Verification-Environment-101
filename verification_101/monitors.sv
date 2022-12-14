`ifndef MONITORS_SV
`define MONITORS_SV

`include "interfaces.sv"
`include "transaction.sv"

// =========================================================
// This monitor handles both the input and the output at our
// interfaces, and puts the monitored transactions in the
// scoreboard's mailbox.
// =========================================================

class monitor;
    virtual in_io in_if;        // virtual interfaces are just
    virtual out_io out_if;      // pointers to the actual interfaces;
    mailbox scb_mbx;            // mailbox for sending to the scoreboard;
  
  	event monitor_done;
    event drv_done;


    task run();
      $display ("%0t: Monitor daemon starting ...\n", $time);
	fork
      forever @(posedge in_if.clk) begin
        
                if(!(in_if.chip_en_lifo || in_if.chip_en_fifo || in_if.chip_en_buffer) || in_if.myMode == 3 ||(in_if.chip_en_fifo && in_if.myMode != 1) || (in_if.chip_en_lifo && in_if.myMode) || (in_if.chip_en_buffer && in_if.myMode != 2) || (in_if.push && in_if.pop)) begin
                    reg_item item = new();
                	item.din = in_if.din;
                	item.myMode = in_if.myMode;
                  	item.chip_en_lifo = in_if.chip_en_lifo;
                  	item.chip_en_fifo = in_if.chip_en_fifo;
                	item.chip_en_buffer = in_if.chip_en_buffer;
                	item.push = in_if.push;
                	item.pop = in_if.pop;
            		item.reset = in_if.reset;
                	item.dout = out_if.dout;
                	item.empty = out_if.empty;
                	item.full = out_if.full;
            		item.print("error_monitor");

            	scb_mbx.put(item); ->monitor_done;
           		//@ (drv_done);
          end
        else begin
          
          	if (in_if.chip_en_buffer && in_if.myMode == 2) begin
                	reg_item item = new();
            		#1		//hex
                	item.din = in_if.din;
                	item.myMode = in_if.myMode;
              		item.chip_en_lifo = in_if.chip_en_lifo;
                	item.chip_en_fifo = in_if.chip_en_fifo;
                	item.chip_en_buffer = in_if.chip_en_buffer;
                	item.push = in_if.push;
                	item.pop = in_if.pop;
            		item.reset = in_if.reset;
                	item.dout = out_if.dout;
                	item.empty = out_if.empty;
               		item.full = out_if.full;
                	item.print("buffer_monitor");

            scb_mbx.put(item); ->monitor_done;
            //@ (drv_done);
          end
             if ((in_if.chip_en_fifo && in_if.myMode == 1) || (in_if.chip_en_lifo && !in_if.myMode)) begin
              	if (in_if.push) begin
                 	 reg_item item = new();
                	item.din = in_if.din;
                	item.myMode = in_if.myMode;
                	item.chip_en_lifo = in_if.chip_en_lifo;
                  	item.chip_en_fifo = in_if.chip_en_fifo;
                  	item.chip_en_buffer = in_if.chip_en_buffer;
                	item.push = in_if.push;
                	item.pop = in_if.pop;
                  	item.reset = in_if.reset;
                	item.dout = out_if.dout;
                	item.empty = out_if.empty;
                	item.full = out_if.full;
                	item.print("input_monitor");

                  scb_mbx.put(item); ->monitor_done;
                  //@ (drv_done);
                end
                if(in_if.pop) begin
                    reg_item item = new();
                  	#1		//hex
                	item.din = in_if.din;
                	item.myMode = in_if.myMode;
                  	item.chip_en_lifo = in_if.chip_en_lifo;
                  	item.chip_en_fifo = in_if.chip_en_fifo;
                	item.chip_en_buffer = in_if.chip_en_buffer;
                	item.push = in_if.push;
                	item.pop = in_if.pop;
                  	item.reset = in_if.reset;
                	item.dout = out_if.dout;
                	item.empty = out_if.empty;
                	item.full = out_if.full;
                  	item.print("output_monitor");
                  
                  scb_mbx.put(item); ->monitor_done;
                  //@ (drv_done);
                end
             end
        end
      end
 
    join
    endtask
endclass

`endif

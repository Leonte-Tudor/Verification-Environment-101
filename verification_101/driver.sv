`ifndef DRIVER_SV
`define DRIVER_SV

`include "interfaces.sv"
`include "transaction.sv"

class driver;
  
    virtual in_io in_if;
  
    event drv_done;
  	event monitor_done;
  
    mailbox drv_mbx;

  
    task run();
      	
        $display ("%0t: Driver daemon starting ...", $time);      
      	forever begin 
          @ (posedge in_if.clk) begin
        	reg_item item;
          	//$display ("%0t Driver waiting for item ...", $time);
            drv_mbx.get(item);
            //$display ("%0t [driver] %0d items left to drive", $time, drv_mbx.num);
          
            #9
          	item.print("driver");
            in_if.din <= item.din;
            in_if.myMode <= item.myMode;
            in_if.chip_en_lifo <= item.chip_en_lifo;
            in_if.chip_en_fifo <= item.chip_en_fifo;
            in_if.chip_en_buffer <= item.chip_en_buffer;
            in_if.push <= item.push;
            in_if.pop <= item.pop;
            in_if.reset <= item.reset; ->drv_done;
          	//@(monitor_done);
          end
              
      end

    endtask
endclass

`endif


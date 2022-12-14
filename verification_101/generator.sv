`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "transaction.sv"

// =================================================
// The generator randomizes signals in a transaction
// and puts them in a mailbox for the driver.
// Here we apply constraints to create our scenarios
// =================================================

class generator;

    mailbox drv_mbx;
  	event drv_done;
   	int cmds = 20;

  
    task scenario_1();

      $display ("\n%0t: Generator daemon starting ...\n", $time);
      for (int i = 0; i < cmds; i++) begin
            reg_item item = new();
          	item.randomize() with {	push ^ pop;
  									myMode != 3;
                                	//chip_en_lifo ^ chip_en_fifo ^ chip_en_buffer;
                               		//!(chip_en_lifo && chip_en_fifo && chip_en_buffer);
                                	chip_en_lifo == 1;
                                 	chip_en_fifo == 0;
                                 	chip_en_buffer == 0;
                                	myMode == 0;
                                 	reset == (i < 3) ?  1 : 0; };
          	item.print("generator");
            drv_mbx.put(item);
          //@(drv_done);
        end
      
      $display();

    endtask
  
  
      task scenario_2();

      $display ("\n%0t: Generator daemon starting ...\n", $time);
      for (int i = 0; i < cmds; i++) begin
            reg_item item = new();
        	item.randomize() with {	push ^ pop;
              						push == 1;
  									myMode != 3;
                                	chip_en_lifo == 1;
                                 	chip_en_fifo == 0;
                                 	chip_en_buffer == 0;
                                	myMode == 0;
                                   	reset == (i < 1) ?  1 : 0; };
          	item.print("generator");
            drv_mbx.put(item);
        end
      
      $display();

    endtask
  
  
        task scenario_3();

      $display ("\n%0t: Generator daemon starting ...\n", $time);
         for (int i = 0; i < cmds + 7; i++) begin
            reg_item item = new();
           item.randomize() with {	!(push || pop);
  									myMode != 3;
                                   	reset == (i < 1) ?  1 : 0; };
                
           							if(i <= 8) begin
                                     	item.myMode = 1;
                                     	item.chip_en_lifo = 0;
                                     	item.chip_en_fifo = 1;
                                 		item.chip_en_buffer = 0;
                                      	item.push = item.reset ? 0 : 1;
                                    end else
                                      if(i <= 11) begin
                                     	item.myMode = 2;
                                     	item.chip_en_lifo = 0;
                                     	item.chip_en_fifo = 0;
                                 		item.chip_en_buffer = 1;
                                    end else begin
                                      	item.myMode = 0;
                                     	item.chip_en_lifo = 1;
                                     	item.chip_en_fifo = 0;
                                 		item.chip_en_buffer = 0;
                                        item.push = 0;
                                      	item.pop = 1;
                                    end
        
          	item.print("generator");
            drv_mbx.put(item);
        end
      
      $display();

    endtask
  
        task scenario_4();

      $display ("\n%0t: Generator daemon starting ...\n", $time);
      for (int i = 0; i < cmds; i++) begin
            reg_item item = new();
        	item.randomize() with {	push ^ pop;
                                   	push == (i < 4) ?  1 : 0;
  									myMode != 3;
                                	chip_en_lifo == 0;
                                 	chip_en_fifo == 1;
                                 	chip_en_buffer == 0;
                                	myMode == 1;
                                   	reset == (i < 3) ?  1 : 0; };
          	item.print("generator");
            drv_mbx.put(item);
        end
      
      $display();

    endtask
  
    
        task scenario_5();

      $display ("\n%0t: Generator daemon starting ...\n", $time);
      for (int i = 0; i < cmds; i++) begin
            reg_item item = new();
        	item.randomize() with {	pop == 1;
                                   	push == (i < 4) ?  1 : 0;
  									myMode != 3;
                                	chip_en_lifo == 1;
                                 	chip_en_fifo == 0;
                                 	chip_en_buffer == 0;
                                	myMode == 0;
                                   	reset == (i < 3) ?  1 : 0; };
          	item.print("generator");
            drv_mbx.put(item);
        end
      
      $display();

    endtask
  
endclass

`endif

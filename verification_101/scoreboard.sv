`include "transaction.sv"

// =====================================================
// The scoreboard receives transactions from the monitor
// and checks them against the specification.
// This is where the magic happens.
// =====================================================

class scoreboard;

    mailbox scb_mbx;
  
  	event monitor_done;

    reg_item items[$:255]; // queue for checking the memory element;

    task run();
      forever begin
            reg_item item;
            scb_mbx.get(item);  // retrieve the last item in the mailbox;
            //item.print("scoreboard"); // print the item, used for checking
                                        // item integrity, only necessary
                                        // during debugging;
          
          if(item.reset == 1) begin
            
            $display ("%0t [scoreboard] Memory purged", $time);
            
            items.delete();
            
          end else begin

          if(item.myMode == 2 && item.tag == "buffer_monitor") begin

                if(item.din == item.dout)
                  $display ("%0t [scoreboard] PASS! Buffer buffered succesfully! din = %0d, dout = %0d", $time, item.din, item.dout);
                else 
                  $display ("%0t [scoreboard] ERROR! Buffer bufferedn't! din = %0d, dout = %0d", $time, item.din, item.dout);
            end

            else begin
                if(item.push && item.tag == "input_monitor") begin

                    if(item.full)
                        $display ("%0t [scoreboard] Stop pushing! It will overflow!", $time);
                    else begin
                      
                        items.push_back(item);
                        $display ("%0t [scoreboard] Value %0d stored at address 0x%0h", $time, item.din, items.size());
                    end
                end
                if (item.pop && item.tag == "output_monitor") begin
                  if ( !items.size())
                    $display ("%0t [scoreboard] ERROR! Popped value %0d that shouldn't be there!", $time, item.dout);
                  else begin
                    if (item.myMode == 0) begin
                        if (item.empty)
                            $display ("%0t [scoreboard] Attempted pop on empty stack", $time);
                      else begin if (item.dout == items[$].din)
                            $display ("%0t [scoreboard] PASS! Popped value %0d from address 0x%0h", $time, item.dout, items.size());
                            else
                            $display ("%0t [scoreboard] ERROR! Expected value %0d at 0x%0h, got %0d instead", $time, items[$].din, items.size(), item.dout);
                            items.pop_back();
                        end
                    end

                    if (item.myMode == 1) begin
                        if (item.empty)
                            $display ("%0t [scoreboard] Attempted pop on empty queue", $time);
                        else begin if (item.dout == items[0].din)
                          $display ("%0t [scoreboard] PASS! Popped value %0d from address 0x1", $time, item.dout);
                            else
                              $display ("%0t [scoreboard] ERROR! Expected value %0d at 0x1, got %0d instead", $time, items[0].din, item.dout);
                            items.pop_front();
                        	end
                        end
                    end
                end
            end
        end
        $display();
        end
    endtask
endclass






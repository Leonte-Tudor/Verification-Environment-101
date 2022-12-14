`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

`include "interfaces.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitors.sv"
`include "scoreboard.sv"

// ===========================================
// The environment encapsulates the monitor,
// driver, and the scoreboard.
// Here we call their constructors and run
// their respective tasks on multiple threads.
// ===========================================

class environment;

    // declarations:
    generator tx_gen;
  	driver drv;
    monitor monitord;
  	scoreboard scb;
  
  	// post office:
    mailbox drv_mbx;
    mailbox scb_mbx;
  
  	event drv_done;
  	event monitor_done;

  	// pointers to interfaces:
    virtual in_io in_if;
    virtual out_io out_if;
  
    // function to construct all of them
    // when we construct the environment;
    function new();
           
    	tx_gen = new();
      	drv = new();
        monitord = new();
      	scb = new(); 

      
      	drv_mbx = new();
      	scb_mbx = new();
      
    	drv.drv_mbx = drv_mbx;
    	tx_gen.drv_mbx = drv_mbx;
    	monitord.scb_mbx = scb_mbx;
    	scb.scb_mbx = scb_mbx;
      
      	drv.drv_done = drv_done;
	    tx_gen.drv_done = drv_done;
      	monitord.drv_done = drv_done;
      	monitord.monitor_done = monitor_done;
        drv.monitor_done = monitor_done;
        scb.monitor_done = monitor_done;

      
    endfunction

    // hooking up the monitor and the
    // scoreboard to the interfaces
    // and the mailbox respectively;
    virtual task run();
      
	drv.in_if = in_if;
    monitord.in_if = in_if;
    monitord.out_if = out_if;
    
      
        // running each task on
        // a separate thread
    	fork 
          
          tx_gen.scenario_5();
          drv.run();
          monitord.run();
          scb.run();

        join_any

    endtask
    
endclass

`endif

`include "environment.sv"

class test;

    environment env;

    function new();
        env = new();
    endfunction

    task run();
      	fork
        	env.run();
        join_none
    endtask

endclass


    

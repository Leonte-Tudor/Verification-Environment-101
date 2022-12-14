`timescale 1ns/1ps
module RTL #(parameter MEM_SIZE = 255)
  (input [1:0] myMode, input chip_en_lifo, input chip_en_fifo, input chip_en_buffer, input [7:0] din, input clk, input push, input pop, input reset, output reg empty, output reg full, output reg [7:0] dout);	
  
  reg [7:0] index, i;//integer
  
  reg [7:0] maxMem = 15;
  reg [3:0] currentDim = 0;
  reg [7:0] memory[MEM_SIZE:0];//[8][MEM_SIZE]
  
  localparam LIFO = 0;
  localparam FIFO = 1;
  localparam BUFFER = 2;
  
  reg [1:0] mode = 0;
  
  always @(myMode) begin
    mode = myMode;
  end
  
  always @(posedge reset) begin
    dout <= 0;
    if(dout == 0) begin
      
    end
    currentDim <= 0;
    for(index = 0; index < maxMem; index = index + 1) begin
      memory[index] <= 0;
    end
    empty <= 0;
    full <= 0;
  end
  
  
  always @(posedge clk) begin
//     $display("MEM DOWN");
//       for(i = 0; i < maxMem; i = i + 1) begin
//         $display((i + 1), " ", memory[i]);
//       end
    if(chip_en_buffer == 1 && mode == BUFFER) begin
      dout <= din;
    end
    else begin
      if(push) begin// PUSH
        if(currentDim < maxMem) begin
          full <= 0;
          empty <= 0;
          if(chip_en_lifo == 1 && mode == LIFO) begin//st
            	memory[currentDim] <= din;   
          end
          else if(chip_en_fifo == 1 && mode == FIFO) begin//c
            	memory[currentDim] <= din;
          end
          currentDim = currentDim + 1;
        end
        else begin//full
          full <= 1;  
        end
      end
      else if(pop) begin// POP
        if(currentDim > 0) begin
          full <= 0;
		  empty <= 0;
          if(chip_en_lifo & mode == LIFO) begin//st
            dout <= memory[currentDim - 1];
            memory[currentDim - 1] <= 0;
            currentDim = currentDim - 1;
          end

          else if(chip_en_fifo & mode == FIFO) begin//c
            dout <= memory[0];
            for(index = 0; index < maxMem - 1; index = index + 1) begin
              memory[index] <= memory[index + 1];
            end
            currentDim = currentDim - 1;
          end
        end
        else begin//empty
          empty <= 1;
        end
      end
    end
  end
  
endmodule


//RAM
module ram(clk, addr, rdata, wdata, we);

    input clk, we;
    input[7:0] addr;
    output reg[15:0] rdata;
    input[15:0] wdata;

    reg[15:0] memory[0:255]; // 256 rows 16 bit word ram 
  
    always @(negedge clk) begin
        if (we) begin
            memory[addr] <= wdata;
          $display("%d,%d",addr,wdata);
        end
    	rdata <= memory[addr];
    end
endmodule

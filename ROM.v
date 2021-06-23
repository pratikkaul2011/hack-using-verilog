//ROM
module rom(clk, addr, data);

    input[7:0] addr;
    input clk;
    output reg[15:0] data;

  	reg[15:0] memory[0:17]; // 18 rows 16 bit word.
  
    initial
        begin
          $readmemb("RomInstruction.txt",memory); // so that the assymbely compiler can read the memory
        end

    always @(negedge clk) begin
            data = memory[addr];
    end
endmodule

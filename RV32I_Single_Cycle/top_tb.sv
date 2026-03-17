module top_tb();

logic clk; 
logic [31:0] result;

// instantiate DUT
top top_ins (.clk(clk), .result(result));


// clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // period = 10
end


// load instructions
initial begin
    $readmemh("instruction_mem.dat", top_ins.ism.mem);
    $readmemh("register_mem.dat", top_ins.rg_file.registers);
    top_ins.pc = 0;

end


// monitoring
initial begin
    $monitor("Time = %0t | PC = %0d | Result = %0d", 
              $time, top_ins.pc, result);
end


// simulation control
initial begin
    #100;   // run enough cycles
    $stop;
end

endmodule
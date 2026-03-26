module instruction_mem_tb();

logic [31:0]PC;
logic [31:0]inst;


instruction_mem ins_mem(PC, inst);
initial begin
    $readmemh("instruction_mem.dat", ins_mem.mem);

end
initial begin
    PC = 0;
    #5;
    repeat(50)begin
        PC += 4;
        #4;
    end
    $stop;
end

initial begin
    $monitor("PC = %0d -- instruction: %h", PC, inst);
end


endmodule
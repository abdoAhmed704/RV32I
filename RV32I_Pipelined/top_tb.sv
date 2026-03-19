module top_tb();

logic clk, reset_n; 
logic [31:0] result;

// instantiate DUT
top_pipeline top_ins (.clk(clk), .rst_n(reset_n), .result(result));


// clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // period = 10
end


// load instructions
initial begin
    $readmemh("instruction_mem.dat", top_ins.dec.imem.mem);
    $readmemh("register_mem.dat", top_ins.decode_keda_keda.regfile.registers);
    $readmemh("data_mem.dat", top_ins.w.dmem.memory);
    reset_n = 0;
    @(negedge clk);
    @(negedge clk);
    reset_n = 1;
    @(negedge clk);
    repeat(6)begin
        @(negedge clk);
    end
    $stop;
end

always @(posedge clk) begin
    $display("\n================ Cycle @ %0t ================", $time);

    // ================= FETCH =================
    $display("[FETCH]");
    $display("PCF        = %h", top_ins.PCF);
    $display("PC+4F      = %h", top_ins.PCPlus4F);
    $display("PCSrcE     = %b", top_ins.PCSrcE);

    // ================= DECODE =================
    $display("\n[DECODE]");
    $display("InstrD     = %h", top_ins.instrD);
    $display("PCD        = %h", top_ins.PCD);
    $display("PC+4D      = %h", top_ins.PCPlus4D);

    // ================= EXECUTE =================
    $display("\n[EXECUTE]");
    $display("PCE        = %h", top_ins.PCE);
    $display("PC+4E      = %h", top_ins.PCPlus4E);
    $display("RD1E       = %h", top_ins.RD1E);
    $display("RD2E       = %h", top_ins.RD2E);
    $display("ImmExtE    = %h", top_ins.ImmExtE);
    $display("RdE        = %0d", top_ins.RdE);

    $display("ALUControl = %b", top_ins.ALUControlE);
    $display("ALUSrc     = %b", top_ins.ALUSrcE);
    $display("Branch     = %b", top_ins.BranchE);
    $display("Jump       = %b", top_ins.jumpE);

    // ================= MEMORY =================
    $display("\n[MEMORY]");
    $display("ALUResultM = %h", top_ins.ALUResultM);
    $display("WriteDataM = %h", top_ins.WriteDataM);
    $display("RdM        = %0d", top_ins.RdM);

    $display("MemWriteM  = %b", top_ins.MemWriteM);
    $display("RegWriteM  = %b", top_ins.RegWriteM);

    // ================= WRITEBACK =================
    $display("\n[WRITEBACK]");
    $display("RdW        = %0d", top_ins.RdW);
    $display("RegWriteW  = %b", top_ins.RegWriteW);

    $display("ALUResultW = %h", top_ins.ALUResultW);
    $display("ReadDataW  = %h", top_ins.ReadDataW);
    $display("PC+4W      = %h", top_ins.PCPlus4W);

    $display("FinalResult= %h", result);

    $display("=============================================\n");
end

// monitoring
initial begin
    $monitor("Time = %0t | PCF = %0d | Result = %0d |||| instrD = %h, ALU_result = %h", $time, top_ins.PCF, result, top_ins.instrD, top_ins.PCSrcE, top_ins.ALUResultM);
end



endmodule
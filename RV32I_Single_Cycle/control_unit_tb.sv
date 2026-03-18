module control_unit_tb();
    // Define Signals
    typedef logic [31:0] instr_t;
    instr_t instr = 32'hFE420AE3; // Example R-type instruction (opcode 0110011)

    logic [6:0] opcode = instr[6:0];
    logic funct7_5 = instr[30];
    logic [2:0] funct3 = instr[14:12];
    logic Zero;
    wire PCSrc;
    wire [1:0] ResultSrc;
    wire [2:0] ALUControl;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire RegWrite;
    wire MemWrite;
    
    // Instantiate the control unit
    control_unit dut (
        .opcode(opcode),
        .funct7_5(funct7_5),
        .funct3(funct3),
        .Zero(Zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite)
    );

    // Test cases
    initial begin
        // initiatlize instruction to Zero
        Zero = 0;
        // Test R-type instruction or
        #10;
        $display("Testing R-type instruction:");
        $display("PCSrc: %b, ResultSrc: %b, ALUControl: %b, ALUSrc: %b, ImmSrc: %b, RegWrite: %b, MemWrite: %b", 
                 PCSrc, ResultSrc, ALUControl, ALUSrc, ImmSrc, RegWrite, MemWrite);
        $stop;
    end
endmodule
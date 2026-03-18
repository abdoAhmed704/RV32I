module memory (
    input clk,
    input [31:0] PCE,
    input [31:0] PCPlus4E,
    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,
    input jumpE,
    input BranchE,
    input [2:0] ALUControlE,
    input ALUSrcE,
    input [1:0] ImmSrcE,
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] ImmExtE,
    input [4:0] RdE,
    output reg PCSrcE,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCTargetE,
    output reg [31:0] PCPlus4M
);
    wire SrcBE;
    wire ZeroE;
    wire WriteDataE;
    assign WriteDataE = RD2E; // Data to be written to memory (used in the memory stage)

    // SrcBE is the second operand for the ALU, which can be either RD2E or ImmExtE based on the ALUSrcE control signal
    assign SrcBE = (!ALUSrcE) ? RD2E: ImmExtE;
    // ALU instantiation
    alu aluE (
        .src_a(RD1E), // Source operand A
        .src_b(SrcBE), // Source operand B (either RD2E or ImmExtE based on ALUSrcE)
        .alu_control(ALUControlE), // ALU control signal
        .Zero(ZeroE), // Zero flag output from ALU
        .result() // ALU result (not used in this stage)
    );

    // instantiage PCTarget unit
    pc_target pctargetE (
        .PC(PCE), // PC + 4 input
        .ImmExt(ImmExtE), // Extended immediate input
        .PCTarget(PCTargetE) // Calculated PC target output
    );

    // PCSrcE is determined by the branch condition (BranchE && ZeroE) or the jump signal (jumpE)
    assign PCSrcE = (BranchE && ZeroE) || jumpE;

    // Pipeline register for the execute stage to memory stage
    always @(posedge clk) begin
        RegWriteM <= RegWriteE; // Pass register write enable signal to memory stage
        ResultSrcM <= ResultSrcE; // Pass ALU result source control signal to memory stage
        MemWriteM <= MemWriteE; // Pass memory write enable signal to memory stage
        ALUResultM <= aluE.result; // Pass ALU result to memory stage
        WriteDataM <= WriteDataE; // Pass data to be written to memory to memory stage
        RdM <= RdE; // Pass destination register address to memory stage
        PCPlus4M <= PCPlus4E; // Pass PC + 4 to memory stage
    end


endmodule
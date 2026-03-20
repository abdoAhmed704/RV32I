module top_pipeline(input clk, input rst_n, output reg [31:0] result);

reg [31:0] pc;




wire [31:0] PCPlus4F;
wire [31:0] PCTargetE;
wire [31:0] PCF;
wire  PCSrcE;

wire [31:0] PCPlus4D;
wire [31:0] PCD;


wire [31:0] instrD;

// Execute

wire [31:0] PCE; 
wire [31:0] PCPlus4E; 
wire RegWriteE; 
wire [1:0] ResultSrcE; 
wire MemWriteE; 
wire jumpE; 
wire BranchE; 
wire [2:0] ALUControlE; 
wire ALUSrcE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] ImmExtE;
wire [4:0] RdE;


// memory:
wire RegWriteM;
wire [1:0] ResultSrcM;
wire MemWriteM;
wire [31:0] ALUResultM;
wire [31:0] WriteDataM;
wire [4:0] RdM;

wire [31:0] PCPlus4M;



// writeback
wire RegWriteW;

wire [4:0] RdW;
wire [1:0] ResultSrcW;
wire [31:0] ALUResultW;
wire [31:0] ReadDataW;
wire [31:0] PCPlus4W;



fetch fet(.clk(clk), .rst_n(rst_n), .PCPlus4F(PCPlus4F), .PCTargetE(PCTargetE), .PCSrcE(PCSrcE), .PCF(PCF));


decode dec(.clk(clk), .PCF(PCF), .instrD(instrD), .PCPlus4D(PCPlus4D), .PCD(PCD), .PCPlus4F(PCPlus4F));



execute decode_keda_keda(.clk(clk), .instrD(instrD), .PCPlus4D(PCPlus4D), .PCD(PCD), .RegWriteW(RegWriteW), .ResultW(result),
         .RdW(RdW), .PCE(PCE), .PCPlus4E(PCPlus4E), .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), .MemWriteE(MemWriteE),
         .jumpE(jumpE), .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE), .RD1E(RD1E), 
         .RD2E(RD2E), .ImmExtE(ImmExtE), .RdE(RdE));


memory excute_kda_kda( .clk(clk), .PCE(PCE), .PCPlus4E(PCPlus4E), .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), 
                        .MemWriteE(MemWriteE), .jumpE(jumpE), .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE), 
                        .RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE), .RdE(RdE), .RegWriteM(RegWriteM), 
                        .ResultSrcM(ResultSrcM), .MemWriteM(MemWriteM), .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .RdM(RdM), .PCTargetE(PCTargetE), .PCPlus4M(PCPlus4M),
                        .ZeroE(ZeroE));



writeBack w(.clk(clk), .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .MemWriteM(MemWriteM), .ALUResultM(ALUResultM), 
            .WriteDataM(WriteDataM), .RdM(RdM), .PCPlus4M(PCPlus4M), .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .RdW(RdW),
            .ALUResultW(ALUResultW), .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W));


    always @(*) begin
        
        case (ResultSrcW)
            2'b00: result = ALUResultW; // ALU result
            2'b01: result = ReadDataW; // Data read from memory
            2'b10: result = PCPlus4W; // PC + 4 (for jump and link instructions)
            default: result = 0; // Default case
        endcase
    end

assign PCSrcE = (BranchE && ZeroE) || jumpE;

endmodule

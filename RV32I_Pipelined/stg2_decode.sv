module decode (
    input clk,
    input [31:0] instrD,
    input [31:0] PCPlus4D,
    input [31:0] PCD,
    input RegWriteW, // Comming from the last stage and input to the reg file
    input [31:0] ResultW, // Comming from the last stage and input to the reg file to be written in the reg file
    input [4:0] RdW, // Comming from the last stage and input to the reg file to be written in the reg file
    output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg jumpE,
    output reg BranchE,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,
    output reg [1:0] ImmSrcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] ImmExtE,
    output reg [4:0] RdE

);

    wire RegWriteD;
    wire [1:0] ResultSrcD;
    wire MemWriteD;
    wire jumpD;
    wire BranchD;
    wire [2:0] ALUControlD;
    wire ALUSrcD;
    wire [1:0] ImmSrcD;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;
    wire [31:0] ImmExtD;
    wire [4:0] RdD;

    assign RdD = instrD[11:7]; // Destination register address from the instruction

    // Register file instantiation
    register_file regfile (
        .clk(clk),
        .w_en(RegWriteW), // Write enable signal from the last stage
        .A1(instrD[19:15]), // Source register 1 address
        .A2(instrD[24:20]), // Source register 2 address
        .A3(RdW]),   // Destination register address
        .WD3(ResultW), // Data to write to the register file
        .RD1(RD1),    // Data read from source register 1
        .RD2(RD2)     // Data read from source register 2
    );

    // instantiate control unit
    control_unit cu (
        .opcode(instrD[6:0]), // Opcode from the instruction
        .funct7_5(instrD[31:25]),  // funct7[5] from the instruction
        .funct3(instrD[14:12]),  // funct3 from the instruction
        .ResultSrc(ResultSrcD), // Control signal for ALU result source
        .ALUControl(ALUControlD), // Control signal for ALU operation
        .ALUSrc(ALUSrcD), // Control signal for ALU RD2 source .. Extended or not
        .ImmSrc(ImmSrcD), // Control signal for immediate value source
        .RegWrite(RegWriteD), // Control signal for register write enable
        .MemWrite(MemWriteD) // Control signal for memory write enable
        .jump(jumpD),
        .Branch(BranchD)
    );

    // Immediate extension unit
    extend immext (
        .instr(instrD), // Instruction input
        .ImmSrc(ImmSrcD), // Control signal for immediate value source
        .ImmExt(ImmExtD) // Extended immediate output
    );

    // Sequential logic to update pipeline registers on the rising edge of the clock
    always @(posedge clk) begin
        PCE <= PCD; // Update the program counter for the execute stage
        PCPlus4E <= PCPlus4D; // Update the PC+4 value for the execute stage
        RegWriteE <= RegWriteD; // Update the register write enable signal for the execute stage
        ResultSrcE <= ResultSrcD; // Update the ALU result source control signal for the execute stage
        MemWriteE <= MemWriteD; // Update the memory write enable signal for the execute stage
        jumpE <= jumpD; // Update the jump control signal for the execute stage
        BranchE <= BranchD; // Update the branch control signal for the execute stage
        ALUControlE <= ALUControlD; // Update the ALU control signal for the execute stage
        ALUSrcE <= ALUSrcD; // Update the ALU source control signal for the execute stage
        ImmSrcE <= ImmSrcD; // Update the immediate source control signal for the execute stage
        RD1E <= RD1; // Update the data read from source register 1 for the execute stage
        RD2E <= RD2; // Update the data read from source register 2 for the execute stage
        ImmExtE <= ImmExtD; // Update the extended immediate value for the execute stage
        RdE <= RdD; // Update the destination register address for the execute stage
    end


endmodule
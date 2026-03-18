module decode (
    input clk,
    input [31:0] PCF,
    output reg [31:0] instrD,
    output reg [31:0] PCPlus4D,
    output reg [31:0] PCD
);
    wire [31:0] instrF;
    wire [31:0] PCPlus4F;

    // fetch instruction from instruction memory
    instruction_memory imem (
        .PC(PCF),
        .instr(instrF)
    );

    // PCPlus4 module
    PCPlus4 pc_plus4 (
        .PC(PCF),
        .PCPlus4(PCPlus4F)
    );

    always @(posedge clk) begin
        instrD <= instrF;
        PCPlus4D <= PCPlus4F;
        PCD <= PCF;
    end

endmodule

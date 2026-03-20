module decode (
    input clk,
    input [31:0] PCF,
    output reg [31:0] instrD,
    output reg [31:0] PCPlus4D,
    output reg [31:0] PCD,
    output [31:0] PCPlus4F
);
    wire [31:0] instrF;

    // fetch instruction from instruction memory
    instruction_mem imem (
        .PC(PCF),
        .inst(instrF)
    );

    // // PCPlus4 module
    // PCPlus4 pc_plus4 (
    //     .PC(PCF),
    //     .PC_Plus_4(PCPlus4F)
    // );
    // assign

    assign PCPlus4F = PCF + 4;
    always @(posedge clk) begin
        instrD <= instrF;
        PCPlus4D <= PCPlus4F;
        PCD <= PCF;
        
    end

endmodule

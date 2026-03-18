module PCTarget (
    input [31:0] PC,
    input [31:0] ImmExt,
    output reg [31:0] PCTarget
);

    always @(*) begin
        PCTarget = PC + ImmExt; // Calculate the target address for branch instructions
    end

endmodule
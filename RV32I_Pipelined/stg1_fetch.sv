module fetch(
    input clk,
    input rst_n,
    input [31:0] PCPlus4F,
    input [31:0] PCTargetE,
    input PCSrcE,
    output reg [31:0] PCF
);

    wire PCFx;
    // Next PC value is either the target address from execute stage or PC + 4 from fetch stage
    assign PCFx = (PCSrcE) ? PCTargetE : PCPlus4F; 

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PCF <= 0; // Reset PC to 0 on reset
        end else begin
            $display("here");
            $display("PCFx = %d", PCFx);
            $display("PCF = %d", PCF);
            PCF <= PCFx; // Update PC with the next value on each clock cycle
            $display("PCFx = %d", PCFx);
            $display("PCF = %d", PCF);
            $display("PCPlus4F = %d", PCPlus4F);
        end
    end

endmodule
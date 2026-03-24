
// module fetch_new(input clk, input rst_n, input [31:0] PCTargetE, input PCSrcE,
//                 output reg [31:0] instrD, output reg [31:0] PCPlus4D,
//                 output reg [31:0] PCD);


//     wire PCFx;
//     reg PCF;
//     // Next PC value is either the target address from execute stage or PC + 4 from fetch stage
//     assign PCFx = (PCSrcE) ? PCTargetE : PCPlus4F; 

//     always@(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             PCF <= 0; // Reset PC to 0 on reset
//         end else begin
//             PCF <= PCFx; // Update PC with the next value on each clock cycle
//         end
//     end

//     wire [31:0] instrF;
// ///////////////////////////////////////////////////////////////////////////////////////////////////
//     // fetch instruction from instruction memory
//     instruction_mem imem (
//         .PC(PCF),
//         .inst(instrF)
//     );

//     always @(posedge clk) begin
//         instrD <= instrF;
//         PCPlus4D <= PCPlus4F;
//         PCD <= PCF;
//         PCPlus4F <= PCF + 4;
//     end



// endmodule
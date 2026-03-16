module control_unit (
    input [6:0] opcode, // 6-bit opcode from instruction
    input [6:0] funct7,  // 7-bit function code for R-type instructions
    input [2:0] funct3,  // 3-bit function code for R-type and I-type instructions
    input Zero, // Zero flag from ALU
    output reg Branch, // Control signal for branch instructions
    output reg PCSrc, // Control signal for PC source
    output reg [1:0]ResultSrc, // Control signal for ALU result source
    output reg [2:0] ALUControl, // Control signal for ALU operation
    output reg ALUSrc, // Control signal for ALU RD2 source .. Extended or not
    output reg [1:0] ImmSrc, // Control signal for immediate value source
    output reg RegWrite, // Control signal for register write enable
    output reg MemWrite, // Control signal for memory write enable
    output reg [1:0] ALUOp, // Control signal for ALU operation type (R-type, I-type, etc.)
    output reg jump // Control signal for jump instructions
);
    always @(*) begin
        // Default values for control signals
        Branch = 0;
        ResultSrc = 2'b00; // Default to ALU result
        ALUSrc = 0; // Default to register source
        ImmSrc = 2'b00; // Default to no immediate
        RegWrite = 0; // Default to no register write
        MemWrite = 0; // Default to no memory write
        ALUOp = 2'b00; // Default to R-type operation
        jump = 0; // Default to no jump

        case (opcode)
            7'b1100011: begin // R-type instructions
                Branch = 0;
                ResultSrc = 2'b00; // Default to ALU result
                ALUControl = 4'b0000; // Default to ADD operation
                ALUSrc = 0; // Default to register source
                ImmSrc = 2'bxx; // Default to no immediate
                RegWrite = 1; // Default to no register write
                MemWrite = 0; // Default to no memory write
                ALUOp = 2'b10; // Default to R-type operation
                jump = 0; // Default to no jump
            end
            7'b1100011: begin // beq instruction
                Branch = 1; // Enable branching for beq instruction
                ResultSrc = 2'bxx; // Default to ALU result
                ALUSrc = 0; // Default to register source
                ImmSrc = 2'b10; // Use B-type immediate for branch address calculation
                RegWrite = 0; // Disable register write for branch instructions
                MemWrite = 0; // Disable memory write for branch instructions
                ALUOp = 2'b01; // Set ALU operation type for branch instructions
                jump = 0; // Disable jump for branch instructions
            end
            7'b0000011: begin // Load instructions ( LW)
                Branch = 0; // Disable branching for load instructions
                ALUSrc = 1; // Use immediate value for address calculation
                ImmSrc = 2'b00; // Use I-type immediate for load instructions
                RegWrite = 1; // Enable register write for load instructions
                MemWrite = 0; // Disable memory write for load instructions
                ALUOp = 2'b00; // Set ALU operation type for load instructions
                ResultSrc = 2'b01; // Use memory data as result for load instructions
                jump = 0; // Disable jump for load instructions
            end
            7'b0100011: begin // Store instructions (SW)
                Branch = 0; // Disable branching for store instructions
                ALUSrc = 1; // Use immediate value for address calculation
                ImmSrc = 2'b01; // Use S-type immediate for store instructions
                RegWrite = 0; // Disable register write for store instructions
                MemWrite = 1; // Enable memory write for store instructions
                ALUOp = 2'b00; // Set ALU operation type for store instructions
                ResultSrc = 2'bxx; // Use ALU result for store instructions
                jump = 0; // Disable jump for store instructions
            end
            7'b1101111: begin // JAL instruction
                Branch = 0; // Disable branching for JAL instruction
                ALUSrc = 1'bx; // Use register source for address calculation
                ImmSrc = 2'b11; // Use J-type immediate for jump address calculation
                RegWrite = 1; // Enable register write for JAL instruction
                MemWrite = 0; // Disable memory write for JAL instruction
                ALUOp = 2'bxx; // Set ALU operation type for JAL instruction
                ResultSrc = 2'b10; // Use memory data as result for JAL instruction
                jump = 1; // Enable jump for JAL instruction
            end
        endcase
        
        case (ALUOp) // ALU Decoder
            2'b00: begin // Load/Store instructions
                ALUControl = 3'b000; // Use ADD operation for address calculation
            end
            2'b01: begin // Branch instructions
                ALUControl = 3'b001; // Use SUB operation for branch comparison
            end
            2'b10: begin // R-type instructions
                case (funct3)
                    3'b000: begin // ADD/SUB
                        if (funct7 == 7'b0000000) begin
                            ALUControl = 3'b000; // ADD operation
                        end else if (funct7 == 7'b0100000) begin
                            ALUControl = 3'b001; // SUB operation
                        end else begin
                            ALUControl = 3'bxxxx; // Invalid funct7 for ADD/SUB
                        end
                    end
                    3'b010: begin
                        ALUControl = 3'b101;
                    end
                    3'b110: begin
                        ALUControl = 3'b011;
                    end
                    3'b111: begin
                        ALUControl = 3'b010;
                    end
                endcase
            end
            default: ALUControl = 3'bxxxx; // Invalid ALUOp code    
        endcase
    end
endmodule
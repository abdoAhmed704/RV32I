`timescale 1ns/1ps

module control_unit_tb;

    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic       Zero;

    logic       Branch;
    logic       PCSrc;
    logic [1:0] ResultSrc;
    logic [2:0] ALUControl;
    logic       ALUSrc;
    logic [1:0] ImmSrc;
    logic       RegWrite;
    logic       MemWrite;
    logic [1:0] ALUOp;
    logic       jump;

    int failures = 0;

    control_unit dut (
        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),
        .Zero(Zero),
        .Branch(Branch),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp),
        .jump(jump)
    );

    function automatic bit match1(input logic a, input logic e);
        if ((e === 1'bx) || (e === 1'bz)) match1 = 1'b1;
        else                               match1 = (a === e);
    endfunction

    function automatic bit match2(input logic [1:0] a, input logic [1:0] e);
        match2 = match1(a[0], e[0]) && match1(a[1], e[1]);
    endfunction

    function automatic bit match3(input logic [2:0] a, input logic [2:0] e);
        match3 = match1(a[0], e[0]) && match1(a[1], e[1]) && match1(a[2], e[2]);
    endfunction

    task automatic check_ctrl(
        input string     name,
        input logic      exp_Branch,
        input logic [1:0]exp_ResultSrc,
        input logic [2:0]exp_ALUControl,
        input logic      exp_ALUSrc,
        input logic [1:0]exp_ImmSrc,
        input logic      exp_RegWrite,
        input logic      exp_MemWrite,
        input logic [1:0]exp_ALUOp,
        input logic      exp_jump
    );
        #1;
        if (!match1(Branch, exp_Branch)) begin
            $error("%s: Branch mismatch. got=%b exp=%b", name, Branch, exp_Branch); failures++;
        end
        if (!match2(ResultSrc, exp_ResultSrc)) begin
            $error("%s: ResultSrc mismatch. got=%b exp=%b", name, ResultSrc, exp_ResultSrc); failures++;
        end
        if (!match3(ALUControl, exp_ALUControl)) begin
            $error("%s: ALUControl mismatch. got=%b exp=%b", name, ALUControl, exp_ALUControl); failures++;
        end
        if (!match1(ALUSrc, exp_ALUSrc)) begin
            $error("%s: ALUSrc mismatch. got=%b exp=%b", name, ALUSrc, exp_ALUSrc); failures++;
        end
        if (!match2(ImmSrc, exp_ImmSrc)) begin
            $error("%s: ImmSrc mismatch. got=%b exp=%b", name, ImmSrc, exp_ImmSrc); failures++;
        end
        if (!match1(RegWrite, exp_RegWrite)) begin
            $error("%s: RegWrite mismatch. got=%b exp=%b", name, RegWrite, exp_RegWrite); failures++;
        end
        if (!match1(MemWrite, exp_MemWrite)) begin
            $error("%s: MemWrite mismatch. got=%b exp=%b", name, MemWrite, exp_MemWrite); failures++;
        end
        if (!match2(ALUOp, exp_ALUOp)) begin
            $error("%s: ALUOp mismatch. got=%b exp=%b", name, ALUOp, exp_ALUOp); failures++;
        end
        if (!match1(jump, exp_jump)) begin
            $error("%s: jump mismatch. got=%b exp=%b", name, jump, exp_jump); failures++;
        end
        // PCSrc is asserted when a branch is taken (Branch & Zero) or on jump
        logic expected_PCSrc;
        expected_PCSrc = (exp_Branch && Zero) || exp_jump;
        if (!match1(PCSrc, expected_PCSrc)) begin
            $error("%s: PCSrc mismatch. got=%b exp=%b (Branch=%b Zero=%b jump=%b)", name, PCSrc, expected_PCSrc, exp_Branch, Zero, exp_jump); failures++;
        end
    endtask

    initial begin
        $display("Starting test_control_unit_tb...");
        // Table-driven tests
        typedef struct {
            string name;
            logic [6:0] opcode;
            logic [6:0] funct7;
            logic [2:0] funct3;
            logic Zero;
            logic exp_Branch;
            logic [1:0] exp_ResultSrc;
            logic [2:0] exp_ALUControl;
            logic exp_ALUSrc;
            logic [1:0] exp_ImmSrc;
            logic exp_RegWrite;
            logic exp_MemWrite;
            logic [1:0] exp_ALUOp;
            logic exp_jump;
        } test_t;

        test_t tests[] = '{
            '{"R-ADD", 7'b0110011, 7'b0000000, 3'b000, 1'b0, 1'b0, 2'b00, 3'b000, 1'b0, 2'b00, 1'b1, 1'b0, 2'b10, 1'b0},
            '{"R-SUB", 7'b0110011, 7'b0100000, 3'b000, 1'b0, 1'b0, 2'b00, 3'b001, 1'b0, 2'b00, 1'b1, 1'b0, 2'b10, 1'b0},
            '{"BEQ",   7'b1100011, 7'b0000000, 3'b000, 1'b1, 1'b1, 2'bxx, 3'b001, 1'b0, 2'b10, 1'b0, 1'b0, 2'b01, 1'b0},
            '{"LW",    7'b0000011, 7'b0000000, 3'b010, 1'b0, 1'b0, 2'b01, 3'b000, 1'b1, 2'b00, 1'b1, 1'b0, 2'b00, 1'b0},
            '{"SW",    7'b0100011, 7'b0000000, 3'b010, 1'b0, 1'b0, 2'bxx, 3'b000, 1'b1, 2'b01, 1'b0, 1'b1, 2'b00, 1'b0},
            '{"JAL",   7'b1101111, 7'b0000000, 3'b000, 1'b0, 1'b0, 2'b10, 3'bxxx, 1'bx, 2'b11, 1'b1, 1'b0, 2'bxx, 1'b1},
            '{"UNKNOWN",7'b1111111,7'b0000000, 3'b000, 1'b0, 1'b0, 2'b00, 3'b000, 1'b0, 2'b00, 1'b0, 1'b0, 2'b00, 1'b0}
        };

        foreach (tests[i]) begin
            opcode = tests[i].opcode;
            funct7 = tests[i].funct7;
            funct3 = tests[i].funct3;
            Zero   = tests[i].Zero;
            check_ctrl(tests[i].name,
                       tests[i].exp_Branch,
                       tests[i].exp_ResultSrc,
                       tests[i].exp_ALUControl,
                       tests[i].exp_ALUSrc,
                       tests[i].exp_ImmSrc,
                       tests[i].exp_RegWrite,
                       tests[i].exp_MemWrite,
                       tests[i].exp_ALUOp,
                       tests[i].exp_jump);
        end

        if (failures == 0) $display("All tests passed.");
        else               $display("Test completed with %0d failure(s).", failures);

        $finish;
    end

endmodule
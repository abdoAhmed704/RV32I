module tb_PCTarget();
    logic [31:0] PC;
    logic [31:0] ImmExt;
    logic [31:0] PCTarget;

    // Instantiate the PCTarget module
    PCTarget dut (
        .PC(PC),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget)
    );
    // Test cases
    initial begin
        // Test case 1: PC = 0, ImmExt = 4
        PC = 32'h00000000;
        ImmExt = 32'h00000004;
        #10; // Wait for the output to stabilize
        $display("Test Case 1: PC = %h, ImmExt = %h, PCTarget = %h", PC, ImmExt, PCTarget); // PCTarget should be 4

        // Test case 2: PC = 0x00000004, ImmExt = -4
        PC = 32'h00000004;
        ImmExt = 32'hFF; // equal in decimal to 
        #10; // Wait for the output to stabilize
        $display("Test Case 2: PC = %h, ImmExt = %h, PCTarget = %h", PC, ImmExt, PCTarget); // PCTarget should be 103

        // Test case 3: PC = 0xFFFFFFFF, ImmExt = 4
        PC = 32'hFFFFFFFF;
        ImmExt = 32'h00000004;
        #10; // Wait for the output to stabilize
        $display("Test Case 3: PC = %h, ImmExt = %h, PCTarget = %h", PC, ImmExt, PCTarget); // PCTarget should be 3 (wrap around)

        $stop; // End simulation
    end

endmodule
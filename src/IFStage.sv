module IFStage (
    clk,
    rst_b,
    is_hazard_detected,
    is_cache_missed,
    new_PC,
    PC
);
    input clk, rst_b, is_hazard_detected, is_cache_missed;
    // input is_hazard_detected, is_cache_missed;
    input [31:0] new_PC;
    output reg [31:0] PC;

    initial begin
        PC = 32'b0; // START OF PROGRAM
    end

    // always @(*) begin
    //     // else if (is_hazard_detected || is_cache_missed) // from cache miss or data, control dependency
    //     //     PC <= PC;
    //     if (is_hazard_detected)
    //         PC = PC;
    //     else
    //         PC = new_PC;
    // end
    
    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0)
            PC <= 32'b0;
        // else if (is_hazard_detected || is_cache_missed) // from cache miss or data, control dependency
        //     PC <= PC;
        else if (is_hazard_detected)
            PC <= PC;
        else
            PC <= new_PC;
    end
    
endmodule
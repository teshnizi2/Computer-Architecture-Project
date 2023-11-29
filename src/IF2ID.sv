module IF2ID (
    clk,
    rst_b,
    freeze,
    flush,
    PC_in,
    inst_in,
    inst,
    PC
);
    input clk, rst_b, freeze, flush;
    input [31:0] PC_in, inst_in;
    output reg [31:0] inst, PC;

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0) begin
            PC <= 32'b0;
            inst <= 32'b0;
        end
        else if (freeze == 1'b0) begin
            if (flush) begin
                // PC <= 32'b0;
                PC <= PC_in - 4;
                inst <= 32'b0;
            end
            else begin
                PC <= PC_in;
                inst <= inst_in;
            end
        end
        else begin
            PC <= PC;
            inst <= inst;
        end
    end
    
endmodule
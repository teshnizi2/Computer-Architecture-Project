module complex_memory (
    data1_out,
    data2_out,
    addr1,
    addr2,
    data1_in,
    data2_in,
    we,
    clk,
    rst_b
);
    output [7:0] data1_out[0:3];
    output [7:0] data2_out[0:3];
    input [31:0] addr1;
    input [31:0] addr2;
    input  [7:0] data1_in[0:3];
    input  [7:0] data2_in[0:3];
    input we;
    input clk;
    input rst_b;

    parameter start = 0, top = (1<<8) - 1;

    reg [7:0] mem[start:top];

    wire [31:0] ea1 = addr1 & 32'hfffffffc;

    assign data1_out[0] = mem[ea1];
    assign data1_out[1] = mem[ea1 + 1];
    assign data1_out[2] = mem[ea1 + 2];
    assign data1_out[3] = mem[ea1 + 3];

    wire [31:0] ea2 = addr2 & 32'hfffffffc;

    assign data2_out[0] = mem[ea2];
    assign data2_out[1] = mem[ea2 + 1];
    assign data2_out[2] = mem[ea2 + 2];
    assign data2_out[3] = mem[ea2 + 3];

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            integer i;
            for (i = start; i <= top; i++)
                mem[i] <= 0;
        end 
        else begin
            if (we) begin
                mem[ea1 + 0] <= data1_in[0];
                mem[ea1 + 1] <= data1_in[1];
                mem[ea1 + 2] <= data1_in[2];
                mem[ea1 + 3] <= data1_in[3];

                mem[ea2 + 0] <= data2_in[0];
                mem[ea2 + 1] <= data2_in[1];
                mem[ea2 + 2] <= data2_in[2];
                mem[ea2 + 3] <= data2_in[3];
            end
        end
    end
endmodule
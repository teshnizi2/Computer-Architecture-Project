module MEMStage (
    clk,
    rst_b,
    cache_addr,
    store_val,
    cache_en,
    is_load,
    mem_write_en,
    b,
    mem_data_out,
    mem_addr,
    hit,
    cache_data_out,
    mem_data_in
);

    input clk, rst_b, cache_en, is_load, b;
    input [31:0] cache_addr, store_val;
    input [7:0] mem_data_out [0:3];

    output [7:0] mem_data_in [0:3];
    output [31:0] mem_addr, cache_data_out;
    output hit, mem_write_en;

    wire [31:0] cache_data_in;

    // store byte
    assign cache_data_in[7:0] = b ? (cache_addr % 4 == 3 ? store_val[7:0] : cache_data_out[7:0]) : store_val[7:0];
    assign cache_data_in[15:8] = b ? (cache_addr % 4 == 2 ? store_val[7:0] : cache_data_out[15:8]) : store_val[15:8];
    assign cache_data_in[23:16] = b ? (cache_addr % 4 == 1 ? store_val[7:0] : cache_data_out[23:16]) : store_val[23:16];
    assign cache_data_in[31:24] = b ? (cache_addr % 4 == 0 ? store_val[7:0] : cache_data_out[31:24]) : store_val[31:24];
    
    cache cache_memory(
        .clk(clk),
        .rst_b(rst_b),
        .hit(hit),
        .cache_addr(cache_addr),
        .cache_data_out(cache_data_out),
        .cache_data_in(cache_data_in),
        .mem_write_en(mem_write_en),
        .mem_addr(mem_addr),
        .mem_data_in({mem_data_in[3], mem_data_in[2], mem_data_in[1], mem_data_in[0]}),
        .mem_data_out({mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]}),
        .load(is_load),
        .cache_en(cache_en)
    );

endmodule
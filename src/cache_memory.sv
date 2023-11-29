// ***** EXTRA *****
module cache_memory(
    we,
    re,
    rst_b,
    clk,
    // tag_mem,
    // mem_addr_src,
    mem_rd,
    mem_wr,
    cache_addr,
    mem_addr,
    // cache_data_src,
    memory_data_out,
    memory_data_in,
    cache_data_in,
    cache_data_out,
    rdy,
    hit
);
    input clk;
    input we;
    input re;
    input rst_b;
    //output tag_mem;
    // output mem_addr_src;
    output mem_rd;
    output mem_wr;
    input [31:0] cache_addr;
    output reg [31:0] mem_addr;
    // output cache_data_src;
    input [31:0] memory_data_out;
    output reg [31:0] memory_data_in;
    input [31:0] cache_data_in;
    output reg [31:0] cache_data_out;
    input rdy;
    output reg hit;

    wire [10:0] block;
    wire [18:0] tag;
    wire [1:0] _byte;

    reg [31:0] memory[0:2047];
    reg [18:0] tag_array[0:2047];
    reg valid_array[0:2047];
    reg dirty_array[0:2047];

    reg mem_rd;
    reg mem_wr;

    assign block = cache_addr[12:2];
    assign tag = cache_addr[31:13];
    assign _byte = cache_addr[1:0];

    integer i, j;

    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            memory[i] = 0;
            tag_array[i] = 0;
            valid_array[i] = 0;
            dirty_array[i] = 0;
        end
    end

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0) begin
            for (j = 0; j < 2048; j = j + 1) begin
                memory[j] <= 0;
                tag_array[j] <= 0;
                valid_array[j] <= 0;
                dirty_array[j] <= 0;
            end 
        end
        else if (we) begin
            if (valid_array[block] && tag_array[block] == tag) begin
                //hit - write
                hit <= 1'b1;
                memory[block] <= cache_data_in;
                dirty_array[block] <= 1'b1;
            end
            else if (valid_array[block] && tag_array[block] != tag) begin
                // miss
                if (dirty_array[block] == 1'b0) begin
                    // read from memory and write
                    mem_rd <= 1'b1;
                    mem_addr <= cache_addr;
                    @(posedge rdy) begin
                        tag_array[block] <= tag;
                        memory[block] <= memory_data_out;
                        dirty_array[block] <= 1'b1;
                    end
                end
                else begin
                    // write back to memory, read from memory, write
                    mem_wr <= 1'b1;
                    mem_addr <= {tag_array[block], block, 2'b0};
                    memory_data_in <= memory[block];
                    @(posedge rdy) begin
                        mem_wr <= 1'b0;
                        mem_rd <= 1'b1;
                        mem_addr <= cache_addr; 
                    end
                    @(posedge rdy) begin
                        memory[block] <= memory_data_out;
                        dirty_array[block] <= 1'b1;
                    end
                end
            end
            else begin
                // miss - read from memory and write
                mem_rd <= 1'b1;
                mem_addr <= cache_addr;
                @(posedge rdy) begin
                    memory[block] <= memory_data_out;
                    dirty_array[block] <= 1'b1;
                    valid_array[block] <= 1'b1;
                end
            end
        end
        else if (re) begin
            if (valid_array[block] && tag_array[block] == tag) begin
                // hit - read
                cache_data_out <= memory[block];
            end
            else if (valid_array[block] && tag_array[block]  != tag) begin
                // miss
                if (dirty_array[block] == 1'b0) begin
                    // read from memory and read
                    mem_rd <= 1'b1;
                    mem_addr <= cache_addr;
                    @(posedge rdy) begin
                        memory[block] <= memory_data_out;
                        cache_data_out <= memory_data_out;
                    end
                end
                else begin
                    // write back to memory, read from memory, read
                    mem_wr <= 1'b1;
                    mem_addr <= {tag_array[block], block, 2'b0};
                    memory_data_in <= memory[block];
                    @(posedge rdy) begin
                        mem_wr <= 1'b0;
                        mem_rd <= 1'b1;
                        mem_addr <= cache_addr; 
                    end
                    @(posedge rdy) begin
                        memory[block] <= memory_data_out;
                        cache_data_out <= memory_data_out;
                    end
                end
            end
            else begin
                // miss - read from memory and read
                mem_rd <= 1'b1;
                mem_addr <= cache_addr;
                @(posedge rdy) begin
                    memory[block] <= memory_data_out;
                    cache_data_out <= memory_data_out;
                    valid_array[block] <= 1'b1;
                end
            end
        end

    end


endmodule
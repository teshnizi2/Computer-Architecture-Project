// 19 bit tag (block id) - 11 bit block - 2 bit byte

module cache(
    clk,
    rst_b,
    hit,
    cache_addr,
    cache_data_out,
    cache_data_in,
    mem_write_en,
    mem_addr,
    mem_data_in,
    mem_data_out,
    load,
    cache_en
);
    input clk;
    input rst_b;
    output reg hit;
    input [31:0] cache_addr;
    output reg [31:0] cache_data_out;
    input [31:0] cache_data_in;
    output mem_write_en;
    output reg [31:0] mem_addr;
    output reg [31:0] mem_data_in;
    input [31:0] mem_data_out;
    input load;
    input cache_en;

    reg [31:0] cache_memory[0:2047]; //cache line - 0:2047 or 2047:0 ?
    reg [18:0] tag_array[0:2047];
    reg valid_array[0:2047];
    reg dirty_array[0:2047];

    reg [31:0] p_cache_addr;
    reg [3:0] cycle;

    wire [18:0] address_tag;
    wire [10:0] address_block;
    wire [1:0] address_byte;

    reg temp_hit = 1'b0;
    reg temp_write_en = 1'b0;
    reg temp_cache_en;

    assign address_tag = cache_addr[31:13];
    assign address_block = cache_addr[12:2];
    assign address_byte = cache_addr[1:0];
    assign hit = (address_tag == tag_array[address_block]) && valid_array[address_block] || temp_hit;
    assign mem_write_en = temp_write_en;
    // assign temp_cache_en = cache_en;
    

    integer i;
    integer j;
    initial begin
        cycle = 4'b0;
        for (i=0; i < 2048; i=i+1) begin
            cache_memory[i] = 32'b0;
            tag_array[i] = 19'b0;
            valid_array[i] = 1'b0;
            dirty_array[i] = 1'b0;
        end
    end

    always @(posedge clk, negedge rst_b) begin
        // temp_cache_en <= cache_en;
        if (!rst_b) begin
            for (j=0 ; j < 2048; j=j+1) begin
                cache_memory[i] = 32'b0;
                tag_array[i] = 19'b0;
                valid_array[i] = 1'b0;
                dirty_array[i] = 1'b0;
                end
        end 
        else begin
            if (cache_en) begin
                case(cycle)
                    4'b0: begin
                        temp_hit <= 1'b0;
                        if (hit) begin
                            // hit <= 1'b1;
                            if (load) 
                                cache_data_out <= cache_memory[address_block];
                            else begin
                                cache_memory[address_block] <= cache_data_in;
                                // cache_data_out <= 32'b0;
                                dirty_array[address_block] <= 1'b1;
                            end 
                            // temp_cache_en <= 0;
                        end 
                        else
                            cycle <= 4'b0001;
                    end
                    4'b0001: begin
                        if (address_tag != tag_array[address_block] && valid_array[address_block]) begin
                            if (dirty_array[address_block]) begin
                                mem_data_in <= cache_memory[address_block];
                                mem_addr <= {tag_array[address_block], address_block, 2'b0};
                                temp_write_en <= 1'b1;
                                cycle <= 4'b0010; // writing in main memory
                            end
                            else
                                cycle <= 4'b0101;
                        end
                        else cycle <= 4'b0101;
                    end
                    4'b0010: cycle <= 4'b0011;
                    4'b0011: cycle <= 4'b0100;
                    4'b0100: cycle <= 4'b0101;
                    4'b0101: begin // clock 6 table 2 - clock 1 table 1
                        temp_hit <= 1'b1;
                        if (load) begin
                            temp_write_en <= 1'b0;
                            // mem_data_in <= 32'bz;
                            mem_addr <= cache_addr;
                            cycle <= 4'b0110; // writing in cache memory
                        end
                        else begin
                            cache_memory[address_block] <= cache_data_in;
                            tag_array[address_block] <= address_tag;
                            valid_array[address_block] <= 1'b1;
                            dirty_array[address_block] <= 1'b1;
                            cycle <= 4'b1010;
                        end
                    end
                    4'b0110: cycle <= 4'b0111;
                    4'b0111: cycle <= 4'b1000;
                    4'b1000: cycle <= 4'b1001;
                    4'b1001: begin
                        cache_memory[address_block] <= mem_data_out;
                        valid_array[address_block] <= 1'b1;
                        tag_array[address_block] <= address_tag;
                        cycle <= 4'b1010;
                    end
                    4'b1010: begin
                        temp_hit <= 1'b0;
                        // cache_data_out <= cache_memory[address_block];
                        cycle <= 4'b0;
                    end
                default: cycle <= 4'b0;
                endcase
            end
        end
    end 

endmodule
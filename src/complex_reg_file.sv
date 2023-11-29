module complex_reg_file (
    rs1_data,
    rs2_data,
    rs1_num,
    rs2_num,
    rt1_data,
    rt2_data,
    rt1_num,
    rt2_num,
    rd1_data,
    rd2_data,
    rd1_num,
    rd2_num,
    rd_we,
    clk,
    rst_b,
    halted
);
    parameter XLEN=32, size=16;

    output [XLEN-1:0] rs1_data;
    output [XLEN-1:0] rs2_data;
    output [XLEN-1:0] rt1_data;
    output [XLEN-1:0] rt2_data;

    input [3:0] rs1_num;
    input [3:0] rs2_num;
    input [3:0] rt1_num;
    input [3:0] rt2_num;
    input [3:0] rd1_num;
    input [3:0] rd2_num;
    input [XLEN-1:0] rd1_data;
    input [XLEN-1:0] rd2_data;
    input clk, rst_b, rd_we, halted;

    reg [XLEN-1:0] data[0:size-1];

    assign rs1_data = data[rs1_num];
    assign rs2_data = data[rs2_num];
    assign rt1_data = data[rt1_num];
    assign rt2_data = data[rt2_num];

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            int i;
            for (i = 0; i < size; i++)
                data[i] <= 0;
        end else begin
            if (rd_we)
                data[rd1_num] <= rd1_data;
                data[rd2_num] <= rd2_data;
        end
    end

    // always @(halted) begin
    //     integer fd = 0;
    //     integer i = 0;
	// 	if (rst_b && (halted)) begin
	// 		fd = $fopen("output/regdump.reg");

	// 		$display("=== Simulation Cycle %0d ===", $time/2);
	// 		$display("*** RegisterFile dump ***");
	// 		$fdisplay(fd, "*** RegisterFile dump ***");
			
	// 		for(i = 0; i < size; i = i+1) begin
	// 			$display("r%2d = 0x%8x", i, data[i]);
	// 			$fdisplay(fd, "r%2d = 0x%8h", i, data[i]); 
	// 		end
			
	// 		$fclose(fd);
	// 	end
	// end


endmodule
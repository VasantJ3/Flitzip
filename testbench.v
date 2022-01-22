`timescale 1ns / 1ps

module general_tb ();

reg clk,is_head,is_tail;
reg [127:0] in;
wire [127:0] out,head_buffer;
reg [127: 0] ram [4 : 0];

integer f;

compressor DUT(
    .clk_in(clk),
    .data_in(in),
    .data_out(out),
    .is_head(is_head),
    .is_tail(is_tail),
    .head_buffer(head_buffer)

);

always #5
    clk = ~clk; // flip clk every 5ns

always @(out)
        $fwrite(f,"%h\n",out);


    initial begin
        clk <= 1;
        f = $fopen("D:/FPGA/projects/Flitzip/deltas.txt","w");
        
        $readmemh("D:/FPGA/projects/Flitzip/flits.txt",ram); // read from file

        is_head <= 1;
        is_tail <= 0;

        #50 in <= ram[0];
        
        #50 in <= ram[1];
        is_head <= 0;

        #50 in <= ram[2];

        #50 in <= ram[3];

        #50 in <= ram[4];
        is_tail <= 1;
        is_head <= 0;


        #50 $fwrite(f,"%b\n",head_buffer);
        $fclose(f);

        
        $stop;
    
    end

endmodule  //general_tb
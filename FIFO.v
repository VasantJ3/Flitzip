module FIFO #(
    parameter    INPUT_WIDTH  = 128,
    parameter    OUTPUT_WIDTH = 128,
    parameter    FLITS = 5, // 5 flits in a packet
    parameter CHUNK_SIZE = 8,
    parameter EN_BITS = 3
) (
    input                               clk_in,wr_en,
    input  [INPUT_WIDTH - 1 : 0]        data_in,
    output reg [OUTPUT_WIDTH - 1 : 0]   data_out
);
reg [INPUT_WIDTH - 1 : 0] FIFO [FLITS - 1 : 0];
integer counter = 0;

always @(posedge clk_in) begin
    data_out <= FIFO[counter];
    if (wr_en) begin // if write enable, write data to FIFO
        FIFO[counter] <= data_in;
        counter = (counter + 1) % FLITS;
    end

    
    
end

endmodule  //FIFO
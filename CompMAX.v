module CompMAX #(
    parameter    INPUT_WIDTH  = 128,
    parameter    OUTPUT_WIDTH = 8,
    parameter N = 128, // number of chunks
    parameter D = 8 // size of each chunk
) (
    input                           clk_in,
    input   [INPUT_WIDTH - 1 : 0]    data_in,
    output  [OUTPUT_WIDTH - 1 : 0]   data_out
);
reg [D - 1 : 0]    temp; // temp register to hold data
integer j;



always @(posedge clk_in ) begin
    j=0;

    temp <= data_in[j+:8]; // load data into temp
    for(j=8;j<N;j=j+8) begin // loop over next chunks
        if(temp <= data_in[j+:8]) // if temp is smaller than next chunk
            temp <= data_in[j+:8]; // load next chunk into temp
    end

    
end
assign data_out = temp; // output the maximum

endmodule  //CompMAX
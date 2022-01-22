module CompMIN #(
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
integer i=0;



always @(posedge clk_in ) begin
    i=0;
    temp <= data_in[i+:8]; // take i-th chunk
    for(i=8;i<N;i=i+8) begin // loop over next chunks
        if(temp >= data_in[i+:8]) // if temp is greater than i-th chunk
            temp <= data_in[i+:8]; // replace temp with i-th chunk
    end

   
end
assign data_out = temp; // output the minimum

endmodule  //CompMIN
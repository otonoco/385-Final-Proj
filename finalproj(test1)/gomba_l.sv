module gomba_l (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] gl [0:1023];

    initial
    begin
        $readmemh("gomba_left.txt", gl);
    end


    always_ff @ (posedge Clk) 
    begin
        data_out <= gl[read_addr];
    end

endmodule
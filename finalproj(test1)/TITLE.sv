module TITLE (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] stand [0:831];

    initial
    begin
        $readmemh("title.txt", stand);
    end


    always_ff @ (posedge Clk) 
    begin
        data_out <= stand[read_addr];
    end

endmodule
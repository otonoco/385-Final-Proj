module RE (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] wr3 [0:5519];

    initial
    begin
        $readmemh("oversmall.txt", wr3);
    end


    always_ff @ (posedge Clk) begin

        data_out <= wr3[read_addr];
    end

endmodule
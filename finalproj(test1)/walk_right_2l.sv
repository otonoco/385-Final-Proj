module WRL_2 (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] wr2 [0:831];

    initial
    begin
        $readmemh("luigi_wk_2.txt", wr2);
    end


    always_ff @ (posedge Clk) 
    begin
        data_out <= wr2[read_addr];
    end

endmodule
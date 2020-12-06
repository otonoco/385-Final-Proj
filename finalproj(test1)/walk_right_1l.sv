module WRL_1 (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] wr1 [0:831];

    initial
    begin
        $readmemh("luigi_wk_1.txt", wr1);
    end


    always_ff @ (posedge Clk) begin

        data_out <= wr1[read_addr];
    end

endmodule
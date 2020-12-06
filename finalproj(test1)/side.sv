module side (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] side
);

    logic [23:0] wr3 [0:447];

    initial
    begin
        $readmemh("coin2.txt", wr3);
    end


    always_ff @ (posedge Clk) begin

        side  <= wr3[read_addr];
    end

endmodule
module front (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] front
);

    logic [23:0] wr3 [0:447];

    initial
    begin
        $readmemh("coin1.txt", wr3);
    end


    always_ff @ (posedge Clk) 
    begin
        front <= wr3[read_addr];
    end

endmodule
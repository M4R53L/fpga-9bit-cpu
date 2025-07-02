module counter (
    input wire Resetn,  // Active-low reset
    input wire MClock,  // Clock signal
    output reg [19:0] count // 20-bit counter
);

    always @(posedge MClock or negedge Resetn) begin
        if (!Resetn)
            count <= 20'b0; // Reset counter to 0
        else
            count <= count + 1; // Increment counter
    end

endmodule
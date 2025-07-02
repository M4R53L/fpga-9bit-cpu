module procc (
    input wire [8:0] DIN,
    input wire Resetn,
    input wire Clock,
    input wire Run,
    output reg Done,
    output [8:0] BusWires
);

parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
parameter MV = 3'b000, MVI = 3'b001, ADD = 3'b010, SUB = 3'b011, SPECIALM = 3'b101;

reg [7:0] Rin;
reg [7:0] ROmux;
reg GOmux, DOmux;
wire [8:0] IR, RA, RG, R0, R1, R2, R3, R4, R5, R6, R7, ALU;
reg Ain, Gin, IRin;
reg sub, shift;
reg [1:0] Tstep_Q, Tstep_D;
wire [2:0] I;
wire [7:0] Xreg, Yreg;

assign I = IR[8:6];

dec3to8 decX (IR[5:3], 1'b1, Xreg); 
dec3to8 decY (IR[2:0], 1'b1, Yreg);

always @(Tstep_Q or I or Run) begin
    case (Tstep_Q)
        T0: begin
            if (Run)
                Tstep_D <= T1;
            else
                Tstep_D <= T0;
        end
        T1: Tstep_D <= (I == MV || I == MVI ) ? T0 : ((~Run) ? T2 : T1);
        T2: Tstep_D <= ~Run ? T3 : T2;
        T3: Tstep_D <= ~Run ? T0 : T3;
        default: Tstep_D <= T0;
    endcase
end

always @(Tstep_Q or I or Xreg or Yreg) begin    
    case (Tstep_Q)
        T0: begin
            Done <= 1'b0;    
            IRin <= 1'b1;
            Rin  <= 8'b0;
            Ain <= 1'b0;
            Gin <= 1'b0;
            ROmux <= 8'b0;
            GOmux <= 1'b0;
            DOmux <= 1'b1;
        end
        T1: begin
            IRin <= 1'b0;
            case (I)
                MV: begin
                    Rin <= Xreg;
                    Ain <= 1'b0;
                    Done <= 1'b1;
                    ROmux <= Yreg;
                    GOmux <= 1'b0;
                    DOmux <= 1'b0;
                    Gin <= 1'b0;
                end
                MVI: begin
                    Rin <= Xreg;
                    Ain <= 1'b0;
                    Done <= 1'b1;
                    ROmux <= 8'b0;
                    GOmux <= 1'b0;
                    DOmux <= 1'b1;
                    Gin <= 1'b0;
                end
                ADD, SUB: begin
                    Ain <= 1'b1;
                    Done <= 1'b0;
                    ROmux <= Yreg;
                    DOmux <= 1'b0;
                    Rin <= 8'b0;
                    GOmux <= 1'b0;
                end
                SPECIALM: begin
                    Ain <= 1'b1;
                    Done <= 1'b0;
                    ROmux <= Xreg;
                    DOmux <= 1'b0;
                    Rin <= 8'b0;
                    GOmux <= 1'b0;
                end
                default: begin
                    Done <= 1'b0;
                    Ain <= 1'b0;
                    Gin <= 1'b0;
                    ROmux <= 8'b0;
                    GOmux <= 1'b0;
                    DOmux <= 1'b1;
                    Rin <= 8'b0;
                end
            endcase
        end
        T2: begin
            Ain <= 1'b0;
            case (I)
                ADD: begin
                    Gin <= 1'b1;
                    sub <= 1'b0;
                    ROmux <= Xreg;
                    shift <= 1'b0;
                end
                SUB: begin
                    Gin <= 1'b1;
                    sub <= 1'b1;
                    ROmux <= Xreg;
                    shift <= 1'b0;
                end
                SPECIALM: begin
                    Gin <= 1'b1;
                    sub <= 1'b0;
                    shift <= 1'b1;
                    ROmux <= Yreg;
                end
                default: begin
                    Gin <= 1'b0;
                    sub <= 1'b0;
                    shift <= 1'b0;
                end
            endcase
        end
        T3: begin
            case (I)
                SPECIALM: begin
                    Rin <= Yreg; 
                    Ain <= 1'b0;
                    Done <= 1'b1;
                    ROmux <= 8'b0;
                    GOmux <= 1'b1;
                    DOmux <= 1'b0;
                    Gin <= 1'b0;
				        IRin <=1'b0;
                end
                default: begin
                    Rin <= Xreg;
                    Done <= 1'b1;
                    GOmux <= 1'b1;
                    DOmux <= 1'b0;
                    Gin <= 1'b0;
                end
            endcase
        end
    endcase
end

always @(posedge Clock or negedge Resetn) begin
    if (!Resetn) 
        Tstep_Q <= T0;
    else
        Tstep_Q <= Tstep_D;
end

regn reg_0 (.R(BusWires), .Rin(Rin[0]), .Resetn(Resetn), .Clock(Clock), .Q(R0));
regn reg_1 (.R(BusWires), .Rin(Rin[1]), .Resetn(Resetn), .Clock(Clock), .Q(R1));
regn reg_2 (.R(BusWires), .Rin(Rin[2]), .Resetn(Resetn), .Clock(Clock), .Q(R2));
regn reg_3 (.R(BusWires), .Rin(Rin[3]), .Resetn(Resetn), .Clock(Clock), .Q(R3));
regn reg_4 (.R(BusWires), .Rin(Rin[4]), .Resetn(Resetn), .Clock(Clock), .Q(R4));
regn reg_5 (.R(BusWires), .Rin(Rin[5]), .Resetn(Resetn), .Clock(Clock), .Q(R5));
regn reg_6 (.R(BusWires), .Rin(Rin[6]), .Resetn(Resetn), .Clock(Clock), .Q(R6));
regn reg_7 (.R(BusWires), .Rin(Rin[7]), .Resetn(Resetn), .Clock(Clock), .Q(R7));

regn reg_RA (.R(BusWires), .Rin(Ain), .Resetn(Resetn), .Clock(Clock), .Q(RA));
regn reg_RG (.R(ALU), .Rin(Gin), .Resetn(Resetn), .Clock(Clock), .Q(RG));
regn reg_IR (.R(DIN), .Rin(IRin), .Resetn(Resetn), .Clock(Clock), .Q(IR));

addsub _addsub (
    .sub(sub),
    .Bus(BusWires),
    .A(RA),
    .shift(shift),
    .result(ALU)
);

muxsmthng2one _multimux (
    .in0(R0), .in1(R1), .in2(R2), .in3(R3), .in4(R4), .in5(R5), .in6(R6), .in7(R7),
    .inD(DIN), .inG(RG),
    .rsele(ROmux), .gsele(GOmux), .dsele(DOmux),
    .out(BusWires)
);

endmodule

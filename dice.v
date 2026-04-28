module dice(
    input clk,
    input rst,
    input button,
    output reg [6:0] led   // 7-segment display output
);

    reg [2:0] dice_value;  // stores dice number (1–6)
    reg [15:0] counter;    // simple pseudo-random counter

    // 7-segment encoding for numbers 1–6
    //   segments: {a,b,c,d,e,f,g}
    //   0 = ON, 1 = OFF (active-low common anode)
    function [6:0] seg_encode;
        input [2:0] num;
        case (num)
            3'd1: seg_encode = 7'b1111001; // 1
            3'd2: seg_encode = 7'b0100100; // 2
            3'd3: seg_encode = 7'b0110000; // 3
            3'd4: seg_encode = 7'b0011001; // 4
            3'd5: seg_encode = 7'b0010010; // 5
            3'd6: seg_encode = 7'b0000010; // 6
            default: seg_encode = 7'b1000000; // 0 (not used)
        endcase
    endfunction

    // Counter for randomness
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // On button press, capture dice value
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dice_value <= 1;
            led <= seg_encode(3'd1);
        end else if (button) begin
            // Randomized dice value using urandom
            dice_value <= $urandom_range(1,6);
            led <= seg_encode(dice_value);
        end
    end

endmodule


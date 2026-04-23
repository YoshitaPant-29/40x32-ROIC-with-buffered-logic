module roic_shift #(
    parameter COLS = 40,
    parameter ROWS = 32
)(
    input  logic clk,
    input  logic rst,
    output logic [COLS-1:0] col_enable,
    output logic [ROWS-1:0] row_enable,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE,
        SCAN,
        DONE
    } state_t;

    state_t state;

    logic [$clog2(COLS)-1:0] col_cnt;
    logic [$clog2(ROWS)-1:0] row_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= IDLE;
            col_cnt    <= 0;
            row_cnt    <= 0;
            col_enable <= '0;
            row_enable <= '0;
            done       <= 0;
        end 
        else begin
            case (state)

                IDLE: begin
                    col_cnt <= 0;
                    row_cnt <= 0;
                    col_enable <= 1;
                    row_enable <= 1;
                    done <= 0;
                    state <= SCAN;
                end

                SCAN: begin
                    col_enable <= (1 << col_cnt);
                    row_enable <= (1 << row_cnt);

                    if (col_cnt < COLS-1)
                        col_cnt <= col_cnt + 1;
                    else begin
                        col_cnt <= 0;
                        if (row_cnt < ROWS-1)
                            row_cnt <= row_cnt + 1;
                        else
                            state <= DONE;
                    end
                end

                DONE: begin
                    col_enable <= '0;
                    row_enable <= '0;
                    done <= 1;
                end

            endcase
        end
    end

endmodule

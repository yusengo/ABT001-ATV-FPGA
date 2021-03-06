module FPGA_DAC(input clk_100M,input n_rst,input Ready,input[15:0] CMD_IN,input[15:0] DAC_DATAIN,output reg DAC_CLK,output reg DAC_SPIOUT,output reg DAC_NCS);

reg[3:0] StateM;
reg[4:0] spi_clk_cnt;
reg[3:0] speed_cnt;

always@(posedge clk_100M or negedge n_rst)
begin
	if(!n_rst)
		begin
			StateM <= 4'd0;
			spi_clk_cnt <= 5'd0;
			speed_cnt <= 4'd0;
			DAC_NCS	<= 1'd1;
		end
	else
		begin
			case(StateM)
			
			4'd0:
			begin
				if(Ready == 1'd1)
					begin
						StateM <= 4'd1;
					end
				else
					begin
						StateM <= 4'd0; 
					end
			end
			
			4'd1:
			begin
				if(CMD_IN[15:0] == 16'd1)
					begin
						StateM <= 4'd2;
						spi_clk_cnt <= 5'd16;
						speed_cnt <= 4'd0;
						DAC_NCS	<= 1'd0;
						DAC_SPIOUT <= 1'd0;
						DAC_CLK	<= 1'd0;
					end
				else
					begin
						StateM <= 4'd3;
					end
			end

			4'd2:
			begin
				if(spi_clk_cnt > 5'd0)
					begin
						if(speed_cnt < 4'd2)
							begin
								DAC_SPIOUT <= ((DAC_DATAIN >> (spi_clk_cnt - 1))&1'b1);
								DAC_CLK	<= 1'd1;
								speed_cnt <= speed_cnt + 4'd1;
							end
						else
							begin
								if(speed_cnt < 4'd4)
									begin
										DAC_CLK	<= 1'd0;
										speed_cnt <= speed_cnt + 4'd1;
									end
								else
									begin
										spi_clk_cnt <= spi_clk_cnt - 5'd1;
										speed_cnt	<= 4'd0;
									end
							end
					end
				else
					begin
						if(speed_cnt < 4'd2)
							begin
								speed_cnt <= speed_cnt + 4'd1;
							end
						else
							begin
								DAC_NCS	<= 1'd1;
								StateM <= 4'd3;
							end					
					end
			end
			
			4'd3:
			begin
				if(Ready == 1'd0)
					begin
						StateM <= 4'd0;
					end
				else
					begin
						StateM <= 4'd3;
					end
			end
			
			default:
			begin
				StateM <= 4'd0;
			end
			endcase
		end
end


endmodule

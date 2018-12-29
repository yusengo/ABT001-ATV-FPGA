/* 
##############################################
#        炬远智能科技（上海）有限公司
##############################################
20180230
*	1. ADC直接采样，无配置，后续加
* 
*/
module FPGA_ADC(input clk_100M,input n_rst,input ADC_SPISDO,output reg[15:0] ADC_VALUE,output reg ADC_nRST,output reg ADC_SPInCS,output reg ADC_SPICLK,output reg ADC_SPISDI);

reg[4:0] spi_clk_cnt;
reg[8:0] spi_speed_cnt;
reg[3:0] StateM;
reg[15:0] adc_value_temp;
//reg[3:0] flag;

always@(posedge clk_100M or negedge n_rst)
begin
	if(!n_rst)
		begin
			//flag	<= 4'd0;
			spi_speed_cnt <= 9'd0;
			spi_clk_cnt <= 5'd0;
			ADC_SPInCS	<= 1'd1;
			ADC_SPICLK	<= 1'd0;
			ADC_nRST		<= 1'd1;
			StateM <= 4'd0;
		end
	else
		begin
			case(StateM)
			4'd0:
			begin
				spi_speed_cnt <= 9'd0;
				spi_clk_cnt <= 5'd16;
				ADC_SPInCS	<= 1'd0;
				ADC_SPICLK	<= 1'd0;
				StateM <= 4'd1;
			end
			
			4'd1:
			begin
				if(spi_speed_cnt < 5'd10)
					begin
						spi_speed_cnt <= spi_speed_cnt + 5'd1;
					end
				else
					begin
						spi_speed_cnt <= 9'd0;
						spi_clk_cnt <= 5'd16;
						ADC_SPInCS	<= 1'd0;
						ADC_SPICLK	<= 1'd0;
						adc_value_temp <= 16'd0;
						StateM <= 4'd2;
					end
			end
			
			4'd2:
			begin
				if(spi_clk_cnt > 5'd0)
					begin
						if(spi_speed_cnt < 9'd10)
							begin
								ADC_SPICLK	<= 1'd1;
								adc_value_temp <= adc_value_temp |(ADC_SPISDO << (spi_clk_cnt - 5'd1));
								spi_speed_cnt <= spi_speed_cnt + 9'd1;
							end
						else
							begin
								if(spi_speed_cnt < 9'd20)
									begin
										ADC_SPICLK <= 1'd0;
										spi_speed_cnt <= spi_speed_cnt + 9'd1;
									end
								else
									begin
										spi_speed_cnt <= 9'd0;
										spi_clk_cnt	<= spi_clk_cnt - 5'd1;
									end
							end
					end
				else
					begin
						ADC_VALUE[15:0] <= adc_value_temp[15:0];
						//ADC_VALUE[15:0] <= 16'd2000;
						ADC_SPInCS	<= 1'd1;
						spi_speed_cnt <= 9'd0;
						StateM	<= 4'd3;
					end
			end
			
			4'd3:
			begin
				if(spi_speed_cnt > 9'd200)
					begin
						spi_speed_cnt	<= 9'd0;
						StateM <= 4'd0;
					end
				else
					begin
						spi_speed_cnt	<= spi_speed_cnt + 9'd1;
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

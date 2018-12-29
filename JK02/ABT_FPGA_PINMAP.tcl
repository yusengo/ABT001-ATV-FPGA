##############################################
#        炬远智能科技（上海）有限公司
##############################################
#			版权所有	盗版必究
#			yusengo@163.com

#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_23	-to	inclk0

set_location_assignment	PIN_69	-to	DSP_SPI_DFIN
set_location_assignment	PIN_70	-to	DSP_SPI_FDOUT
set_location_assignment	PIN_71	-to	DSP_SPI_CLK
set_location_assignment	PIN_72	-to	DSP_SPI_EN


set_location_assignment	PIN_75	-to	DAC_NCS
set_location_assignment	PIN_76	-to	DAC_CLK
set_location_assignment	PIN_77	-to	DAC_SPIOUT

set_location_assignment	PIN_83	-to	ADC_nRST
set_location_assignment	PIN_84	-to	ADC_SPISDI
set_location_assignment	PIN_85	-to	ADC_SPInCS
set_location_assignment	PIN_86	-to	ADC_SPICLK
set_location_assignment	PIN_87	-to	ADC_SPISDO

#------------------PC104----------------------#
set_location_assignment	PIN_144	-to	artAddr[0]
set_location_assignment	PIN_143	-to	artAddr[1]
set_location_assignment	PIN_142	-to	artAddr[2]
set_location_assignment	PIN_141	-to	artAddr[3]
set_location_assignment	PIN_138	-to	artAddr[4]
set_location_assignment	PIN_137	-to	artAddr[5]
set_location_assignment	PIN_136	-to	artAddr[6]
set_location_assignment	PIN_135	-to	artAddr[7]
set_location_assignment	PIN_133	-to	artAddr[8]
set_location_assignment	PIN_132	-to	artAddr[9]

set_location_assignment	PIN_129	-to	artRD
set_location_assignment	PIN_128	-to	artWR

set_location_assignment	PIN_127	-to	artData[0]
set_location_assignment	PIN_126	-to	artData[1]
set_location_assignment	PIN_125	-to	artData[2]
set_location_assignment	PIN_124	-to	artData[3]
set_location_assignment	PIN_121	-to	artData[4]
set_location_assignment	PIN_120	-to	artData[5]
set_location_assignment	PIN_119	-to	artData[6]
set_location_assignment	PIN_115	-to	artData[7]

set_location_assignment	PIN_114	-to	artDIR

#------------------END------------------------#






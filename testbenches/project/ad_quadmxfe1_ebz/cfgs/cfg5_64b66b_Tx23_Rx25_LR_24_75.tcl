global ad_project_params

set ad_project_params(ADC_OFFLOAD_TYPE) 0
set ad_project_params(ADC_OFFLOAD_SIZE) [expr 2*1024*1024]
set ad_project_params(DAC_OFFLOAD_TYPE) 0
set ad_project_params(DAC_OFFLOAD_SIZE) [expr 2*1024*1024]
set ad_project_params(RD_DATA_REGISTERED) 1
set ad_project_params(RD_FIFO_ADDRESS_WIDTH) 3

set ad_project_params(JESD_MODE)  64B66B
set ad_project_params(RX_LANE_RATE)  24.75
set ad_project_params(TX_LANE_RATE)  24.75
set ad_project_params(RX_PLL_SEL)  1
set ad_project_params(TX_PLL_SEL)  1
set ad_project_params(REF_CLK_RATE)  250

set ad_project_params(RX_JESD_M)  4
set ad_project_params(RX_JESD_L)  4
set ad_project_params(RX_JESD_F)  3
set ad_project_params(RX_JESD_S)  2
set ad_project_params(RX_JESD_NP)  12
set ad_project_params(RX_JESD_K)  256
set ad_project_params(RX_NUM_LINKS)  4

set ad_project_params(TX_JESD_M)  4
set ad_project_params(TX_JESD_L)  4
set ad_project_params(TX_JESD_F)  3
set ad_project_params(TX_JESD_S)  2
set ad_project_params(TX_JESD_NP)  12
set ad_project_params(TX_JESD_K)  256
set ad_project_params(TX_NUM_LINKS)  4

set ad_project_params(DAC_TPL_XBAR_ENABLE)  0


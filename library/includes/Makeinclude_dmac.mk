## Copyright (C) 2024 Analog Devices, Inc.
####################################################################################
####################################################################################

# Makeincludes
include $(TB_LIBRARY_PATH)/includes/Makeinclude_regmap.mk

# All test-bench dependencies except test programs
SV_DEPS += $(TB_LIBRARY_PATH)/drivers/dmac/dma_trans.sv
SV_DEPS += $(TB_LIBRARY_PATH)/drivers/dmac/dmac_api.sv
SV_DEPS += $(TB_LIBRARY_PATH)/regmaps/adi_regmap_dmac_pkg.sv

SIM_LIB_DEPS := io_vip

## Copyright (C) 2024-2025 Analog Devices, Inc.
####################################################################################
####################################################################################

# Makeincludes
include $(TB_LIBRARY_PATH)/includes/Makeinclude_regmap.mk

# All test-bench dependencies except test programs
SV_DEPS += $(TB_LIBRARY_PATH)/vip/adi/spi_vip/adi_spi_vip_pkg.sv
SV_DEPS += $(TB_LIBRARY_PATH)/drivers/spi_engine/spi_engine_api_pkg.sv
SV_DEPS += $(TB_LIBRARY_PATH)/drivers/spi_engine/spi_engine_instr_pkg.sv
SV_DEPS += $(TB_LIBRARY_PATH)/regmaps/adi_regmap_spi_engine_pkg.sv

SIM_LIB_DEPS += spi_vip

## Copyright (C) 2024 Analog Devices, Inc.
####################################################################################
####################################################################################

# Makeincludes
include $(TB_LIBRARY_PATH)/includes/Makeinclude_regmap.mk

# All test-bench dependencies except test programs
SV_DEPS += $(TB_LIBRARY_PATH)/drivers/xcvr/adi_xcvr_pkg.sv
SV_DEPS += $(TB_LIBRARY_PATH)/regmaps/adi_regmap_xcvr_pkg.sv

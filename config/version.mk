PRODUCT_VERSION_MAJOR = 20
PRODUCT_VERSION_MINOR = 0
TONG_GAPPS := true

# GAPPS or VANILLA
ifeq ($(TONG_GAPPS), true)
    $(call inherit-product, vendor/gapps/common/common-vendor.mk)
    PRODUCT_TYPE := GAPPS
else
    PRODUCT_TYPE := VANILLA
endif


ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Set LINEAGE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef LINEAGE_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "LINEAGE_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LINEAGE_||g')
        LINEAGE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LINEAGE_BUILDTYPE)),)
    LINEAGE_BUILDTYPE := OFFICIAL
    LINEAGE_EXTRAVERSION :=
endif

ifeq ($(LINEAGE_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LINEAGE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)$(LINEAGE_EXTRAVERSION)-$(LINEAGE_BUILD)-$(PRODUCT_TYPE)

# Internal version
LINEAGE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# Display version
LINEAGE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(LINEAGE_VERSION_SUFFIX)

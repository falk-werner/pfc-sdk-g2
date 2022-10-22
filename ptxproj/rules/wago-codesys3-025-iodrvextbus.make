## -*-makefile-*-
#
# Copyright (C) 2013 by WAGO GmbH & Co. KG
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CDS3_IODRVEXTBUS) += cds3-iodrvextbus

CDS3_IODRVEXTBUS_VERSION    := 0.0.1
CDS3_IODRVEXTBUS            := IoDrvExtBus
CDS3_IODRVEXTBUS_DIR        := $(BUILDDIR)/$(CDS3_IODRVEXTBUS)
CDS3_IODRVEXTBUS_URL        := file://$(PTXDIST_WORKSPACE)/wago_intern/codesys3-Component/$(CDS3_IODRVEXTBUS)
CDS3_IODRVEXTBUS_SRC_DIR    := $(PTXDIST_WORKSPACE)/wago_intern/codesys3-Component/$(CDS3_IODRVEXTBUS)
CDS3_IODRVEXTBUS_SRC        := $(CDS3_IODRVEXTBUS_SRC_DIR)/$(CDS3_IODRVEXTBUS)
CDS3_IODRVEXTBUS_BIN        := lib$(CDS3_IODRVEXTBUS).so.$(CDS3_IODRVEXTBUS_VERSION)

CDS3_IODRVEXTBUS_PACKAGE_NAME := cds3-iodrvextbus_$(CDS3_IODRVEXTBUS_VERSION)_$(PTXDIST_IPKG_ARCH_STRING)
CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR := $(PTXDIST_PLATFORMCONFIGDIR)/packages

#CDS3_IODRVEXTBUS_CMP_INCLUDE:=$(PLCLINUXRT_V3_DIR)/Components/
#CDS3_IODRVEXTBUS_PLATFORM_INCLUDE:=$(PLCLINUXRT_V3_DIR)/Platforms/Linux/

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-iodrvextbus.get:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-iodrvextbus.extract:
	@$(call targetinfo)
	mkdir -p $(CDS3_IODRVEXTBUS_DIR)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
 	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE

#normally this is needed to use but the old schroot does not have unzip so we have to go a workaround via tar.gz
	rsync -a --exclude=.svn/ \
		--exclude=".*" \
		--exclude="*.d" \
		--exclude="*.o" \
		--exclude="*.pdf"  \
		--exclude="*tar.bz2" \
		$(CDS3_IODRVEXTBUS_SRC_DIR)/ $(CDS3_IODRVEXTBUS_DIR)/

#	$(call patchin, CDS3_IODRVEXTBUS)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------


$(STATEDIR)/cds3-iodrvextbus.prepare:
	@$(call targetinfo)
	@$(call touch)


# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------
CDS3_IODRVEXTBUS_PATH      := PATH=$(CROSS_PATH)
CDS3_IODRVEXTBUS_MAKE_ENV  := $(CROSS_ENV)

CDS3_IODRVEXTBUS_MAKE_OPT += "DBGMODE=-g3"
CDS3_IODRVEXTBUS_MAKE_OPT += "OPTIMIZE=-O0"


$(STATEDIR)/cds3-iodrvextbus.compile:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	$(call world/compile, CDS3_IODRVEXTBUS)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-iodrvextbus.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-iodrvextbus.targetinstall:
	@$(call targetinfo)
	@$(call install_init, cds3-iodrvextbus)

	@$(call install_fixup,cds3-iodrvextbus,PRIORITY,optional)
	@$(call install_fixup,cds3-iodrvextbus,SECTION,base)
	@$(call install_fixup,cds3-iodrvextbus,AUTHOR,"WAGO")
	@$(call install_fixup,cds3-iodrvextbus,DESCRIPTION,missing)

ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES

	# Extract precompiled binaries from archive
	rm -rf $(CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR)/tmp/*
	cd $(CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR)/tmp && \
	ar -xov $(CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR)/$(CDS3_IODRVEXTBUS_PACKAGE_NAME).ipk
	@$(call install_archive, cds3-iodrvextbus, 0, 0, $(CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR)/tmp/data.tar.gz, )
else
	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE

	@$(call install_copy, cds3-iodrvextbus, 0, 0, 0755, $(CDS3_IODRVEXTBUS_DIR)/$(CDS3_IODRVEXTBUS_BIN), /usr/lib/$(CDS3_IODRVEXTBUS_BIN))
	@$(call install_link, cds3-iodrvextbus, ../$(CDS3_IODRVEXTBUS_BIN), /usr/lib/IoDrvDal/lib$(CDS3_IODRVEXTBUS).so);

endif
	@$(call install_finish,cds3-iodrvextbus)
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_RELEASE
	# Backup binaries in configs/@platform@/packages/
	cp $(PKGDIR)/$(CDS3_IODRVEXTBUS_PACKAGE_NAME).ipk $(CDS3_IODRVEXTBUS_PLATFORMCONFIGPACKAGEDIR)/
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/cds3-iodrvextbus.clean:
	rm -rf $(STATEDIR)/cds3-iodrvextbus.*
	rm -rf $(PKGDIR)/cds3-iodrvextbus_*
	rm -rf $(CDS3_IODRVEXTBUS_DIR)

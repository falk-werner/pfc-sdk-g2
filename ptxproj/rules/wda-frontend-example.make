# -*-makefile-*-
#
# Copyright (C) 2022 by <Falk Werner>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WDA_FRONTEND_EXAMPLE) += wda-frontend-example

#
# Paths and names
#
WDA_FRONTEND_EXAMPLE_VERSION	:= 1.0.0
WDA_FRONTEND_EXAMPLE		:= wda-frontend-example-$(WDA_FRONTEND_EXAMPLE_VERSION)
WDA_FRONTEND_EXAMPLE_URL		:= file://local_src/wda-frontend-example
WDA_FRONTEND_EXAMPLE_DIR		:= $(BUILDDIR)/$(WDA_FRONTEND_EXAMPLE)
WDA_FRONTEND_EXAMPLE_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(WDA_FRONTEND_EXAMPLE_SOURCE):
#	@$(call targetinfo)
#	@$(call get, WDA_FRONTEND_EXAMPLE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#WDA_FRONTEND_EXAMPLE_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
WDA_FRONTEND_EXAMPLE_CONF_TOOL	:= cmake
#WDA_FRONTEND_EXAMPLE_CONF_OPT	:= $(CROSS_CMAKE_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/wda-frontend-example.targetinstall:
	@$(call targetinfo)

	@$(call install_init, wda-frontend-example)
	@$(call install_fixup, wda-frontend-example, PRIORITY, optional)
	@$(call install_fixup, wda-frontend-example, SECTION, base)
	@$(call install_fixup, wda-frontend-example, AUTHOR, "<Falk Werner>")
	@$(call install_fixup, wda-frontend-example, DESCRIPTION, missing)

#	# This is an example only. Adapt it to your requirements. Read the
#	# documentation's section "Make it Work" in chapter "Adding new Packages"
#	# how to prepare this content or/and read chapter
#	# "Rule File Macro Reference" to get an idea of the available macros
#	# you can use here and how to use them.

	@$(call install_copy, wda-frontend-example, 0, 0, 0755, -, /usr/bin/wda-frontend-example)

	@$(call install_finish, wda-frontend-example)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/wda-frontend-example.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, WDA_FRONTEND_EXAMPLE)

# vim: syntax=make

#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci2-cputemp
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci2-cputemp
  TITLE:=Display CPU temperature
  MAINTAINER:=javonca
  DEPENDS:=+
  VARIANT:=arm
endef

define Package/luci2-cputemp/description
  Display CPU temperature.
endef

define Build/Compile
endef

define Package/luci2-cputemp/install
	$(INSTALL_DIR) $(1)/etc
	cp -pR ./files/* $(1)/etc
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./uci-defaults/090-cover-default $(1)/etc/uci-defaults/090-cover-default
endef

$(eval $(call BuildPackage,luci2-cputemp))

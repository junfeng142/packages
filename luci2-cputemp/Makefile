#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cputemp
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/cputemp
  TITLE:=Display CPU temperature for h3h5
  MAINTAINER:=javonca
  DEPENDS:=@TARGET_sunxi
  VARIANT:=arm
endef

define Package/cputemp/description
  Display CPU temperature for h3h5.
endef

define Build/Compile
endef

define Package/cputemp/install
	$(INSTALL_DIR) $(1)/etc
	cp -pR ./files/* $(1)/etc
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./uci-defaults/090-cover-default $(1)/etc/uci-defaults/090-cover-default
endef

$(eval $(call BuildPackage,cputemp))

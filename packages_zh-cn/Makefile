#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=packages_zh-cn
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/packages_zh-cn
  TITLE:=Chinese for extra packages
  MAINTAINER:=javonca
  DEPENDS:=
endef

define Package/packages_zh-cn/description
  Chinese for extra packages.
endef

define Build/Compile
endef

define Package/packages_zh-cn/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	cp -pR ./files/* $(1)/usr/lib/lua/luci/i18n
endef

$(eval $(call BuildPackage,packages_zh-cn))

# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-terminal
PKG_VERSION:=v1.0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=<https://github.com/tsl0922/ttyd>
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for ttyd
	PKGARCH:=all
	DEPENDS:=+ttyd
endef

define Package/$(PKG_NAME)/description
	LuCI support for ttyd
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -fr /tmp/luci-indexcache /tmp/luci-modulecache
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/terminal.po $(1)/usr/lib/lua/luci/i18n/terminal.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

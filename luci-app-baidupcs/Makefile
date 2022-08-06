# Copyright (C) 2018-2019 Lienol
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-baidupcs
PKG_VERSION:=v3.7
PKG_RELEASE:=3
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for BaiduPCS-Go
	PKGARCH:=all
	DEPENDS:=
endef

define Package/$(PKG_NAME)/description
	LuCI support for BaiduPCS-Go
endef

# 禁止OpenWrt对二进制文件进行strip
STRIP:=true

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
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/baidupcs-web.po $(1)/usr/lib/lua/luci/i18n/baidupcs-web.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

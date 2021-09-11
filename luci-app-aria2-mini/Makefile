#
# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-aria2-mini
PKG_RELEASE:=136
PKG_VERSION:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/config
config PACKAGE_$(PKG_NAME)_INCLUDE_Ariang
	bool "Include Ariang"
	default y if x86_64

config PACKAGE_$(PKG_NAME)_INCLUDE_Web-UI
	bool "Include Web-UI"
	default n
endef

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Mini LuCI Support for Aria2
	PKGARCH:=all
	DEPENDS:= +aria2 \
	+PACKAGE_$(PKG_NAME)_INCLUDE_Ariang:ariang \
	+PACKAGE_$(PKG_NAME)_INCLUDE_Web-UI:webui-aria2
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/aria2.po $(1)/usr/lib/lua/luci/i18n/aria2.zh-cn.lmo
endef

define Package/luci-app-ssr-plus/postinst
#!/bin/sh
rm -fr /tmp/luci-indexcache /tmp/luci-modulecache
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

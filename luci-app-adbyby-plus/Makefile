# Copyright (C) 2020 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-adbyby-plus
PKG_VERSION:=2.0
PKG_RELEASE:=75
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for Adbyby
	PKGARCH:=all
	DEPENDS:=+adbyby +uclient-fetch +ipset +dnsmasq-full
endef

define Package/$(PKG_NAME)/description
	LuCI support for Adbyby
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
	po2lmo ./po/zh-cn/adbyby.po $(1)/usr/lib/lua/luci/i18n/adbyby.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

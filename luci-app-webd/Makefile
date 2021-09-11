# Copyright (C) 2018-2019 Lienol
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-webd
PKG_VERSION:=v1.0.1
PKG_RELEASE:=2
PKG_MAINTAINER:=<https://webd.cf/>
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for webd
	PKGARCH:=all
	DEPENDS:=
endef

define Package/$(PKG_NAME)/description
	LuCI support for webd
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
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/webd.po $(1)/usr/lib/lua/luci/i18n/webd.lmo
	$(INSTALL_DIR) $(1)/usr/bin
ifeq ($(ARCH),mipsel)
	$(INSTALL_BIN) ./bin/mipsel $(1)/usr/bin/webd
endif
ifeq ($(ARCH),mips)
	$(INSTALL_BIN) ./bin/mips $(1)/usr/bin/webd
endif
ifeq ($(ARCH),i386)
	$(INSTALL_BIN) ./bin/x86_64 $(1)/usr/bin/webd
endif
ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./bin/x86_64 $(1)/usr/bin/webd
endif
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./bin/arm $(1)/usr/bin/webd
endif
endef

$(eval $(call BuildPackage,$(PKG_NAME)))



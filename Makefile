include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-miniproxy
PKG_VERSION:=4.2
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Mitsuha <i@mitsuha.me>
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-miniproxy
	SECTION:=Custom
	CATEGORY:=Extra packages
	TITLE:=Easy set transparent proxy for openwrt.
	DEPENDS:=+luci-base +ip-full +PACKAGE_firewall4:kmod-nft-tproxy +PACKAGE_firewall:ipset +PACKAGE_firewall:kmod-ipt-tproxy +PACKAGE_firewall:iptables +PACKAGE_firewall:iptables-mod-tproxy
	PKGARCH:=all
endef

define Package/luci-app-miniproxy/description
	Easy set transparent proxy for openwrt.
endef

define Build/Compile
endef

define Package/luci-app-miniproxy/conffiles
/etc/config/miniproxy
endef

define Package/luci-app-miniproxy/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d/
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d/
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_BIN) ./files/miniproxy.init $(1)/etc/init.d/miniproxy
	$(INSTALL_CONF) ./files/miniproxy.conf $(1)/etc/config/miniproxy
	$(INSTALL_DATA) ./files/miniproxy.acl $(1)/usr/share/rpcd/acl.d/luci-app-miniproxy.json
	$(INSTALL_DATA) ./files/miniproxy.menu $(1)/usr/share/luci/menu.d/luci-app-miniproxy.json
	$(INSTALL_DATA) ./files/miniproxy.js $(1)/www/luci-static/resources/view/miniproxy.js
	po2lmo ./files/miniproxy.zh-cn.po $(1)/usr/lib/lua/luci/i18n/miniproxy.zh-cn.lmo
ifdef CONFIG_PACKAGE_firewall
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/miniproxy.fw3 $(1)/usr/bin/miniproxy
endif
ifdef CONFIG_PACKAGE_firewall4
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) ./files/miniproxy.fw4 $(1)/usr/bin/miniproxy
endif
endef

$(eval $(call BuildPackage,luci-app-miniproxy))

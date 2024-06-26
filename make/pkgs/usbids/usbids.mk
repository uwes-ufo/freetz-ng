USBIDS_GIT_REPOSITORY:=https://github.com/usbids/usbids.git
$(call PKG_INIT_BIN, $(if $(FREETZ_PACKAGE_USBIDS_VERSION_LATEST), $(call git-get-latest-revision,$(USBIDS_GIT_REPOSITORY),),c70eea490a))
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=ca5073cfb5a24d99dd9f300adc71681305b5e92638e5ee55db9ec54492f9e8c6
$(PKG)_SITE:=git@$($(PKG)_GIT_REPOSITORY)
### WEBSITE:=http://www.linux-usb.org/usb-ids.html
### CHANGES:=https://github.com/usbids/usbids/commits/master
### CVSREPO:=https://github.com/usbids/usbids
### SUPPORT:=fda77

$(PKG)_BINARY:=$($(PKG)_DIR)/usb.ids
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/share/usb.ids


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)

$($(PKG)_BINARY): $($(PKG)_DIR)/.unpacked

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_FILE)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-uninstall:
	$(RM) $(USBIDS_TARGET_BINARY)

$(PKG_FINISH)

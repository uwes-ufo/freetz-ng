$(call PKG_INIT_BIN, 3.3.0)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=7399e9a6708c32d678a72a63219e96f23be0be2336e50fd1348498d07041df90
$(PKG)_SITE:=@SAMBA/rsync/src
### WEBSITE:=https://rsync.samba.org/
### MANPAGE:=https://rsync.samba.org/documentation.html
### CHANGES:=https://download.samba.org/pub/rsync/NEWS
### CVSREPO:=https://git.samba.org/?p=rsync.git
### SUPPORT:=fda77

$(PKG)_BINARY:=$($(PKG)_DIR)/rsync
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/rsync

$(PKG)_EXCLUDED+=$(if $(FREETZ_PACKAGE_RSYNC_REMOVE_WEBIF),usr/lib/cgi-bin/rsync.cgi etc/default.rsync etc/init.d/rc.rsync)

$(PKG)_DEPENDS_ON += popt zlib

$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_IPV6_SUPPORT

$(PKG)_CONFIGURE_OPTIONS += --disable-debug
$(PKG)_CONFIGURE_OPTIONS += --disable-md2man
$(PKG)_CONFIGURE_OPTIONS += --disable-simd
$(PKG)_CONFIGURE_OPTIONS += --disable-asm
$(PKG)_CONFIGURE_OPTIONS += --disable-locale
$(PKG)_CONFIGURE_OPTIONS += --disable-openssl
$(PKG)_CONFIGURE_OPTIONS += --disable-xxhash
$(PKG)_CONFIGURE_OPTIONS += --disable-zstd
$(PKG)_CONFIGURE_OPTIONS += --disable-lz4
$(PKG)_CONFIGURE_OPTIONS += --disable-iconv
$(PKG)_CONFIGURE_OPTIONS += --disable-acl-support
$(PKG)_CONFIGURE_OPTIONS += --without-included-popt
$(PKG)_CONFIGURE_OPTIONS += --without-included-zlib
$(PKG)_CONFIGURE_OPTIONS += --with-nobody-group=nobody
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_TARGET_IPV6_SUPPORT),,--disable-ipv6)


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(RSYNC_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(RSYNC_DIR) clean
	$(RM) $(RSYNC_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(RSYNC_TARGET_BINARY)

$(PKG_FINISH)

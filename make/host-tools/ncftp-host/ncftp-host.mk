$(call TOOLS_INIT, 3.2.8)
$(PKG)_SOURCE:=ncftp-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_HASH:=db7da662458a1643209d6869465c38ec811f8975a6ac54fd20c63a3349f7dbf4
$(PKG)_SITE:=https://www.ncftp.com/downloads/ncftp,https://www.ncftp.com/public_ftp/ncftp/older_versions,https://www.ncftp.com/public_ftp/ncftp
### WEBSITE:=https://www.ncftp.com/ncftp/
### MANPAGE:=https://www.ncftp.com/ncftp/doc/faq.html
### CHANGES:=https://www.ncftp.com/download/
### SUPPORT:=fda77

$(PKG)_BINARIES_ALL := ncftp ncftpput  ncftpget ncftpls  ncftpbatch
$(PKG)_BINARIES := ncftp ncftpput  ncftpget ncftpls
$(PKG)_BINARIES_BUILD_DIR := $($(PKG)_BINARIES:%=$($(PKG)_DIR)/bin/%)
$(PKG)_BINARIES_TARGET_DIR := $($(PKG)_BINARIES:%=$(TOOLS_DIR)/%)
$(PKG)_BINARIES_TARGET_DIR_ALL := $($(PKG)_BINARIES_ALL:%=$(TOOLS_DIR)/%)

$(PKG)_CONFIGURE_OPTIONS += --disable-ccdv
$(PKG)_CONFIGURE_OPTIONS += --without-curses
$(PKG)_CONFIGURE_OPTIONS += --without-ncurses

$(PKG)_CFLAGS := $(TOOLS_CFLAGS)
$(PKG)_CFLAGS += -fcommon
$(PKG)_LDFLAGS := $(TOOLS_LDFLAGS)


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_BINARIES_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(NCFTP_HOST_DIR) \
		CC="$(TOOLS_CC)" \
		CFLAGS="$(NCFTP_HOST_CFLAGS)"

$($(PKG)_BINARIES_TARGET_DIR): $(TOOLS_DIR)/%: $($(PKG)_DIR)/bin/%
	$(INSTALL_FILE)

$(pkg)-precompiled: $($(PKG)_BINARIES_TARGET_DIR)


$(pkg)-clean:
	-$(MAKE) -C $(NCFTP_HOST_DIR) clean
	-$(RM) $(NCFTP_HOST_DIR)/.{configured,compiled}

$(pkg)-dirclean:
	$(RM) -r $(NCFTP_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) $(NCFTP_HOST_BINARIES_TARGET_DIR_ALL)

$(TOOLS_FINISH)

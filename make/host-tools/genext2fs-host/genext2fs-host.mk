$(call TOOLS_INIT, 4c1cc9468980448ca3e86db1cbe9600a4a084f5e)
$(PKG)_SOURCE:=genext2fs-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=a59f657ce6d12013d7343c7b84928723f0b8dec4a89e9542802c1257dce26ba6
$(PKG)_SITE:=git@https://github.com/bestouff/genext2fs.git
# see http://genext2fs.cvs.sourceforge.net/viewvc/genext2fs/genext2fs/genext2fs.c?view=log for more info
#$(PKG)_VERSION:=20131004
#$(PKG)_HASH:=492052c02f774fa15e8d2dc0a49d0749d97ababbaf40ac7d3e93eda99b6fc777
#$(PKG)_SITE:=cvs@pserver:anonymous@genext2fs.cvs.sourceforge.net:/cvsroot/genext2fs

$(PKG)_PATCH_POST_CMDS := mv configure.in configure.ac;
$(PKG)_CONFIGURE_PRE_CMDS += $(AUTORECONF)
$(PKG)_CONFIGURE_OPTIONS += --prefix=$(FREETZ_BASE_DIR)/$(TOOLS_DIR)


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/genext2fs: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(GENEXT2FS_HOST_DIR) all
	touch -c $@

$(pkg)-test: $($(PKG)_DIR)/.tests-passed
$($(PKG)_DIR)/.tests-passed: $($(PKG)_DIR)/genext2fs
	(cd $(GENEXT2FS_HOST_DIR); ./test.sh)
	touch $@

$(TOOLS_DIR)/genext2fs: $($(PKG)_DIR)/genext2fs
	$(INSTALL_FILE)

$(pkg)-precompiled: $(TOOLS_DIR)/genext2fs


$(pkg)-clean:
	-$(MAKE) -C $(GENEXT2FS_HOST_DIR) clean
	$(RM) $(GENEXT2FS_HOST_DIR)/.configured $(GENEXT2FS_HOST_DIR)/.tests-passed

$(pkg)-dirclean:
	$(RM) -r $(GENEXT2FS_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) $(TOOLS_DIR)/genext2fs

$(TOOLS_FINISH)

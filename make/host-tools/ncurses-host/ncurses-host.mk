$(call TOOLS_INIT, 6.3)
$(PKG)_SOURCE:=ncurses-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=97fc51ac2b085d4cde31ef4d2c3122c21abc217e9090a43a30fc5ec21684e059
$(PKG)_SITE:=@GNU/ncurses


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/progs/tic: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(NCURSES_HOST_DIR) all
	touch -c $@

$(TOOLS_DIR)/tic: $($(PKG)_DIR)/progs/tic
	$(INSTALL_FILE)

$(pkg)-precompiled: $(TOOLS_DIR)/tic


$(pkg)-clean:
	-$(MAKE) -C $(NCURSES_HOST_DIR) clean

$(pkg)-dirclean:
	$(RM) -r $(NCURSES_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) $(TOOLS_DIR)/tic

$(TOOLS_FINISH)

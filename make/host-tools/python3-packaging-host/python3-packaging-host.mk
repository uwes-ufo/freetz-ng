$(call TOOLS_INIT, 24.2)
$(PKG)_SOURCE_DOWNLOAD_NAME:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE:=$(pkg_short)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=c448ea78de5134f5002a2aa2bb62a0fb4714bb4ab2d2b00bce8ed6ca22502d5a
$(PKG)_SITE:=https://github.com/pypa/packaging/archive/refs/tags
### WEBSITE:=https://pypi.org/project/packaging/
### MANPAGE:=https://packaging.pypa.io/
### CHANGES:=https://github.com/pypa/packaging/releases
### CVSREPO:=https://github.com/pypa/packaging
### SUPPORT:=fda77

$(PKG)_DEPENDS_ON+=python3-host

$(PKG)_DIRECTORY:=$($(PKG)_DIR)/src/packaging
$(PKG)_TARGET_DIRECTORY:=$(HOST_TOOLS_DIR)/usr/lib/python$(call GET_MAJOR_VERSION,$(PYTHON3_HOST_VERSION))/site-packages/packaging


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)

$($(PKG)_DIR)/.installed: $($(PKG)_DIR)/.unpacked
	cp -fa $(PYTHON3_PACKAGING_HOST_DIRECTORY) $(dir $(PYTHON3_PACKAGING_HOST_TARGET_DIRECTORY))
	@touch $@

$(pkg)-precompiled: $($(PKG)_DIR)/.installed


$(pkg)-clean:

$(pkg)-dirclean:
	$(RM) -r $(PYTHON3_PACKAGING_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r $(PYTHON3_PACKAGING_HOST_TARGET_DIRECTORY)

$(TOOLS_FINISH)

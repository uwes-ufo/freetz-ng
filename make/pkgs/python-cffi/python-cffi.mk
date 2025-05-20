$(call PKG_INIT_BIN,1.15.1)
# Since version 1.16 only Python3 is supported!
$(PKG)_SOURCE:=cffi-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=https://files.pythonhosted.org/packages/source/c/cffi
$(PKG)_HASH:=d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9
### WEBSITE:=https://cffi.readthedocs.io
### MANPAGE:=https://cffi.readthedocs.io/en/stable/overview.html
### CHANGES:=https://github.com/python-cffi/cffi/releases
### CVSREPO:=https://github.com/python-cffi/cffi

$(PKG)_DEPENDS_ON += python
$(PKG)_DEPENDS_ON += python2-host python2-setuptools-host


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_DIR)/.compiled: $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_CFFI, , CFLAGS="$(TARGET_CFLAGS) -I$(TARGET_TOOLCHAIN_STAGING_DIR)/include/python2.7" CPPFLAGS="$(TARGET_CFLAGS) -I$(TARGET_TOOLCHAIN_STAGING_DIR)/include/python2.7" PYTHON_INCDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)/include/python2.7" PYTHONHOME=$(HOST_TOOLS_DIR)/usr)
	@touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_DIR)/.compiled


$(pkg)-clean:
	$(RM) $(PYTHON_CFFI_DIR)/{.configured,.compiled}
	$(RM) -r $(PYTHON_CFFI_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/_cffi_backend.so \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi-*.egg-info

$(PKG_FINISH)

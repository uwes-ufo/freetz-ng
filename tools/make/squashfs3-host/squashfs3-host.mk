SQUASHFS3_HOST_VERSION:=3.4
SQUASHFS3_HOST_SOURCE:=squashfs$(SQUASHFS3_HOST_VERSION).tar.gz
SQUASHFS3_HOST_SOURCE_MD5:=2a4d2995ad5aa6840c95a95ffa6b1da6
SQUASHFS3_HOST_SITE:=@SF/squashfs

SQUASHFS3_HOST_MAKE_DIR:=$(TOOLS_DIR)/make/squashfs3-host
SQUASHFS3_HOST_DIR:=$(TOOLS_SOURCE_DIR)/squashfs$(SQUASHFS3_HOST_VERSION)
SQUASHFS3_HOST_BUILD_DIR:=$(SQUASHFS3_HOST_DIR)/squashfs-tools

SQUASHFS3_HOST_TOOLS:=mksquashfs unsquashfs
SQUASHFS3_HOST_TOOLS_BUILD_DIR:=$(SQUASHFS3_HOST_TOOLS:%=$(SQUASHFS3_HOST_BUILD_DIR)/%-multi)
SQUASHFS3_HOST_TOOLS_TARGET_DIR:=$(SQUASHFS3_HOST_TOOLS:%=$(TOOLS_DIR)/%3-multi)


squashfs3-host-source: $(DL_DIR)/$(SQUASHFS3_HOST_SOURCE)
$(DL_DIR)/$(SQUASHFS3_HOST_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(SQUASHFS3_HOST_SOURCE) $(SQUASHFS3_HOST_SITE) $(SQUASHFS3_HOST_SOURCE_MD5)

squashfs3-host-unpacked: $(SQUASHFS3_HOST_DIR)/.unpacked
$(SQUASHFS3_HOST_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS3_HOST_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES)
	$(call UNPACK_TARBALL,$(DL_DIR)/$(SQUASHFS3_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	$(call APPLY_PATCHES,$(SQUASHFS3_HOST_MAKE_DIR)/patches,$(SQUASHFS3_HOST_DIR))
	touch $@

$(SQUASHFS3_HOST_TOOLS_BUILD_DIR): $(SQUASHFS3_HOST_DIR)/.unpacked $(LZMA1_HOST_DIR)/liblzma1.a
	$(TOOL_SUBMAKE) -C $(SQUASHFS3_HOST_BUILD_DIR) \
		CC="$(TOOLS_CC)" \
		CXX="$(TOOLS_CXX)" \
		CFLAGS="$(TOOLS_CFLAGS) -fcommon" \
		LDFLAGS="$(TOOLS_LDFLAGS)" \
		LZMA1_SUPPORT=1 \
		LZMA_LIBNAME=lzma1 \
		LZMA_DIR="$(abspath $(LZMA1_HOST_DIR))" \
		$(SQUASHFS3_HOST_TOOLS:%=%-multi)
	touch -c $@

$(SQUASHFS3_HOST_TOOLS_TARGET_DIR): $(TOOLS_DIR)/%3-multi: $(SQUASHFS3_HOST_BUILD_DIR)/%-multi
	$(INSTALL_FILE)

squashfs3-host-precompiled: $(SQUASHFS3_HOST_TOOLS_TARGET_DIR)


squashfs3-host-clean:
	-$(MAKE) -C $(SQUASHFS3_HOST_BUILD_DIR) clean

squashfs3-host-dirclean:
	$(RM) -r $(SQUASHFS3_HOST_DIR)

squashfs3-host-distclean: squashfs3-host-dirclean
	$(RM) $(SQUASHFS3_HOST_TOOLS_TARGET_DIR)


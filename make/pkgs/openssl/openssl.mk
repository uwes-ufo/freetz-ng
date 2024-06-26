$(call PKG_INIT_BIN,$(if $(FREETZ_OPENSSL_VERSION_0),0.9.8zh,$(if $(FREETZ_OPENSSL_VERSION_1),1.0.2u,$(if $(FREETZ_OPENSSL_VERSION_2),1.1.1w,3.0.14))))
$(PKG)_LIB_VERSION:=$(call qstrip,$(FREETZ_OPENSSL_SHLIB_VERSION))
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH_0.9:=f1d9f3ed1b85a82ecf80d0e2d389e1fda3fca9a4dba0bf07adbf231e1a5e2fd6
$(PKG)_HASH_1.0:=ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16
$(PKG)_HASH_1.1:=cf3098950cb4d853ad95c0841f1f9c6d3dc102dccfcacd521d93925208b76ac8
$(PKG)_HASH_3.0:=eeca035d4dd4e84fc25846d952da6297484afa0650a6f84c682e39df3a4123ca
$(PKG)_HASH:=$($(PKG)_HASH_$(call GET_MAJOR_VERSION,$($(PKG)_VERSION)))
$(PKG)_SITE_SUFFIX_0.9:=/old/0.9.x
$(PKG)_SITE_SUFFIX_1.0:=/old/1.0.2
$(PKG)_SITE:=https://www.openssl.org/source$($(PKG)_SITE_SUFFIX_$(call GET_MAJOR_VERSION,$($(PKG)_VERSION)))
### WEBSITE:=https://www.openssl.org/source/
### MANPAGE:=https://www.openssl.org/docs/
### CHANGES:=https://www.openssl.org/news/changelog.html
### CVSREPO:=https://github.com/openssl/openssl
### SUPPORT:=fda77

$(PKG)_CONDITIONAL_PATCHES+=$(call GET_MAJOR_VERSION,$($(PKG)_VERSION))

# Makefile is regenerated by configure
$(PKG)_PATCH_POST_CMDS += $(RM) Makefile Makefile.bak;
$(PKG)_PATCH_POST_CMDS += ln -s Configure configure;

$(PKG)_BINARY_BUILD_DIR := $($(PKG)_DIR)/apps/openssl
$(PKG)_BINARY_TARGET_DIR := $($(PKG)_DEST_DIR)/usr/bin/openssl

$(PKG)_LIBNAMES_SHORT := libssl libcrypto
$(PKG)_LIBNAMES_LONG := $($(PKG)_LIBNAMES_SHORT:%=%.so.$($(PKG)_LIB_VERSION))

$(PKG)_LIBS_BUILD_DIR :=$($(PKG)_LIBNAMES_LONG:%=$($(PKG)_DIR)/%)
$(PKG)_LIBS_STAGING_DIR := $($(PKG)_LIBNAMES_LONG:%=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%)
$(PKG)_LIBS_TARGET_DIR := $($(PKG)_LIBNAMES_LONG:%=$($(PKG)_TARGET_LIBDIR)/%)

$(PKG)_DEPENDS_ON += $(if $(FREETZ_LIB_libcrypto_WITH_ZLIB),zlib)
$(PKG)_DEPENDS_ON += $(if $(FREETZ_OPENSSL_VERSION_3_MIN),libatomic)

$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libcrypto_WITH_EC
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libcrypto_WITH_RC4
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libcrypto_WITH_ZLIB
$(PKG)_REBUILD_SUBOPTS += FREETZ_OPENSSL_SHLIB_VERSION
$(PKG)_REBUILD_SUBOPTS += FREETZ_OPENSSL_SMALL_FOOTPRINT
$(PKG)_REBUILD_SUBOPTS += FREETZ_OPENSSL_CONFIG_DIR
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENSSL_TRACE
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENSSL_STATIC

$(PKG)_NO_CIPHERS := no-idea no-md2 no-mdc2 no-rc2 no-rc5 no-camellia no-ssl3
$(PKG)_NO_CIPHERS += $(if $(FREETZ_OPENSSL_VERSION_2_MAX),no-ssl2)
$(PKG)_NO_CIPHERS += $(if $(FREETZ_OPENSSL_VERSION_1_MAX),no-sha0 no-smime no-aes192 no-ripemd no-rmd160 no-ans1 no-krb5)
#$(PKG)_NO_CIPHERS += $(if $(FREETZ_OPENSSL_VERSION_1_MAX),no-sha0 no-smime no-aes192 $(if $(FREETZ_PACKAGE_PERL),,no-ripemd) no-rmd160 no-ans1 no-krb5)
$(PKG)_NO_CIPHERS += $(if $(FREETZ_LIB_libcrypto_WITH_RC4),,no-rc4)

$(PKG)_OPTIONS    := shared no-err no-sse2 no-capieng no-seed
$(PKG)_OPTIONS    += $(if $(FREETZ_OPENSSL_VERSION_2_MAX),no-hw)
$(PKG)_OPTIONS    += $(if $(FREETZ_OPENSSL_VERSION_1_MAX),no-fips no-engines)
$(PKG)_OPTIONS    += $(if $(FREETZ_LIB_libcrypto_WITH_EC),,no-ec)
$(PKG)_OPTIONS    += $(if $(FREETZ_LIB_libcrypto_WITH_ZLIB),zlib)
$(PKG)_OPTIONS    += $(if $(FREETZ_OPENSSL_VERSION_0),no-perlasm no-cms)
$(PKG)_OPTIONS    += $(if $(FREETZ_OPENSSL_VERSION_1),no-store)
$(PKG)_OPTIONS    += $(if $(FREETZ_OPENSSL_VERSION_1_MIN),no-ec_nistp_64_gcc_128 no-sctp no-srp no-whirlpool)
$(PKG)_OPTIONS    += $(if $(FREETZ_PACKAGE_OPENSSL_TRACE),enable-ssl-trace)

$(PKG)_CONFIGURE_DEFOPTS := n
$(PKG)_CONFIGURE_OPTIONS += linux-freetz-$(call qstrip,$(FREETZ_TARGET_ARCH_ENDIANNESS_DEPENDENT))$(if $(FREETZ_OPENSSL_VERSION_1_MIN),-asm)
$(PKG)_CONFIGURE_OPTIONS += --prefix=/usr
$(PKG)_CONFIGURE_OPTIONS += --openssldir=$(FREETZ_OPENSSL_CONFIG_DIR)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_OPENSSL_SMALL_FOOTPRINT),-DOPENSSL_SMALL_FOOTPRINT)
$(PKG)_CONFIGURE_OPTIONS += $(OPENSSL_NO_CIPHERS)
$(PKG)_CONFIGURE_OPTIONS += $(OPENSSL_OPTIONS)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_OPENSSL_VERSION_2_MIN),-DOPENSSL_NO_ASYNC)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_OPENSSL_VERSION_3_MIN),-latomic)

$(PKG)_MAKE_FLAGS += -C $(OPENSSL_DIR)
$(PKG)_MAKE_FLAGS += MAKEDEPPROG="$(TARGET_CC)"
$(PKG)_MAKE_FLAGS += CC="$(TARGET_CC)"
$(PKG)_MAKE_FLAGS += AR="$(TARGET_AR)$(if $(FREETZ_OPENSSL_VERSION_1_MAX), r)"
$(PKG)_MAKE_FLAGS += RANLIB="$(TARGET_RANLIB)"
$(PKG)_MAKE_FLAGS += NM="$(TARGET_NM)"
$(PKG)_MAKE_FLAGS += FREETZ_MOD_OPTIMIZATION_FLAGS="$(TARGET_CFLAGS) -ffunction-sections -fdata-sections"
$(PKG)_MAKE_FLAGS += SHARED_LDFLAGS=""
$(PKG)_MAKE_FLAGS += $(if $(FREETZ_OPENSSL_VERSION_1_MAX),INSTALL_PREFIX,DESTDIR)="$(TARGET_TOOLCHAIN_STAGING_DIR)"
$(PKG)_MAKE_FLAGS += CROSS_COMPILE=1
$(PKG)_MAKE_FLAGS += $(if $(FREETZ_PACKAGE_OPENSSL_STATIC),STATIC_APPS=1)


# openssl-host and openssl using the same source
ifneq ($($(PKG)_SOURCE),$(OPENSSL_HOST_SOURCE))
$(PKG_SOURCE_DOWNLOAD)
endif
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY_BUILD_DIR) $($(PKG)_LIBS_BUILD_DIR): $($(PKG)_DIR)/.configured
#	OpenSSL's "make depend" looks for installed headers before its own,
#	so remove installed stuff from the staging dir first.
#	Remove installed libs also from freetz' packages dir to ensure
#	that it doesn't contain files from previous builds (0.9.8 to/from 1.0.x switch).
	$(MAKE) openssl-clean-staging openssl-uninstall $(SILENT)
	$(SUBMAKE1) $(OPENSSL_MAKE_FLAGS) depend
	$(SUBMAKE) $(OPENSSL_MAKE_FLAGS) all

$($(PKG)_LIBS_STAGING_DIR): $($(PKG)_LIBS_BUILD_DIR)
	$(SUBMAKE) $(OPENSSL_MAKE_FLAGS) $(if $(FREETZ_OPENSSL_VERSION_1_MAX),install,install_sw)
	$(call PKG_FIX_LIBTOOL_LA,prefix) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/{libcrypto,libssl,openssl}.pc

$($(PKG)_BINARY_TARGET_DIR): $($(PKG)_BINARY_BUILD_DIR)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_LIBS_TARGET_DIR): $($(PKG)_TARGET_LIBDIR)/%: $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_LIBS_STAGING_DIR)

$(pkg)-precompiled: $($(PKG)_BINARY_TARGET_DIR) $($(PKG)_LIBS_TARGET_DIR)


$(pkg)-clean: $(pkg)-clean-staging
	-$(SUBMAKE) $(OPENSSL_MAKE_FLAGS) clean

$(pkg)-clean-staging:
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/openssl* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/{libssl,libcrypto}* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/{libssl,libcrypto,openssl}* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/openssl

$(pkg)-uninstall:
	$(RM) $(OPENSSL_BINARY_TARGET_DIR) $(OPENSSL_TARGET_LIBDIR)/{libssl,libcrypto}*.so*

$(call PKG_ADD_LIB,libcrypto)
$(PKG_FINISH)

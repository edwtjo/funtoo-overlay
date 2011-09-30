# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-config/gcc-config-1.4.1.ebuild,v 1.9 2009/05/20 17:43:36 armin76 Exp $

inherit flag-o-matic toolchain-funcs multilib

# Version of .c wrapper to use
W_VER="1.5.1"

DESCRIPTION="Utility to change the gcc compiler being used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!app-admin/eselect-compiler sys-apps/openrc"

S=${WORKDIR}

src_unpack() {
	cp "${FILESDIR}"/wrapper-${W_VER}.c "${S}"/wrapper.c || die
}

src_compile() {
	strip-flags
	emake CC="$(tc-getCC)" wrapper || die "compile wrapper"
}

src_install() {
	newbin "${FILESDIR}"/${PN}-${PV} ${PN} || die "install gcc-config"
	sed -i \
		-e "s:@GENTOO_LIBDIR@:$(get_libdir):g" \
		"${D}"/usr/bin/${PN}

	exeinto /usr/$(get_libdir)/misc
	newexe wrapper gcc-config || die "install wrapper"
}

pkg_postinst() {
	# Scrub eselect-compiler remains
	if [[ -e ${ROOT}/etc/env.d/05compiler ]] ; then
		rm -f "${ROOT}"/etc/env.d/05compiler
	fi

	# Make sure old versions dont exist #79062
	rm -f "${ROOT}"/usr/sbin/gcc-config

	# Do we have a valid multi ver setup ?
	if gcc-config --get-current-profile &>/dev/null ; then
		# We not longer use the /usr/include/g++-v3 hacks, as
		# it is not needed ...
		[[ -L ${ROOT}/usr/include/g++ ]] && rm -f "${ROOT}"/usr/include/g++
		[[ -L ${ROOT}/usr/include/g++-v3 ]] && rm -f "${ROOT}"/usr/include/g++-v3
		gcc-config $(/usr/bin/gcc-config --get-current-profile)
	fi
}

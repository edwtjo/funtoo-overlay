# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

XORG_DRI=always
inherit xorg-2

DESCRIPTION="ATI video driver"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
RADEON_CARDS="r100 r200 r300 r600 radeon"
VIDEO_CARDS="${RADEON_CARDS}"
for card in ${VIDEO_CARDS}; do
        IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}"

RDEPEND="|| ( x11-libs/libdrm[video_cards_radeon] 
		x11-libs/libdrm[video_cards_r300]
		x11-libs/libdrm[video_cards_r600] )"
DEPEND="${RDEPEND}"

pkg_setup() {
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		--enable-dri
		--enable-kms
		--enable-exa
	)
}

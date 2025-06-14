# Configuration file to install the recipe dependencies inside the Podman container

FROM debian:stable-backports

RUN apt-get update \
	&& apt-get install -y --no-install-recommends -t stable-backports \
		ant \
		appstream \
		appstream-compose \
		autoconf \
		autoconf2.69 \
		automake \
		autopoint \
		bison \
		bsdextrautils \
		build-essential \
		clang \
		cmake \
		curl \
		dos2unix \
		doxygen \
		expect \
		file \
		flex \
		fuse3 \
		g++ \
		genisoimage \
		git \
		git-lfs \
		gperf \
		gtk-doc-tools \
		help2man \
		intltool \
		libexpat-dev \
		libfontconfig1-dev \
		libfuse3-dev \
		libgdk-pixbuf2.0-bin \
		libglib2.0-dev-bin \
		libgmp-dev \
		libhtml-parser-perl \
		libjpeg-dev \
		libmpfr-dev \
		libparse-yapp-perl \
		libpng-dev \
		libsdl1.2-dev \
		libsdl2-ttf-dev \
		llvm \
		lua5.4 \
		lzip \
		m4 \
		make \
		meson \
		nasm \
		ninja-build \
		patch \
		patchelf \
		perl \
		pkg-config \
		po4a \
		protobuf-compiler \
		python3 \
		python3-dev \
		python3-mako \
		python3-venv \
		rsync \
		ruby \
		scons \
		ssh \
		texinfo \
		unifdef \
		unzip \
		wget \
		xdg-utils \
		xfonts-utils \
		xorg-dev \
		xutils-dev \
		xxd \
		zip \
		zlib1g-dev \
		zstd; \
	if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
    	apt-get install -y --no-install-recommends libc6-dev-i386 syslinux-utils; fi; apt-get clean

# TODO: Rust installation. But CI defaults to /github/home

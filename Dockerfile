FROM debian/eol:buster-slim
ENV DEBIAN_FRONTEND noninteractive

# Timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Packages
RUN apt-get -y update
RUN apt-get -y install \
	bc \
	build-essential \
	bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	make \
	p7zip-full \
	rsync \
	scons \
	sqlite3 \
	tree \
	unzip \
	wget \
	zip \
	locales \
	libsdl1.2-dev \
	libsdl-image1.2-dev \
	libsdl-ttf2.0-dev \
	libsdl-gfx1.2-dev \
	libgtest-dev \
	cppcheck

RUN rm -rf /var/lib/apt/lists/*

# Locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
	locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Workspace
RUN mkdir -p /root/workspace
WORKDIR /root

# Setup
COPY support .
RUN ./setup-toolchain.sh
RUN cat setup-env.sh >> .bashrc
RUN ./setup-sqlite.sh
RUN ./setup-gtest.sh

VOLUME /root/workspace
WORKDIR /root/workspace

CMD ["/bin/bash"]
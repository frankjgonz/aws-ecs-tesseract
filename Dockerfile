FROM lambci/lambda:build-python3.7

ARG LEPTONICA_VERSION=1.80.0
#ARG TESSERACT_VERSION=4.1.0-rc4
ARG AUTOCONF_ARCHIVE_VERSION=2019.01.06
ENV LIB_DIR=/python
ARG TMP_BUILD=/tmp
ARG TESS_OPT=/opt/tesseract
ARG LEPT_OPT=/opt/leptonica
ARG DIST_OPT=/opt/build-dist
# change TESSERACT_DATA_SUFFIX to use different datafiles (options: "_best", "_fast" and "")
ARG TESSERACT_DATA_SUFFIX=_fast
ARG TESSERACT_DATA_VERSION=4.0.0

RUN yum makecache fast; \
    yum -y update && yum -y upgrade && \
    yum install -y yum-plugin-ovl && yum clean all && yum -y groupinstall "Development Tools" && \
    yum clean all

RUN yum -y install gcc gcc-c++ make autoconf automake libtool \
    libjpeg-devel libpng-devel libtiff-devel zlib-devel \
    libzip-devel lcms2-devel libwebp-devel \
    libicu-devel pango-devel cairo-devel; \
    yum clean all

WORKDIR /tmp/leptonica-build
# This includes requirements.txt and the Leptonica tar file
COPY . .
RUN tar xf leptonica-${LEPTONICA_VERSION}.tar.gz && \
    cd leptonica-${LEPTONICA_VERSION} && \
    ./configure --prefix=${LEPT_OPT} && \
    make && make install && \
    cp -r ./src/.libs /opt/liblept

RUN echo "/opt/leptonica/lib" > /etc/ld.so.conf.d/leptonica.conf && ldconfig

WORKDIR /tmp/autoconf-build
RUN curl https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-${AUTOCONF_ARCHIVE_VERSION}.tar.xz | tar xJ && \
    cd autoconf-archive-${AUTOCONF_ARCHIVE_VERSION} && ./configure && make && make install && cp ./m4/* /usr/share/aclocal/

WORKDIR /tmp/tesseract-build
RUN git clone https://github.com/tesseract-ocr/tesseract.git

#RUN cd tesseract/tesseract
#RUN ./autogen.sh
#RUN autoreconf -i
#RUN PKG_CONFIG_PATH=/opt/leptonica/lib/pkgconfig LIBLEPT_HEADERSDIR=/opt/leptonica/include \ 
#    ./configure --prefix=/opt/tesseract/ --with-extra-includes=/opt/leptonica/include \
#    --with-extra-libraries=/opt/leptonica/lib
#RUN make
#RUN LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make && \
#RUN make install
#RUN ldconfig

EXPOSE 80

CMD bash


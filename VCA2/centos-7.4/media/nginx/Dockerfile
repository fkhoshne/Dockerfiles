
FROM centos:7.4.1708 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/lib64 --disable-doc && \ 
    make -j8 && \
    make install


# Build nginx-http-flv
ARG NGINX_HTTP_FLV_VER=04dc8369b260c8c851f12fc30ea2f9df03f73c4e
ARG NGINX_HTTP_FLV_REPO=https://github.com/winshining/nginx-http-flv-module.git

ARG NGINX_HTTP_FLV_PATCHES_RELEASE_VER=0.1
ARG NGINX_HTTP_FLV_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}.tar.gz
ARG NGINX_HTTP_FLV_PATCHES_PATH=/home/CDN-${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}
RUN wget -O - ${NGINX_HTTP_FLV_PATCHES_RELEASE_URL} | tar xz

RUN git clone ${NGINX_HTTP_FLV_REPO} && \
    cd nginx-http-flv-module && \
    git checkout ${NGINX_HTTP_FLV_VER} && \
    mkdir -p /home/build/var/www/html && \
    cp -f stat.xsl /home/build/var/www/html && \
    find ${NGINX_HTTP_FLV_PATCHES_PATH}/Nginx-HTTP-FLV_patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;

# Build nginx-upload-module
ARG NGINX_UPLOAD_VER=2.3.0
ARG NGINX_UPLOAD_REPO=https://github.com/fdintino/nginx-upload-module/archive/${NGINX_UPLOAD_VER}.tar.gz

RUN wget -O - ${NGINX_UPLOAD_REPO} | tar xz

# Build nginx & nginx-rtmp
ARG NGINX_VER=1.14.2
ARG NGINX_REPO=https://nginx.org/download/nginx-${NGINX_VER}.tar.gz

RUN yum install -y -q openssl-devel pcre2-devel zlib-devel libxslt-devel

RUN wget -O - ${NGINX_REPO} | tar xz && \
    cd nginx-${NGINX_VER} && \
    ./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock --http-log-path=/var/www/log/access.log --http-client-body-temp-path=/var/www/tmp/client_body --http-proxy-temp-path=/var/www/tmp/proxy --http-fastcgi-temp-path=/var/www/tmp/fastcgi --http-uwsgi-temp-path=/var/www/tmp/uwsgi --http-scgi-temp-path=/var/www/tmp/scgi --user=nobody --group=nobody --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_ssl_preread_module --with-pcre --add-module=../nginx-http-flv-module --add-module=../nginx-upload-module-${NGINX_UPLOAD_VER}  && \
    make -j8 && \
    make install DESTDIR=/home/build;

# NGINX Setup
COPY nginx.conf /home/build/etc/nginx
RUN mkdir -p /home/build/var/www/tmp/client_body && \
    mkdir -p /home/build/var/www/tmp/proxy && \
    mkdir -p /home/build/var/www/tmp/fastcgi && \
    mkdir -p /home/build/var/www/tmp/uwsgi && \
    mkdir -p /home/build/var/www/tmp/scgi && \
    mkdir -p /home/build/var/www/cache && \
    mkdir -p /home/build/var/www/dash && \
    mkdir -p /home/build/var/www/hls && \
    mkdir -p /home/build/var/www/upload && \
    mkdir -p /home/build/var/www/html && \
    touch /home/build/var/www/html/index.html;


FROM openvisualcloud/vca2-centos74-media-ffmpeg:latest
LABEL Description="This is the base image for a NGINX+RTMP service"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN  \
    yum install -y -q openssl-libs pcre2 zlib libxslt libxml2 ; \
    rm -rf /var/cache/yum/*;
# Install
COPY --from=build /home/build /
CMD /usr/sbin/nginx


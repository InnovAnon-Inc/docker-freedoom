FROM innovanon/doom-base as builder-05
USER root
COPY --from=innovanon/zlib       /tmp/zlib.txz       /tmp/
COPY --from=innovanon/bzip2      /tmp/bzip2.txz      /tmp/
COPY --from=innovanon/xz         /tmp/xz.txz         /tmp/
COPY --from=innovanon/libpng     /tmp/libpng.txz     /tmp/
COPY --from=innovanon/jpeg-turbo /tmp/jpeg-turbo.txz /tmp/
COPY --from=innovanon/deutex     /tmp/deutex.txz     /tmp/
COPY --from=innovanon/zennode    /tmp/zennode.txz    /tmp/
RUN extract.sh                                            \
 && command -v                        deutex              \
 && command -v                        ZenNode

FROM builder-05 as freedoom
ARG LFS=/mnt/lfs
USER lfs
RUN sleep 31 \
 && command -v strip.sh                 \
 && git clone --depth=1 --recursive          \
      https://github.com/freedoom/freedoom.git \
 && cd                          freedoom     \
 && make                                     \
 && mv -v {,/tmp/}wads                       \
 && cd      /tmp                             \
 && rm -rf         $LFS/sources/freedoom
 #&& make rebuild-nodes                       \
 #&& chmod -v +x scripts/* graphics/text/*    \
 #               lumps/*/* bootstrap/*        \

FROM scratch as final
COPY --from=freedoom /tmp/wads/ /tmp/wads/

